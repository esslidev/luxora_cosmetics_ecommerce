import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';

import '../../../../config/theme/app_theme.dart';
import '../../../../core/util/responsive_size_adapter.dart';

enum TextPosition { start, center, end }

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? fontFamily;
  final String? svgIconPath;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final double? iconTextPadding;
  final double? letterSpacing;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? lineHeight;
  final bool selectable;
  final Color? backgroundColor;
  final double? borderRadius;
  final TextDirection? textDirection;
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;
  final TextPosition? textPosition;
  final TextDecoration? textDecoration;
  final double? textDecorationThickness;
  final TextDecorationStyle? textDecorationStyle;
  final Color? textDecorationColor;

  const CustomText({
    super.key,
    required this.text,
    this.textStyle,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.fontFamily,
    this.svgIconPath,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconTextPadding,
    this.letterSpacing,
    this.padding,
    this.margin,
    this.maxLines,
    this.overflow,
    this.lineHeight,
    this.selectable = false,
    this.backgroundColor,
    this.borderRadius,
    this.textDirection,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.textPosition = TextPosition.start,
    this.textDecoration,
    this.textDecorationThickness,
    this.textDecorationStyle,
    this.textDecorationColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = textStyle?.copyWith(
            color: color ?? AppColors.light.accent,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            height: lineHeight,
            fontFamily: fontFamily,
            decoration: textDecoration,
            decorationColor: textDecorationColor,
            decorationThickness: textDecorationThickness,
            decorationStyle: textDecorationStyle,
            overflow: overflow) ??
        AppTheme.bodyText.copyWith(
            color: color ?? AppColors.light.accent,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
            height: lineHeight,
            fontFamily: fontFamily,
            decoration: textDecoration,
            decorationColor: textDecorationColor,
            decorationThickness: textDecorationThickness,
            decorationStyle: textDecorationStyle,
            overflow: overflow);

    final textWidget = selectable
        ? SelectableText(
            text,
            style: effectiveTextStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            textDirection: textDirection,
          )
        : Text(
            text,
            style: effectiveTextStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            softWrap: true,
            textDirection: textDirection,
          );

    MainAxisAlignment rowAlignment;
    switch (textPosition) {
      case TextPosition.center:
        rowAlignment = MainAxisAlignment.center;
        break;
      case TextPosition.end:
        rowAlignment = MainAxisAlignment.end;
        break;
      case TextPosition.start:
      default:
        rowAlignment = MainAxisAlignment.start;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: rowAlignment,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (svgIconPath != null && svgIconPath!.isNotEmpty)
              SvgPicture.asset(
                svgIconPath!,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                    : null,
                width: iconWidth,
                height: iconHeight,
              ),
            if (svgIconPath != null && svgIconPath!.isNotEmpty)
              SizedBox(
                width:
                    iconTextPadding ?? ResponsiveSizeAdapter(context).size(8),
              ),
            Flexible(
              child: textWidget,
            ),
          ],
        ),
      ),
    );
  }
}
