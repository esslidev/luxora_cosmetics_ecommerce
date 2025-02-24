import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';

class CustomDashedLine extends StatelessWidget {
  final Color? color;
  final bool isVertical;
  final double? size;
  final double? thickness;
  final double? dashLength;
  final double? dashGap;

  const CustomDashedLine({
    super.key,
    this.color,
    this.isVertical = false,
    this.size,
    this.thickness,
    this.dashLength = 5.0,
    this.dashGap = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);
    return CustomPaint(
      size: Size(
        isVertical ? (thickness ?? r.size(1)) : (size ?? double.infinity),
        isVertical ? (size ?? double.infinity) : (thickness ?? r.size(1)),
      ),
      painter: _DashedLinePainter(
        color: color ?? AppColors.light.accent.withValues(alpha: 0.4),
        isVertical: isVertical,
        thickness: thickness ?? r.size(1),
        dashLength: dashLength ?? r.size(5),
        dashGap: dashGap ?? r.size(3),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isVertical;
  final double thickness;
  final double dashLength;
  final double dashGap;

  _DashedLinePainter({
    required this.color,
    required this.isVertical,
    required this.thickness,
    required this.dashLength,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startPosition = 0;
    while (startPosition < (isVertical ? size.height : size.width)) {
      if (isVertical) {
        // Draw vertical dashes
        canvas.drawLine(
          Offset(0, startPosition),
          Offset(0, startPosition + dashLength),
          paint,
        );
      } else {
        // Draw horizontal dashes
        canvas.drawLine(
          Offset(startPosition, 0),
          Offset(startPosition + dashLength, 0),
          paint,
        );
      }
      startPosition += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
