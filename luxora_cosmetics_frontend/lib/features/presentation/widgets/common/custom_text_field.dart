import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../bloc/app/language/translation_bloc.dart';
import '../../bloc/app/language/translation_state.dart';
import '../../bloc/app/theme/theme_bloc.dart';
import '../../bloc/app/theme/theme_state.dart';

class CustomTextFieldStyle {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? textColor;
  final Color? hintColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;

  CustomTextFieldStyle({
    this.width,
    this.height,
    this.borderRadius,
    this.textColor,
    this.hintColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  });
}

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final String? hintText;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Border? border;
  final double? borderWidth;
  final void Function(String value, Offset position, Size size)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontWeight? hintFontWeight;
  final Color? focusedBorderColor;
  final CustomTextFieldStyle? onFocusStyle;
  final Color? textColor;
  final Color? hintColor;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double shadowBlurRadius;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.borderRadius,
    this.hintText,
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.border,
    this.borderWidth,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true, // Default value set to true
    this.fontSize,
    this.fontWeight,
    this.hintFontWeight,
    this.focusedBorderColor,
    this.onFocusStyle,
    this.textColor,
    this.hintColor,
    this.shadowColor,
    this.shadowOffset = Offset.zero,
    this.shadowBlurRadius = 0.0,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late ResponsiveSizeAdapter r;

  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);

    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  CustomTextFieldStyle _getEffectiveStyle() {
    final baseStyle = CustomTextFieldStyle(
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius,
      textColor: widget.textColor,
      hintColor: widget.hintColor,
      backgroundColor: widget.backgroundColor,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
    );

    if (_focusNode.hasFocus && widget.onFocusStyle != null) {
      return CustomTextFieldStyle(
        width: widget.onFocusStyle?.width ?? baseStyle.width,
        height: widget.onFocusStyle?.height ?? baseStyle.height,
        borderRadius:
            widget.onFocusStyle?.borderRadius ?? baseStyle.borderRadius,
        textColor: widget.onFocusStyle?.textColor ?? baseStyle.textColor,
        hintColor: widget.onFocusStyle?.hintColor ?? baseStyle.hintColor,
        backgroundColor:
            widget.onFocusStyle?.backgroundColor ?? baseStyle.backgroundColor,
        borderColor: widget.onFocusStyle?.borderColor ?? baseStyle.borderColor,
        borderWidth: widget.onFocusStyle?.borderWidth ?? baseStyle.borderWidth,
      );
    } else {
      return baseStyle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
            final fontFamily = translationState.language?.fontFamily;

            final TextStyle defaultTextStyle = TextStyle(
              fontSize: widget.fontSize ?? r.size(12),
              fontWeight: widget.fontWeight ?? FontWeight.normal,
              color: widget.enabled
                  ? (_getEffectiveStyle().textColor ??
                      themeState.theme.bodyText)
                  : themeState.theme.bodyText.withOpacity(0.5),
              fontFamily: fontFamily,
            );

            final TextStyle hintTextStyle = TextStyle(
              fontSize: widget.fontSize ?? r.size(12),
              fontWeight: widget.hintFontWeight ?? FontWeight.normal,
              color: _getEffectiveStyle().hintColor ??
                  themeState.theme.accent.withOpacity(0.6),
              fontFamily: fontFamily,
            );

            final effectiveStyle = _getEffectiveStyle();

            return Container(
              width: effectiveStyle.width ?? double.infinity,
              height: effectiveStyle.height,
              margin: widget.margin,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: effectiveStyle.backgroundColor ?? Colors.transparent,
                borderRadius: effectiveStyle.borderRadius ?? BorderRadius.zero,
                border: widget.border ??
                    Border.all(
                      color: _focusNode.hasFocus
                          ? (widget.focusedBorderColor ??
                              effectiveStyle.borderColor ??
                              Colors.transparent)
                          : (effectiveStyle.borderColor ?? Colors.transparent),
                      width: widget.borderWidth ?? 1.5,
                    ),
                boxShadow:
                    widget.shadowColor != null && widget.shadowBlurRadius > 0
                        ? [
                            BoxShadow(
                              color: widget.shadowColor!,
                              offset: widget.shadowOffset ?? Offset.zero,
                              blurRadius: widget.shadowBlurRadius,
                            ),
                          ]
                        : null,
              ),
              child: Center(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textAlign: widget.textAlign,
                  style: defaultTextStyle,
                  inputFormatters: widget.inputFormatters,
                  enabled: widget.enabled, // Applied enabled parameter
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: hintTextStyle,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: widget.enabled
                      ? (text) {
                          final RenderBox renderBox =
                              context.findRenderObject() as RenderBox;
                          final size = renderBox.size;
                          final offset = renderBox.localToGlobal(Offset.zero);

                          widget.onChanged?.call(text, offset, size);
                        }
                      : null, // Prevent onChanged if disabled
                ),
              ),
            );
          },
        );
      },
    );
  }
}
