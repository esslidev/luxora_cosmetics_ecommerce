import 'package:flutter/material.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';

import '../../../../../../core/constants/app_colors.dart';

import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';

import '../../../../widgets/common/custom_button.dart';

import '../boutique.dart';

class SortByDropdown extends StatefulWidget {
  final BaseTheme theme;
  final TranslationService ts;
  final bool isRtl;
  final Function(BoutiqueSortCriteria sortCriteria) onPressed;

  const SortByDropdown(
      {super.key,
      required this.theme,
      required this.ts,
      required this.isRtl,
      required this.onPressed});

  @override
  State<SortByDropdown> createState() => _SortByDropdownState();
}

class _SortByDropdownState extends State<SortByDropdown> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  // ------------------------------------------------------- //

  Widget _buildDropdownButton({
    required BoutiqueSortCriteria sortCriteria,
  }) {
    return CustomButton(
      onHoverStyle: CustomButtonStyle(
        backgroundColor: widget.theme.secondary.withOpacity(0.4),
      ),
      useIntrinsicWidth: false,
      text: sortCriteria.text,
      fontSize: r.size(9),
      onPressed: (position, size) {
        widget.onPressed(sortCriteria);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomField(
        backgroundColor: widget.theme.secondaryBackgroundColor,
        borderWidth: r.size(0.6),
        borderColor: widget.theme.accent.withOpacity(0.4),
        borderRadius: r.size(1.5),
        padding: r.all(4),
        gap: r.size(2),
        children: [
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.none,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.titleAsc,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.titleDesc,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.authorAsc,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.authorDesc,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.stock,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.sortByPriceLowToHigh,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.sortByPriceHighToLow,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.publicationDateAsc,
          ),
          _buildDropdownButton(
            sortCriteria: BoutiqueSortCriteria.publicationDateDesc,
          ),
        ]);
  }
}
