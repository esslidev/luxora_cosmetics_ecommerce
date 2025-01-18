import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../common/custom_display.dart';
import '../common/custom_field.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final double? starSize;
  final bool isInteractive;
  final bool isRtl;
  final ValueChanged<double>? onRatingUpdate;

  const RatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.starSize,
    this.isInteractive = false,
    this.onRatingUpdate,
    required this.isRtl,
  });

  Widget _buildStar({
    required int index,
    required ResponsiveSizeAdapter r,
    required Color starColor,
  }) {
    return Stack(
      children: [
        CustomDisplay(
          assetPath: 'AppPaths.vectors.ratingStarIcon',
          isSvg: true,
          width: starSize ?? r.size(10),
          height: starSize ?? r.size(10),
          svgColor: (rating >= index + 1)
              ? AppColors.colors.yellowVanillaPudding
              : AppColors.light.accent.withValues(alpha: 0.15),
          cursor: isInteractive && onRatingUpdate != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onTap: isInteractive && onRatingUpdate != null
              ? () => onRatingUpdate!(index + 1.0)
              : null,
        ),
        IgnorePointer(
          ignoring: true,
          child: CustomDisplay(
            assetPath: 'AppPaths.vectors.ratingHalfStarIcon',
            isSvg: true,
            width: starSize != null ? (starSize! / 2) : r.size(5),
            height: starSize ?? r.size(10),
            svgColor: (rating > index && rating < index + 1)
                ? AppColors.colors.yellowVanillaPudding
                : AppColors.light.accent.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);
    final Color starColor = AppColors.colors.yellowVanillaPudding;

    return CustomField(
      mainAxisSize: MainAxisSize.min,
      arrangement: FieldArrangement.row,
      gap: r.size(2),
      children: List.generate(starCount, (index) {
        return _buildStar(index: index, r: r, starColor: starColor);
      }),
    );
  }
}
