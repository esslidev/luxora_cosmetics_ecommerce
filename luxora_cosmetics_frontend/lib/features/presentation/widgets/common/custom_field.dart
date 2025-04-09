import 'package:flutter/material.dart';

enum FieldArrangement { row, column }

class CustomField extends StatefulWidget {
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final Border? border;
  final FieldArrangement arrangement;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize; // New parameter
  final int flex;
  final double? width;
  final double? height;
  final double gap;
  final bool isWrap;
  final double? minHeight;
  final double? minWidth;
  final double? maxHeight;
  final double? maxWidth;
  final Color? shadowColor;
  final Offset? shadowOffset;
  final double shadowBlurRadius;
  final bool loading;
  final Widget? loadingChild;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;
  final bool expanded; // Existing parameter
  final bool isRtl; // New parameter
  final double wrapVerticalSpacing; // New parameter
  final double wrapHorizontalSpacing; // New parameter

  const CustomField({
    super.key,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.arrangement = FieldArrangement.column,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max, // Default to max
    this.flex = 1,
    this.width,
    this.height,
    this.gap = 0.0,
    this.isWrap = false,
    this.minHeight,
    this.minWidth,
    this.maxHeight,
    this.maxWidth,
    this.shadowColor,
    this.shadowOffset = Offset.zero,
    this.shadowBlurRadius = 0.0,
    this.loading = false,
    this.loadingChild,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.expanded = false,
    this.isRtl = false,
    this.wrapVerticalSpacing = 0.0, // Default value
    this.wrapHorizontalSpacing = 0.0, // Default value
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    Widget content =
        widget.loading && widget.loadingChild != null
            ? widget.loadingChild!
            : _buildChildren();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0.0,
        minHeight: widget.minHeight ?? 0.0,
        maxWidth: widget.maxWidth ?? double.infinity,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        alignment: widget.alignment,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 0.0),
          border: widget.border,
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
        clipBehavior: widget.clipBehavior ?? Clip.none,
        child: widget.expanded ? Expanded(child: content) : content,
      ),
    );
  }

  Widget _buildChildren() {
    final List<Widget> spacedChildren = <Widget>[];

    for (int i = 0; i < widget.children.length; i++) {
      spacedChildren.add(widget.children[i]);
      if (i < widget.children.length - 1) {
        // Determine if horizontal spacing should be applied
        if (widget.arrangement == FieldArrangement.row && !widget.isWrap) {
          spacedChildren.add(SizedBox(width: widget.gap, height: 0));
        } else if (widget.arrangement == FieldArrangement.column &&
            !widget.isWrap) {
          spacedChildren.add(SizedBox(width: 0, height: widget.gap));
        }
      }
    }

    final mainAxis =
        widget.arrangement == FieldArrangement.row
            ? Axis.horizontal
            : Axis.vertical;

    return widget.isWrap && widget.arrangement == FieldArrangement.row
        ? Wrap(
          spacing: widget.wrapHorizontalSpacing,
          runSpacing: widget.wrapVerticalSpacing,
          alignment: widget.mainAxisAlignment.wrapAlignment,
          crossAxisAlignment: widget.crossAxisAlignment.wrapCrossAlignment,
          children:
              spacedChildren.map((child) {
                return Directionality(
                  textDirection:
                      widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: child,
                );
              }).toList(),
        )
        : Flex(
          direction: mainAxis,
          mainAxisSize: widget.mainAxisSize,
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          children:
              spacedChildren.map((child) {
                return Directionality(
                  textDirection:
                      widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  child: child,
                );
              }).toList(),
        );
  }
}

extension on MainAxisAlignment {
  WrapAlignment get wrapAlignment {
    switch (this) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }
}

extension on CrossAxisAlignment {
  WrapCrossAlignment get wrapCrossAlignment {
    switch (this) {
      case CrossAxisAlignment.start:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        return WrapCrossAlignment.start;
    }
  }
}
