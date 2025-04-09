import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../common/custom_button.dart';
import '../common/custom_field.dart';

class Paginator extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final int maxVisiblePages;
  final void Function(int value) onPageChanged;

  const Paginator({
    super.key,
    this.currentPage = 1,
    this.totalPages = 1,
    this.maxVisiblePages = 5,
    required this.onPageChanged,
  });

  @override
  State<Paginator> createState() => _PaginatorState();
}

class _PaginatorState extends State<Paginator> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

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
      iconColor: AppColors.light.accent.withValues(
        alpha: isUnclickable ? 0.4 : 1,
      ),
      width: r.size(26),
      height: r.size(26),
      fontSize: r.size(11),
      borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
      cursor:
          !isUnclickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      border:
          isActive
              ? null
              : Border.all(
                color: AppColors.light.accent.withValues(alpha: 0.2),
                width: r.size(0.6),
              ),
      fontWeight: FontWeight.w500,
      textColor:
          isActive
              ? AppColors.colors.white
              : AppColors.light.accent.withValues(
                alpha: isUnclickable ? 0.4 : .8,
              ),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
        backgroundColor:
            isActive
                ? AppColors.light.secondary
                : AppColors.light.secondary.withValues(alpha: .1),
      ),
      backgroundColor: isActive ? AppColors.light.secondary : null,
      onPressed: isUnclickable ? null : (position, size) => onPressed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];

    // "First" button
    pageButtons.add(
      _buildCustomButton(
        svgIconPath: AppPaths.vectors.previousSkipIcon,
        isUnclickable: widget.currentPage == 1,
        onPressed: () {
          if (widget.currentPage > 1) widget.onPageChanged(1);
        },
      ),
    );

    // "Previous" button
    pageButtons.add(
      _buildCustomButton(
        svgIconPath: AppPaths.vectors.previousIcon,
        isUnclickable: widget.currentPage == 1,
        onPressed: () {
          if (widget.currentPage > 1) {
            widget.onPageChanged(widget.currentPage - 1);
          }
        },
      ),
    );

    // Determine the start and end page for pagination buttons
    int startPage = (widget.currentPage - (widget.maxVisiblePages ~/ 2)).clamp(
      1,
      widget.totalPages,
    );
    int endPage = (startPage + widget.maxVisiblePages - 1).clamp(
      1,
      widget.totalPages,
    );

    if (endPage - startPage + 1 < widget.maxVisiblePages) {
      startPage = (endPage - widget.maxVisiblePages + 1).clamp(
        1,
        widget.totalPages,
      );
    }

    // Show "..." button if there are pages before startPage
    if (startPage > 1) {
      pageButtons.add(
        _buildCustomButton(title: '...', isUnclickable: true, onPressed: () {}),
      );
    }

    // Page number buttons
    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        _buildCustomButton(
          title: '$i',
          isActive: i == widget.currentPage,
          onPressed: () => widget.onPageChanged(i),
        ),
      );
    }

    // Show "..." button if there are pages after endPage
    if (endPage < widget.totalPages) {
      pageButtons.add(
        _buildCustomButton(title: '...', isUnclickable: true, onPressed: () {}),
      );
    }

    // "Next" button
    pageButtons.add(
      _buildCustomButton(
        svgIconPath: AppPaths.vectors.nextIcon,
        isUnclickable: widget.currentPage == widget.totalPages,
        onPressed: () {
          if (widget.currentPage < widget.totalPages) {
            widget.onPageChanged(widget.currentPage + 1);
          }
        },
      ),
    );

    // "Last" button
    pageButtons.add(
      _buildCustomButton(
        svgIconPath: AppPaths.vectors.nextSkipIcon,
        isUnclickable: widget.currentPage == widget.totalPages,
        onPressed: () {
          if (widget.currentPage < widget.totalPages) {
            widget.onPageChanged(widget.totalPages);
          }
        },
      ),
    );

    return CustomField(
      mainAxisAlignment: MainAxisAlignment.center,
      gap: r.size(4),
      arrangement: FieldArrangement.row,
      children: pageButtons,
    );
  }
}
