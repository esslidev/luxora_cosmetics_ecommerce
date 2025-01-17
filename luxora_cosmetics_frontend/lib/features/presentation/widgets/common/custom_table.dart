import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';

class CustomTableStyle {
  final Color? color;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final TextStyle? textStyle;
  final AlignmentGeometry? alignment;

  CustomTableStyle({
    this.color,
    this.padding,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.borderColor,
    this.alignment,
    this.textStyle,
  });
}

class CustomTable extends StatefulWidget {
  final List<Widget>? headerCells;
  final List<List<Widget>> cells;
  final Color? rowColor1;
  final Color? rowColor2;
  final EdgeInsets padding;
  final AlignmentGeometry? alignment;
  final double? borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final TextStyle? textStyle;
  final CustomTableStyle? headerStyle;
  const CustomTable({
    super.key,
    required this.headerCells,
    required this.cells,
    this.rowColor1,
    this.rowColor2,
    this.padding = const EdgeInsets.all(8.0),
    this.alignment,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.borderColor,
    this.textStyle,
    this.headerStyle,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  late ResponsiveSizeAdapter R;

  @override
  Widget build(BuildContext context) {
    R = ResponsiveSizeAdapter(context);

    return Table(children: [
      if (widget.headerCells != null)
        TableRow(
          decoration: BoxDecoration(
            color: widget.headerStyle?.color ?? Colors.white,
            borderRadius: BorderRadius.circular(
                widget.headerStyle?.borderRadius ?? R.size(0)),
            border: Border(
              bottom: BorderSide(
                color: widget.headerStyle?.borderColor ?? Colors.transparent,
                width: widget.headerStyle?.borderWidth ?? R.size(0),
              ),
            ),
          ),
          children: List.generate(widget.headerCells!.length, (colIndex) {
            var childWidget = widget.headerCells![colIndex];
            return Padding(
              padding: widget.headerStyle?.padding ?? const EdgeInsets.all(8.0),
              child: Align(
                alignment:
                    widget.headerStyle?.alignment ?? Alignment.centerLeft,
                child: (childWidget is Text)
                    ? Text(
                        childWidget.data!,
                        style: widget.headerStyle?.textStyle ??
                            TextStyle(
                              fontSize: R.size(12),
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      )
                    : widget.headerCells![colIndex],
              ),
            );
          }),
        ),
      ...List.generate(
        widget.cells.length,
        (rowIndex) {
          Color bgColor = (rowIndex % 2 == 0)
              ? widget.rowColor1 ?? Colors.white
              : widget.rowColor2 ?? AppColors.colors.whiteSolid;

          return TableRow(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius:
                  BorderRadius.circular(widget.borderRadius ?? R.size(0)),
              border: Border(
                bottom: BorderSide(
                  color: widget.borderColor ?? Colors.transparent,
                  width: widget.borderWidth,
                ),
              ),
            ),
            children: List.generate(
              widget.cells[rowIndex].length,
              (colIndex) {
                var childWidget = widget.cells[rowIndex][colIndex];
                return Padding(
                  padding: widget.padding,
                  child: Align(
                      alignment: widget.alignment ?? Alignment.centerLeft,
                      child: (childWidget is Text)
                          ? Text(
                              childWidget.data!,
                              style: widget.textStyle ??
                                  TextStyle(
                                    fontSize: R.size(12),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                            )
                          : childWidget),
                );
              },
            ),
          );
        },
      ),
    ]);
  }
}
