import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';

class CustomLine extends StatelessWidget {
  final Color? color; // Changed to 'color' for consistency
  final bool isVertical;
  final double? size;
  final double? thickness;

  const CustomLine({
    super.key,
    this.color,
    this.isVertical = false,
    this.size,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);
    return Container(
      width: isVertical ? (thickness ?? r.size(1)) : (size ?? double.infinity),
      height: isVertical ? (size ?? double.infinity) : (thickness ?? r.size(1)),
      decoration: BoxDecoration(
        color: color ?? AppColors.colors.whiteMuffled.withOpacity(0.4),
        borderRadius: BorderRadius.circular(
            15), // Optional: consider making this parameterized
      ),
    );
  }
}
