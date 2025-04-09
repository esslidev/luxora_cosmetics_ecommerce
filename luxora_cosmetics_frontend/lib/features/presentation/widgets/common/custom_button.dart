import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';

enum CustomButtonIconPosition { left, right, top, bottom }

class CustomButtonStyle {
  final double? width;
  final double? height;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  CustomButtonStyle({
    this.width,
    this.height,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    this.boxShadow,
    this.border,
  });
}

class CustomButton extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final String? svgIconPath;
  final double? iconWidth;
  final double? iconHeight;
  final CustomButtonIconPosition iconPosition;
  final Color? iconColor;
  final double? iconTextGap;
  final String? text;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Color? backgroundColor;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool enabled;
  final CustomButtonStyle? onHoverStyle;
  final CustomButtonStyle? onDisabledStyle;
  final bool useIntrinsicWidth;
  final Duration animationDuration;
  final Curve animationCurve;
  final MouseCursor? cursor;
  final double? lineHeight;

  final Function(Offset position, Size size)? onPressed;
  final Function(Offset position, Size size)? onHoverEnter;
  final VoidCallback? onHoverExit;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.borderRadius,
    this.svgIconPath,
    this.iconWidth,
    this.iconHeight,
    this.iconPosition = CustomButtonIconPosition.left,
    this.iconColor,
    this.iconTextGap,
    this.text,
    this.fontSize,
    this.letterSpacing,
    this.fontWeight,
    this.fontFamily,
    this.backgroundColor,
    this.textColor,
    this.boxShadow,
    this.border,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.enabled = true,
    this.onHoverStyle,
    this.onDisabledStyle,
    this.onPressed,
    this.useIntrinsicWidth = true,
    this.animationDuration = const Duration(milliseconds: 0),
    this.animationCurve = Curves.easeInOut,
    this.cursor,
    this.lineHeight,
    this.onHoverEnter,
    this.onHoverExit,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late ResponsiveSizeAdapter R;
  final GlobalKey _buttonKey = GlobalKey();
  bool _isHovered = false;

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (widget.enabled && isHovered) {
      if (widget.onHoverEnter != null) {
        final RenderBox renderBox =
            _buttonKey.currentContext!.findRenderObject() as RenderBox;
        final Offset position = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        widget.onHoverEnter!(position, size);
      }
    } else {
      widget.onHoverExit?.call();
    }
  }

  void _onPressed() {
    if (widget.enabled && widget.onPressed != null) {
      final RenderBox renderBox =
          _buttonKey.currentContext!.findRenderObject() as RenderBox;
      final Offset position = renderBox.localToGlobal(Offset.zero);
      final Size size = renderBox.size;

      widget.onPressed!(position, size);
    }
  }

  @override
  void initState() {
    super.initState();
    R = ResponsiveSizeAdapter(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled;

    // If the button is disabled, apply the `onDisabledStyle` and skip hover styles.
    final backgroundColor =
        !isEnabled
            ? widget.onDisabledStyle?.backgroundColor ?? widget.backgroundColor
            : (_isHovered
                ? widget.onHoverStyle?.backgroundColor ?? widget.backgroundColor
                : widget.backgroundColor);

    final iconColor =
        !isEnabled
            ? widget.onDisabledStyle?.iconColor ?? widget.iconColor
            : (_isHovered
                ? widget.onHoverStyle?.iconColor ?? widget.iconColor
                : widget.iconColor);

    final textColor =
        !isEnabled
            ? widget.onDisabledStyle?.textColor ?? widget.textColor
            : (_isHovered
                ? widget.onHoverStyle?.textColor ?? widget.textColor
                : widget.textColor);

    final boxShadow =
        !isEnabled
            ? widget.onDisabledStyle?.boxShadow ?? widget.boxShadow
            : (_isHovered
                ? widget.onHoverStyle?.boxShadow ?? widget.boxShadow
                : widget.boxShadow);

    final border =
        !isEnabled
            ? widget.onDisabledStyle?.border ?? widget.border
            : (_isHovered
                ? widget.onHoverStyle?.border ?? widget.border
                : widget.border);

    Widget buttonContent = AnimatedContainer(
      key: _buttonKey,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      margin: widget.margin,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: boxShadow,
        border: border,
      ),
      child: _buildButtonContent(iconColor, textColor),
    );

    return MouseRegion(
      cursor:
          widget.cursor ??
          (widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic),
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: _onPressed,
        child:
            widget.useIntrinsicWidth
                ? IntrinsicWidth(child: buttonContent)
                : buttonContent,
      ),
    );
  }

  Widget _buildButtonContent(Color? iconColor, Color? textColor) {
    if (widget.svgIconPath != null && widget.text == null) {
      return Center(child: _buildIcon(iconColor));
    }

    switch (widget.iconPosition) {
      case CustomButtonIconPosition.top:
        return Column(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            if (widget.svgIconPath != null) _buildIcon(iconColor),
            if (widget.svgIconPath != null && widget.text != null)
              SizedBox(height: widget.iconTextGap ?? R.size(6)),
            if (widget.text != null) _buildText(textColor),
          ],
        );
      case CustomButtonIconPosition.left:
        return Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            if (widget.svgIconPath != null) _buildIcon(iconColor),
            if (widget.svgIconPath != null && widget.text != null)
              SizedBox(width: widget.iconTextGap ?? R.size(6)),
            if (widget.text != null) _buildText(textColor),
          ],
        );
      case CustomButtonIconPosition.right:
        return Row(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            if (widget.text != null) _buildText(textColor),
            if (widget.text != null && widget.svgIconPath != null)
              SizedBox(width: widget.iconTextGap ?? R.size(6)),
            if (widget.svgIconPath != null) _buildIcon(iconColor),
          ],
        );
      case CustomButtonIconPosition.bottom:
        return Column(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            if (widget.text != null) _buildText(textColor),
            if (widget.text != null && widget.svgIconPath != null)
              SizedBox(height: widget.iconTextGap ?? R.size(6)),
            if (widget.svgIconPath != null) _buildIcon(iconColor),
          ],
        );
    }
  }

  Widget _buildIcon(Color? iconColor) {
    return SvgPicture.asset(
      widget.svgIconPath!,
      colorFilter:
          iconColor != null
              ? ColorFilter.mode(iconColor, BlendMode.srcIn)
              : null,
      width: widget.iconWidth,
      height: widget.iconHeight,
    );
  }

  Widget _buildText(Color? textColor) {
    return Flexible(
      child: AnimatedDefaultTextStyle(
        duration: widget.animationDuration,
        curve: widget.animationCurve,
        style: AppTheme.bodyText.copyWith(
          color: textColor ?? AppColors.light.accent,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight ?? FontWeight.w400,
          letterSpacing: widget.letterSpacing,
          height: widget.lineHeight,
          overflow: TextOverflow.ellipsis,
          fontFamily: widget.fontFamily,
        ),
        child: Text(widget.text!),
      ),
    );
  }
}
