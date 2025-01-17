import 'package:flutter/material.dart';

class ResponsiveSizeAdapter {
  final BuildContext context;

  ResponsiveSizeAdapter(this.context);

  // Screen breakpoints for different devices
  static const double _mobileBreakpoint = 426;
  static const double _tabletBreakpoint = 769;
  static const double _desktopBreakpoint = 1441;

  // Scaling factors for different devices
  static const double _mobileMultiplier = 4.2;
  static const double _tabletMultiplier = 2.4;
  static const double _desktopMultiplier = 1.6;
  static const double _largeDesktopMultiplier = 1;

  // Get the appropriate multiplier based on screen width
  double _getMultiplier(double screenWidth) {
    if (screenWidth < _mobileBreakpoint) {
      return _mobileMultiplier;
    } else if (screenWidth >= _mobileBreakpoint &&
        screenWidth < _tabletBreakpoint) {
      return _tabletMultiplier;
    } else if (screenWidth >= _tabletBreakpoint &&
        screenWidth < _desktopBreakpoint) {
      return _desktopMultiplier;
    } else {
      return _largeDesktopMultiplier;
    }
  }

  double size(double baseSize) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;
      const double referenceScreenWidth = 1000.0;
      double screenWidthRatio =
          (screenWidth / referenceScreenWidth) * _getMultiplier(screenWidth);

      // Clamping the ratio to avoid extreme scaling
      screenWidthRatio = screenWidthRatio.clamp(0.5, 2.0);

      return baseSize * screenWidthRatio;
    } catch (error) {
      // Return baseSize instead of 0 as a fallback
      return baseSize;
    }
  }

  double nonMultipliedSize(double baseSize) {
    try {
      double screenWidth = MediaQuery.of(context).size.width;
      const double referenceScreenWidth = 1000.0;
      double screenWidthRatio = (screenWidth / referenceScreenWidth);
      return baseSize * screenWidthRatio;
    } catch (error) {
      return baseSize;
    }
  }

  // Responsive EdgeInsets
  EdgeInsets all(double basePadding) {
    double responsivePadding = size(basePadding);
    return EdgeInsets.all(responsivePadding);
  }

  EdgeInsets symmetric(
      {double horizontal = 0.0, double vertical = 0.0, bool? nonMultiplied}) {
    return EdgeInsets.symmetric(
      horizontal: nonMultiplied != true
          ? size(horizontal)
          : nonMultipliedSize(horizontal),
      vertical:
          nonMultiplied != true ? size(vertical) : nonMultipliedSize(vertical),
    );
  }

  EdgeInsets only(
      {double left = 0.0,
      double top = 0.0,
      double right = 0.0,
      double bottom = 0.0,
      bool? nonMultiplied}) {
    return EdgeInsets.only(
      left: nonMultiplied != true ? size(left) : nonMultipliedSize(left),
      top: nonMultiplied != true ? size(top) : nonMultipliedSize(top),
      right: nonMultiplied != true ? size(right) : nonMultipliedSize(right),
      bottom: nonMultiplied != true ? size(bottom) : nonMultipliedSize(bottom),
    );
  }

  // Responsive Offset
  Offset offset({double dx = 0.0, double dy = 0.0, bool? nonMultiplied}) {
    return Offset(nonMultiplied != true ? size(dx) : nonMultipliedSize(dx),
        nonMultiplied != true ? size(dy) : nonMultipliedSize(dy));
  }

  // Responsive Size
  Size scaledSize(
      {double width = 0.0, double height = 0.0, bool? nonMultiplied}) {
    return Size(nonMultiplied != true ? size(width) : nonMultipliedSize(width),
        nonMultiplied != true ? size(height) : nonMultipliedSize(height));
  }

  // Get screen width
  double get screenWidth => MediaQuery.of(context).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(context).size.height;
}
