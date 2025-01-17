import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/core/util/responsive_size_adapter.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';
import '../../../../core/constants/app_colors.dart';

class Paginator extends StatelessWidget {
  final BaseTheme theme;
  final bool isRtl;
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;
  final ResponsiveSizeAdapter r;
  final int maxVisiblePages;

  const Paginator({
    super.key,
    required this.theme,
    required this.isRtl,
    this.currentPage = 1,
    this.totalPages = 1,
    required this.onPageChanged,
    required this.r,
    this.maxVisiblePages = 5,
  });

  Widget _buildCustomButton({
    String? title,
    String? svgIconPath,
    bool isActive = false,
    bool isUnclickable = false,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      text: title,
      svgIconPath: svgIconPath,
      iconWidth: r.size(8),
      iconHeight: r.size(8),
      iconColor: theme.accent.withOpacity(isUnclickable ? 0.4 : 1),
      width: r.size(26),
      height: r.size(18),
      fontSize: r.size(12),
      borderRadius: BorderRadius.all(Radius.circular(r.size(2))),
      cursor:
          !isUnclickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      border: isActive
          ? null
          : Border.all(
              color: theme.accent.withOpacity(0.4), width: r.size(0.6)),
      fontWeight: FontWeight.w500,
      textColor: isActive
          ? AppColors.colors.whiteOut
          : theme.accent.withOpacity(isUnclickable ? 0.4 : 1),
      animationDuration: 300.ms,
      backgroundColor:
          isActive ? theme.primary : theme.secondaryBackgroundColor,
      onPressed: isUnclickable ? null : (position, size) => onPressed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];

    // "First" button
    pageButtons.add(_buildCustomButton(
      svgIconPath: !isRtl
          ? AppPaths.vectors.previousSkipIcon
          : AppPaths.vectors.nextSkipIcon,
      isUnclickable: currentPage == 1,
      onPressed: () {
        if (currentPage > 1) onPageChanged(1);
      },
    ));

    // "Previous" button
    pageButtons.add(_buildCustomButton(
      svgIconPath:
          !isRtl ? AppPaths.vectors.previousIcon : AppPaths.vectors.nextIcon,
      isUnclickable: currentPage == 1,
      onPressed: () {
        if (currentPage > 1) onPageChanged(currentPage - 1);
      },
    ));

    // Determine the start and end page for pagination buttons
    int startPage = (currentPage - (maxVisiblePages ~/ 2)).clamp(1, totalPages);
    int endPage = (startPage + maxVisiblePages - 1).clamp(1, totalPages);

    if (endPage - startPage + 1 < maxVisiblePages) {
      startPage = (endPage - maxVisiblePages + 1).clamp(1, totalPages);
    }

    // Show "..." button if there are pages before startPage
    if (startPage > 1) {
      pageButtons.add(_buildCustomButton(
        title: '...',
        isUnclickable: true,
        onPressed: () {},
      ));
    }

    // Page number buttons
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildCustomButton(
        title: '$i',
        isActive: i == currentPage,
        onPressed: () => onPageChanged(i),
      ));
    }

    // Show "..." button if there are pages after endPage
    if (endPage < totalPages) {
      pageButtons.add(_buildCustomButton(
        title: '...',
        isUnclickable: true,
        onPressed: () {},
      ));
    }

    // "Next" button
    pageButtons.add(_buildCustomButton(
      svgIconPath:
          !isRtl ? AppPaths.vectors.nextIcon : AppPaths.vectors.previousIcon,
      isUnclickable: currentPage == totalPages,
      onPressed: () {
        if (currentPage < totalPages) onPageChanged(currentPage + 1);
      },
    ));

    // "Last" button
    pageButtons.add(_buildCustomButton(
      svgIconPath: !isRtl
          ? AppPaths.vectors.nextSkipIcon
          : AppPaths.vectors.previousIcon,
      isUnclickable: currentPage == totalPages,
      onPressed: () {
        if (currentPage < totalPages) onPageChanged(totalPages);
      },
    ));

    return CustomField(
      isRtl: isRtl,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: r.size(4),
      arrangement: FieldArrangement.row,
      children: pageButtons,
    );
  }
}
