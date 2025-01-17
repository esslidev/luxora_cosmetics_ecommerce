import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';

class CustomShrinkingLine extends StatelessWidget {
  final Color? color; // Changed to 'color' for consistency
  final bool isVertical;
  final double? size; // This represents the length of the line
  final double? thickness; // This represents the thickness of the line

  const CustomShrinkingLine({
    super.key,
    this.color,
    this.isVertical = false,
    this.size,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);

    // Determine the dimensions of the line based on its orientation
    double lineThickness = thickness ?? r.size(20);
    double lineSize = size ?? double.infinity;

    return CustomPaint(
      size: isVertical
          ? Size(lineThickness, lineSize)
          : Size(lineSize, lineThickness),
      painter: ShrinkingLinePainter(
        color: color ??
            AppColors.colors.whiteMuffled
                .withOpacity(0.4), // Set your default color
        isVertical: isVertical,
        thickness: lineThickness,
      ),
    );
  }
}

class ShrinkingLinePainter extends CustomPainter {
  final Color color;
  final bool isVertical;
  final double thickness;

  ShrinkingLinePainter({
    required this.color,
    required this.isVertical,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (isVertical) {
      // Draw a vertical line with shrinking edges
      for (double i = 0; i < size.height / 2; i += 1) {
        double width =
            thickness * (1 - (i / (size.height / 2))); // Shrink width
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2 - i),
            width: width,
            height: thickness,
          ),
          paint,
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2 + i),
            width: width,
            height: thickness,
          ),
          paint,
        );
      }
    } else {
      // Draw a horizontal line with shrinking edges
      for (double i = 0; i < size.width / 2; i += 1) {
        double height =
            thickness * (1 - (i / (size.width / 2))); // Shrink height
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width / 2 - i, size.height / 2),
            width: thickness,
            height: height,
          ),
          paint,
        );
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(size.width / 2 + i, size.height / 2),
            width: thickness,
            height: height,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ShrinkingLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.isVertical != isVertical ||
        oldDelegate.thickness != thickness;
  }
}
