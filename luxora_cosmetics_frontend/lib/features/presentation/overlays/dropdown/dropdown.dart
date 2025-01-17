import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/util/custom_timer.dart';

class DropdownOverlay {
  final BuildContext context;
  final Widget? child;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Radius borderRadius;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double shadowBlurRadius;
  final double borderWidth;
  final Color? borderColor;
  final bool persistOnHover;
  final bool dismissOnHoverExit;

  DropdownOverlay({
    required this.context,
    this.child,
    this.height,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = const Radius.circular(0.0),
    this.shadowColor,
    this.shadowOffset = const Offset(0, 2),
    this.shadowBlurRadius = 4.0,
    this.borderWidth = 1.0,
    this.borderColor,
    this.persistOnHover = false,
    this.dismissOnHoverExit = false,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;
  bool _isHovering = false;
  CustomTimer? _dismissTimer;

  Offset _calculateOffset(Offset position, Size targetWidgetSize, double width,
      DropdownAlignment dropdownAlignment) {
    double offsetX = position.dx;
    double offsetY = position.dy + targetWidgetSize.height;

    if (dropdownAlignment == DropdownAlignment.center) {
      offsetX -= (width / 2) - (targetWidgetSize.width / 2);
    } else if (dropdownAlignment == DropdownAlignment.end) {
      offsetX -= width - targetWidgetSize.width;
    }

    return Offset(offsetX, offsetY);
  }

  Offset _calculateOffsetOnLinked(Size targetWidgetSize, double width,
      DropdownAlignment dropdownAlignment) {
    double offsetX = 0;
    double offsetY = targetWidgetSize.height;

    if (dropdownAlignment == DropdownAlignment.center) {
      offsetX -= (width / 2) - (targetWidgetSize.width / 2);
    } else if (dropdownAlignment == DropdownAlignment.end) {
      offsetX -= width - targetWidgetSize.width;
    }

    return Offset(offsetX, offsetY);
  }

  Future<void> show({
    LayerLink? layerLink,
    Offset position = Offset.zero,
    required Size targetWidgetSize,
    required double width,
    required DropdownAlignment dropdownAlignment,
    Widget? child,
    Color? backgroundColor,
    Color? shadowColor,
    Color? borderColor,
    bool forceRefresh = false,
  }) async {
    // If forceRefresh is true, dismiss the current dropdown
    if (forceRefresh) {
      dismiss();
      await Future.delayed(200.ms); // Wait for dismissal animation to complete
    } else if (isShown()) {
      // If already shown and no forceRefresh, do nothing
      return;
    }

    _dismissTimer?.stop(); // Stop any running dismiss timer

    Offset adjustedOffset = layerLink != null
        ? _calculateOffsetOnLinked(targetWidgetSize, width, dropdownAlignment)
        : _calculateOffset(
            position, targetWidgetSize, width, dropdownAlignment);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: adjustedOffset.dx,
        top: adjustedOffset.dy,
        width: width,
        height: height,
        child: CompositedTransformFollower(
          link: layerLink ?? LayerLink(),
          showWhenUnlinked: true,
          offset: adjustedOffset,
          child: Material(
            color: Colors.transparent,
            child: MouseRegion(
              onEnter: (_) {
                _isHovering = true;
              },
              onExit: (_) {
                _isHovering = false;
                if (dismissOnHoverExit == true) dismiss(delay: 800.ms);
              },
              child: _buildOverlay(
                child: child ?? this.child ?? const SizedBox(),
                backgroundColor: backgroundColor ?? Colors.white,
                shadowColor: shadowColor ?? this.shadowColor,
                borderColor: borderColor ?? this.borderColor,
              ).animate(target: toggle ? 1 : 0).scaleY(
                    duration: 200.ms,
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    begin: 0,
                    end: 1,
                  ),
            ),
          ),
        ),
      ),
    );

    toggle = true;
    Overlay.of(context)
        .insert(_overlayEntry!); // Insert the updated overlay entry
  }

  void dismiss({Duration? delay, Object? key}) {
    if (!isShown() || (persistOnHover && _isHovering)) return;

    if (delay != null) {
      _dismissTimer = CustomTimer(
        onTick: (_) {},
        onTimerStop: () {
          if (!_isHovering) {
            toggle = false;
            _overlayEntry?.markNeedsBuild();
            Future.delayed(200.ms, () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            });
          }
        },
      );
      _dismissTimer!.start(duration: delay);
    } else {
      toggle = false;
      _overlayEntry?.markNeedsBuild();
      Future.delayed(200.ms, () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  bool isShown() {
    return _overlayEntry != null;
  }

  Widget _buildOverlay({
    required Widget child,
    required Color? backgroundColor,
    required Color? shadowColor,
    required Color? borderColor,
  }) {
    return TapRegion(
      onTapOutside: (event) {
        Future.delayed(210.ms, () {
          dismiss();
        });
      },
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(borderRadius),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth,
          ),
          boxShadow: shadowColor != null
              ? [
                  BoxShadow(
                    color: shadowColor,
                    offset: shadowOffset!,
                    blurRadius: shadowBlurRadius,
                  ),
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
