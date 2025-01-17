import 'package:flutter/material.dart';
import 'package:librairie_alfia/core/constants/app_colors.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/core/util/responsive_size_adapter.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_display.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';

class RatingStars extends StatelessWidget {
  final BaseTheme theme;
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
    required this.theme,
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
          assetPath: AppPaths.vectors.ratingStarIcon,
          isSvg: true,
          width: starSize ?? r.size(10),
          height: starSize ?? r.size(10),
          svgColor: (rating >= index + 1)
              ? AppColors.colors.yellowHoneyGlow
              : theme.accent.withOpacity(0.15),
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
            assetPath: AppPaths.vectors.ratingHalfStarIcon,
            isSvg: true,
            width: starSize != null ? (starSize! / 2) : r.size(5),
            height: starSize ?? r.size(10),
            svgColor: (rating > index && rating < index + 1)
                ? AppColors.colors.yellowHoneyGlow
                : theme.accent.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);
    final Color starColor = AppColors.colors.yellowHoneyGlow;

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
