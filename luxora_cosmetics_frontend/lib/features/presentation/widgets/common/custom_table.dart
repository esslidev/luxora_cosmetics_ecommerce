import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final double? tableBorderRadius;
  final double tableBorderWidth;
  final Color? tableBorderColor;
  final Color? tableBackgroundColor;

  // Row properties
  final double rowBorderWidth;
  final Color? rowBorderColor;
  final double? rowMinHeight;
  final Color? rowBackgroundColor;
  final Alignment? rowChildrenAlignment;
  final EdgeInsets? rowChildPadding;

  // Header properties
  final double? headerMinHeight;
  final Color? headerBackgroundColor;
  final Alignment? headerChildrenAlignment;
  final EdgeInsets? headerChildPadding;

  // Column properties
  final double columnBorderWidth;
  final Color? columnBorderColor;

  // Table content
  final List<Widget> header;
  final List<List<Widget>> rows;

  const CustomTable({
    super.key,
    required this.header,
    required this.rows,
    this.tableBorderRadius,
    this.tableBorderWidth = 1.0,
    this.tableBorderColor = Colors.black,
    this.tableBackgroundColor = Colors.transparent,
    this.rowBorderWidth = 1.0,
    this.rowBorderColor = Colors.black,
    this.rowMinHeight,
    this.rowBackgroundColor,
    this.rowChildrenAlignment = Alignment.center,
    this.rowChildPadding = const EdgeInsets.all(8.0),
    this.headerMinHeight,
    this.headerBackgroundColor,
    this.headerChildrenAlignment = Alignment.center,
    this.headerChildPadding = const EdgeInsets.all(8.0),
    this.columnBorderWidth = 1.0,
    this.columnBorderColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tableBackgroundColor,
        border: Border.all(
          width: tableBorderWidth,
          color: tableBorderColor ?? Colors.black,
        ),
        borderRadius: BorderRadius.circular(tableBorderRadius ?? 0.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tableBorderRadius ?? 0.0),
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              width: rowBorderWidth,
              color: rowBorderColor ?? Colors.black,
            ),
            verticalInside: BorderSide(
              width: columnBorderWidth,
              color: columnBorderColor ?? Colors.black,
            ),
          ),
          children: [
            // Header Row
            TableRow(
              children: header.map((widget) {
                return TableCell(
                  verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
                  child: Container(
                    padding: headerChildPadding,
                    color: headerBackgroundColor,
                    alignment: headerChildrenAlignment ?? Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: headerMinHeight ?? 0.0,
                      ),
                      child: widget,
                    ),
                  ),
                );
              }).toList(),
            ),
            // Data Rows
            ...rows.map((row) {
              return TableRow(
                children: row.map((cell) {
                  return TableCell(
                    verticalAlignment:
                        TableCellVerticalAlignment.intrinsicHeight,
                    child: Container(
                      padding: rowChildPadding,
                      color: rowBackgroundColor,
                      alignment: rowChildrenAlignment ?? Alignment.center,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: rowMinHeight ?? 0.0,
                        ),
                        child: cell,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
