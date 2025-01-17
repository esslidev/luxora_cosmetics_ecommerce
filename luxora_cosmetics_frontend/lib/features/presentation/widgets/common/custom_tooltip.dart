import 'package:flutter/material.dart';

import '../../../../core/util/responsive_size_adapter.dart';

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final String? message;
  final List<TextSpan>? richMessage;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? textColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final Duration? duration;

  const CustomTooltip({
    super.key,
    required this.child,
    this.message,
    this.richMessage,
    this.backgroundColor,
    this.borderRadius,
    this.textColor = Colors.white,
    this.fontSize,
    this.fontWeight = FontWeight.w400,
    this.duration,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  late ResponsiveSizeAdapter R;

  @override
  Widget build(BuildContext context) {
    R = ResponsiveSizeAdapter(context);

    return Tooltip(
      message: widget.message, // This will be used if richMessage is null
      richMessage: widget.richMessage != null
          ? TextSpan(
              children: widget.richMessage,
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
              ),
            )
          : null,
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            Colors.black87, // Default color if not provided
        borderRadius: BorderRadius.circular(widget.borderRadius ?? R.size(3)),
      ),
      textStyle: widget.message != null
          ? TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            )
          : null,
      waitDuration: widget.duration ?? const Duration(milliseconds: 500),
      child: widget.child,
    );
  }
}
