import 'dart:async';
import 'package:flutter/material.dart';

enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

class ResponsiveScreenAdapter extends StatefulWidget {
  final Widget? fallbackScreen;
  final Widget? screenMobile;
  final Widget? screenTablet;
  final Widget? screenDesktop;
  final Widget? screenLargeDesktop;
  final ValueChanged<ScreenSize>? onScreenChanged;
  final ValueChanged<ScreenSize>? onScreenSizeChanged;

  const ResponsiveScreenAdapter({
    super.key,
    this.fallbackScreen,
    this.screenMobile,
    this.screenTablet,
    this.screenDesktop,
    this.screenLargeDesktop,
    this.onScreenChanged,
    this.onScreenSizeChanged,
  });

  @override
  State<ResponsiveScreenAdapter> createState() =>
      _ResponsiveScreenAdapterState();
}

class _ResponsiveScreenAdapterState extends State<ResponsiveScreenAdapter> {
  ScreenSize? _currentScreenSize;
  Timer? _screenChangedDebounce;
  Timer? _screenSizeChangedDebounce;

  @override
  Widget build(BuildContext context) {
    // Get the actual screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the screen size based on the actual screen width
    ScreenSize newScreenSize = _getScreenSize(screenWidth);

    // Debounce the onScreenSizeChanged callback
    _screenSizeChangedDebounce?.cancel();
    _screenSizeChangedDebounce = Timer(const Duration(milliseconds: 100), () {
      widget.onScreenSizeChanged?.call(newScreenSize);
    });

    // Debounce the onScreenChanged callback if the screen size changes
    if (_currentScreenSize != newScreenSize) {
      _currentScreenSize = newScreenSize;
      _screenChangedDebounce?.cancel();
      _screenChangedDebounce = Timer(const Duration(milliseconds: 100), () {
        widget.onScreenChanged?.call(newScreenSize);
      });
    }

    // Display the appropriate screen based on screen size
    switch (newScreenSize) {
      case ScreenSize.mobile:
        return widget.screenMobile ??
            widget.fallbackScreen ??
            _noScreenAvailable();
      case ScreenSize.tablet:
        return widget.screenTablet ??
            widget.fallbackScreen ??
            _noScreenAvailable();
      case ScreenSize.desktop:
        return widget.screenDesktop ??
            widget.fallbackScreen ??
            _noScreenAvailable();
      case ScreenSize.largeDesktop:
        return widget.screenLargeDesktop ??
            widget.fallbackScreen ??
            _noScreenAvailable();
    }
  }

  @override
  void dispose() {
    _screenChangedDebounce?.cancel();
    _screenSizeChangedDebounce?.cancel();
    super.dispose();
  }

  ScreenSize _getScreenSize(double width) {
    // Define screen breakpoints
    const double mobileBreakpoint = 426.0;
    const double tabletBreakpoint = 769.0;
    const double desktopBreakpoint = 1441.0;

    if (width < mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width >= mobileBreakpoint && width < tabletBreakpoint) {
      return ScreenSize.tablet;
    } else if (width >= tabletBreakpoint && width < desktopBreakpoint) {
      return ScreenSize.desktop;
    } else {
      return ScreenSize.largeDesktop;
    }
  }

  Widget _noScreenAvailable() {
    return const SizedBox();
  }
}
