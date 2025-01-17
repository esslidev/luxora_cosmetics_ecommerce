import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/domain/entities/author.dart';
import 'package:librairie_alfia/features/domain/entities/category.dart';
import 'package:librairie_alfia/features/domain/entities/filtering_data.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_display.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/util/custom_timer.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';
import '../../../../../data/models/category_translation.dart';
import '../../../../widgets/common/custom_field.dart';
import '../../../../widgets/common/custom_line.dart';
import '../../../../widgets/common/custom_text_field.dart';

enum BoutiqueFilterByAvailability {
  allStock,
  inStock,
}

enum BoutiqueFilterByPublicationDate {
  allTime,
  published,
  past6Months,
  within3Months,
}

enum BoutiqueFilterByFormat {
  allFormats,
  paperback,
  grand,
}

class BoutiqueFilterByPriceRange {
  final double? lowestPrice;
  final double? highestPrice;

  BoutiqueFilterByPriceRange({this.lowestPrice, this.highestPrice});
}

class BoutiqueSidebar extends StatefulWidget {
  final BaseTheme theme;
  final TranslationService ts;
  final bool isRtl;
  final List<CategoryEntity> sections;
  final FilteringDataEntity filteringData;
  final List<AuthorEntity> featuredAuthors;
  final BoutiqueFilterByAvailability filterByAvailability;
  final BoutiqueFilterByPublicationDate filterByPublicationDate;
  final BoutiqueFilterByFormat filterByFormat;
  final BoutiqueFilterByPriceRange filterByPriceRange;
  final Function(BoutiqueFilterByAvailability filterByAvailability)
      onFilterAvailabiltyPressed;
  final Function(BoutiqueFilterByPublicationDate filterByPublicationDate)
      onFilterPublicationDatePressed;
  final Function(BoutiqueFilterByFormat filterByFormat) onFilterByFormatPressed;
  final Function(double? lowestPrice, double? highestPrice)
      onFilterByPriceRangeChanged;

  const BoutiqueSidebar({
    super.key,
    required this.theme,
    required this.ts,
    required this.isRtl,
    required this.sections,
    required this.filteringData,
    required this.featuredAuthors,
    required this.filterByAvailability,
    required this.filterByPublicationDate,
    required this.filterByFormat,
    required this.filterByPriceRange,
    required this.onFilterAvailabiltyPressed,
    required this.onFilterPublicationDatePressed,
    required this.onFilterByFormatPressed,
    required this.onFilterByPriceRangeChanged,
  });

  @override
  State<BoutiqueSidebar> createState() => _BoutiqueSidebarState();
}

class _BoutiqueSidebarState extends State<BoutiqueSidebar> {
  late ResponsiveSizeAdapter r;

  late TextEditingController _lowestPriceTextFieldController;
  late TextEditingController _highestPriceTextFieldController;
  CustomTimer? _lowestPriceTextFieldDelayTimer;
  CustomTimer? _highestPriceTextFieldDelayTimer;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);

    // Initialize the TextEditingController
    _lowestPriceTextFieldController = TextEditingController();
    _highestPriceTextFieldController = TextEditingController();

    // Add listeners for both controllers
    _lowestPriceTextFieldController.addListener(_lowestPriceRangeListener);
    _highestPriceTextFieldController.addListener(_highestPriceRangeListener);
  }

  void _lowestPriceRangeListener() {
    final lowestPriceText = _lowestPriceTextFieldController.text;
    final lowestPrice = double.tryParse(lowestPriceText);
    final highestPriceText = _highestPriceTextFieldController.text;
    final highestPrice = double.tryParse(highestPriceText);

    _lowestPriceTextFieldDelayTimer?.stop();
    _lowestPriceTextFieldDelayTimer = CustomTimer(
      onTimerStop: () {
        widget.onFilterByPriceRangeChanged(lowestPrice, highestPrice);
      },
    );
    _lowestPriceTextFieldDelayTimer!.start(duration: 1400.ms);
  }

  void _highestPriceRangeListener() {
    final lowestPriceText = _lowestPriceTextFieldController.text;
    final lowestPrice = double.tryParse(lowestPriceText);
    final highestPriceText = _highestPriceTextFieldController.text;
    final highestPrice = double.tryParse(highestPriceText);

    _highestPriceTextFieldDelayTimer?.stop();
    _highestPriceTextFieldDelayTimer = CustomTimer(
      onTimerStop: () {
        widget.onFilterByPriceRangeChanged(lowestPrice, highestPrice);
      },
    );
    _highestPriceTextFieldDelayTimer!.start(duration: 1400.ms);
  }

  @override
  void dispose() {
    _lowestPriceTextFieldController.dispose();
    _highestPriceTextFieldController.dispose();
    super.dispose();
  }

  CategoryTranslationModel? getCategoryTranslation({
    required List<CategoryTranslationModel>? translations,
    String? languageCode = 'fr',
  }) {
    if (translations == null || translations.isEmpty) return null;

    // Use firstWhereOrNull to simplify null handling
    final languageSpecificTranslation = translations.firstWhereOrNull(
      (translation) => translation.languageCode == languageCode,
    );

    final defaultTranslation = translations.firstWhereOrNull(
      (translation) => translation.isDefault == true,
    );

    // Return the language-specific translation if available; otherwise, default translation
    return defaultTranslation ?? languageSpecificTranslation;
  }

  //---------------------------------------------------------------//

  Widget _buildSectionsNavigatorHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      backgroundColor: theme.accent,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: r.symmetric(vertical: 4),
      gap: r.size(8),
      arrangement: FieldArrangement.row,
      children: [
        CustomDisplay(
          assetPath: AppPaths.vectors.navigationIcon,
          isSvg: true,
          width: r.size(8),
          height: r.size(8),
          svgColor: theme.subtle,
        ),
        CustomText(
          text: 'Tous nos rayons',
          fontSize: r.size(16),
          fontWeight: FontWeight.bold,
          color: theme.subtle,
        )
      ],
    );
  }

  Widget _buildExpandableButton({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String title,
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    Color? textColor,
    bool isArabic = false,
    required Function() onPressed,
  }) {
    return CustomButton(
      text: title,
      fontSize: fontSize ?? r.size(12),
      fontWeight: fontWeight ?? FontWeight.bold,
      fontFamily: isArabic ? 'cairo' : null,
      textColor: textColor ?? theme.accent,
      padding: padding ?? r.symmetric(vertical: 4, horizontal: 8),
      mainAxisAlignment: MainAxisAlignment.start,
      useIntrinsicWidth: false,
      onHoverStyle: CustomButtonStyle(textColor: theme.accent.withOpacity(0.6)),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildSubExpandable({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required CategoryEntity subSection,
  }) {
    CategoryTranslationModel? mainCategoryTranslation =
        getCategoryTranslation(translations: subSection.translations);

    List<CategoryEntity> subSections =
        subSection.subCategories != null ? subSection.subCategories! : [];
    return subSections.isNotEmpty
        ? ExpansionTile(
            title: _buildExpandableButton(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              padding: EdgeInsets.zero,
              title: mainCategoryTranslation?.name ?? '',
              fontSize: r.size(10),
              fontWeight: FontWeight.bold,
              textColor: theme.accent.withOpacity(0.8),
              isArabic: mainCategoryTranslation?.languageCode == 'ar',
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${subSection.categoryNumber}');
              },
            ),
            controlAffinity: ListTileControlAffinity.leading,
            shape: Border(
              top: BorderSide(
                  color: theme.accent.withOpacity(0.2), width: r.size(0.6)),
              bottom: BorderSide(
                  color: theme.accent.withOpacity(0.2), width: r.size(0.6)),
              left: BorderSide.none,
              right: BorderSide.none,
            ),
            iconColor: theme.accent,
            tilePadding: r.symmetric(horizontal: 8),
            childrenPadding: r.symmetric(horizontal: 8),
            children: [
              CustomField(children: [
                ...subSections.map((subSection) {
                  return _buildSubExpandable(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    subSection: subSection,
                  );
                }),
              ])
            ],
          )
        : _buildExpandableButton(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            title: mainCategoryTranslation?.name ?? '',
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            textColor: theme.accent.withOpacity(0.8),
            isArabic: mainCategoryTranslation?.languageCode == 'ar',
            onPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${subSection.categoryNumber}');
            },
          );
  }

  Widget _buildMainExpandable({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required CategoryEntity section,
  }) {
    CategoryTranslationModel? mainCategoryTranslation =
        getCategoryTranslation(translations: section.translations);

    List<CategoryEntity> subSections =
        section.subCategories != null ? section.subCategories! : [];
    return subSections.isNotEmpty
        ? ExpansionTile(
            title: _buildExpandableButton(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              title: mainCategoryTranslation?.name ?? '',
              padding: r.symmetric(vertical: 0),
              isArabic: mainCategoryTranslation?.languageCode == 'ar',
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${section.categoryNumber}');
              },
            ),
            controlAffinity: ListTileControlAffinity.leading,
            shape: Border(
              top: BorderSide(
                  color: theme.accent.withOpacity(0.2), width: r.size(0.6)),
              bottom: BorderSide(
                  color: theme.accent.withOpacity(0.2), width: r.size(0.6)),
              left: BorderSide.none,
              right: BorderSide.none,
            ),
            iconColor: theme.accent,
            tilePadding: r.symmetric(horizontal: 8),
            childrenPadding: r.symmetric(horizontal: 8),
            expandedAlignment: Alignment.centerLeft,
            children: [
              CustomField(children: [
                ...subSections.map((subSection) {
                  return _buildSubExpandable(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    subSection: subSection,
                  );
                }),
              ])
            ],
          )
        : _buildExpandableButton(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            title: mainCategoryTranslation?.name ?? '',
            isArabic: mainCategoryTranslation?.languageCode == 'ar',
            onPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${section.categoryNumber}');
            },
          );
  }

  Widget _buildSectionsNavigator({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<CategoryEntity> sections,
  }) {
    return CustomField(
      children: [
        _buildSectionsNavigatorHeader(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
        ),
        CustomField(
            width: double.infinity,
            padding: r.symmetric(vertical: 8),
            backgroundColor: theme.thirdBackgroundColor,
            children: [
              ...sections.map((section) {
                return _buildMainExpandable(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  section: section,
                );
              }),
            ])
      ],
    );
  }

  Widget _buildFiltraionsHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(8),
      padding: r.symmetric(vertical: 2, horizontal: 12),
      backgroundColor: theme.thirdBackgroundColor,
      arrangement: FieldArrangement.row,
      children: [
        CustomDisplay(
          assetPath: AppPaths.vectors.filterFunnelIcon,
          isSvg: true,
          width: r.size(8),
          height: r.size(8),
          svgColor: theme.accent,
        ),
        CustomText(
          text: 'Filtrer',
          fontSize: r.size(14),
          fontWeight: FontWeight.bold,
        )
      ],
    );
  }

  Widget _buildFiltrationsRadioButton({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String text,
    bool isEnabled = false,
    required Function() onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: CustomField(
          isRtl: isRtl,
          gap: r.size(8),
          crossAxisAlignment: CrossAxisAlignment.center,
          arrangement: FieldArrangement.row,
          children: [
            CustomField(
              isRtl: isRtl,
              width: r.size(10),
              height: r.size(10),
              borderColor: theme.accent.withOpacity(0.6),
              borderWidth: r.size(1),
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isEnabled)
                  CustomField(
                    isRtl: isRtl,
                    width: r.size(6),
                    height: r.size(6),
                    backgroundColor: theme.accent.withOpacity(0.8),
                    children: const [],
                  ),
              ],
            ),
            CustomText(
              text: text,
              fontSize: r.size(12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltrationsChildrenTitle({
    required BaseTheme theme,
    required String title,
  }) {
    return CustomText(
      text: title,
      fontSize: r.size(12),
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildAvailabilityFiltrations({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      gap: r.size(4),
      children: [
        _buildFiltrationsChildrenTitle(
          theme: theme,
          title: 'Disponibilité',
        ),
        CustomField(
            gap: r.size(4),
            padding: r.symmetric(horizontal: 8),
            children: [
              _buildFiltrationsRadioButton(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                text: 'En stock (${widget.filteringData.inStockCount ?? 0})',
                isEnabled: widget.filterByAvailability ==
                    BoutiqueFilterByAvailability.inStock,
                onPressed: () {
                  widget.onFilterAvailabiltyPressed(
                      widget.filterByAvailability !=
                              BoutiqueFilterByAvailability.inStock
                          ? BoutiqueFilterByAvailability.inStock
                          : BoutiqueFilterByAvailability.allStock);
                },
              )
            ])
      ],
    );
  }

  Widget _buildPublicationDateFiltrations({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      gap: r.size(4),
      children: [
        _buildFiltrationsChildrenTitle(
          theme: theme,
          title: 'Date de parution',
        ),
        CustomField(
            gap: r.size(2),
            padding: r.symmetric(horizontal: 8),
            children: [
              _buildFiltrationsRadioButton(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                text: 'Parus (${widget.filteringData.publishedCount ?? 0})',
                isEnabled: widget.filterByPublicationDate ==
                    BoutiqueFilterByPublicationDate.published,
                onPressed: () {
                  widget.onFilterPublicationDatePressed(
                      widget.filterByPublicationDate !=
                              BoutiqueFilterByPublicationDate.published
                          ? BoutiqueFilterByPublicationDate.published
                          : BoutiqueFilterByPublicationDate.allTime);
                },
              ),
              _buildFiltrationsRadioButton(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                text:
                    'Depuis 6 mois (${widget.filteringData.publishedPast6MonthsCount ?? 0})',
                isEnabled: widget.filterByPublicationDate ==
                    BoutiqueFilterByPublicationDate.past6Months,
                onPressed: () {
                  widget.onFilterPublicationDatePressed(
                      widget.filterByPublicationDate !=
                              BoutiqueFilterByPublicationDate.past6Months
                          ? BoutiqueFilterByPublicationDate.past6Months
                          : BoutiqueFilterByPublicationDate.allTime);
                },
              ),
              _buildFiltrationsRadioButton(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                text:
                    "A paraitre d'ici 3 mois (${widget.filteringData.publishedWithin3MonthsCount ?? 0})",
                isEnabled: widget.filterByPublicationDate ==
                    BoutiqueFilterByPublicationDate.within3Months,
                onPressed: () {
                  widget.onFilterPublicationDatePressed(
                      widget.filterByPublicationDate !=
                              BoutiqueFilterByPublicationDate.within3Months
                          ? BoutiqueFilterByPublicationDate.within3Months
                          : BoutiqueFilterByPublicationDate.allTime);
                },
              ),
            ])
      ],
    );
  }

  Widget _buildFormatFiltrations({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      gap: r.size(4),
      children: [
        _buildFiltrationsChildrenTitle(
          theme: theme,
          title: 'Format',
        ),
        CustomField(
            gap: r.size(2),
            padding: r.symmetric(horizontal: 8),
            children: [
              _buildFiltrationsRadioButton(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                text:
                    'Poche (${widget.filteringData.paperbackFormatCount ?? 0})',
                isEnabled:
                    widget.filterByFormat == BoutiqueFilterByFormat.paperback,
                onPressed: () {
                  widget.onFilterByFormatPressed(
                      widget.filterByFormat != BoutiqueFilterByFormat.paperback
                          ? BoutiqueFilterByFormat.paperback
                          : BoutiqueFilterByFormat.allFormats);
                },
              ),
              _buildFiltrationsRadioButton(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                text:
                    'Grand Format (${widget.filteringData.grandFormatCount ?? 0})',
                isEnabled:
                    widget.filterByFormat == BoutiqueFilterByFormat.grand,
                onPressed: () {
                  widget.onFilterByFormatPressed(
                      widget.filterByFormat != BoutiqueFilterByFormat.grand
                          ? BoutiqueFilterByFormat.grand
                          : BoutiqueFilterByFormat.allFormats);
                },
              ),
            ])
      ],
    );
  }

  Widget _buildPriceRangeTextField(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      TextEditingController? controller,
      bool isInAccurate = true}) {
    return CustomTextField(
      controller: controller,
      width: r.size(60),
      height: r.size(20),
      borderRadius: BorderRadius.circular(r.size(1)),
      border: Border.all(
          color: !isInAccurate
              ? widget.theme.accent.withOpacity(0.4)
              : AppColors.colors.redRouge,
          width: r.size(0.6)),
      backgroundColor: widget.theme.secondaryBackgroundColor,
      fontSize: r.size(10),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value, position, size) {},
    );
  }

  Widget _buildPriceRangeFiltrations({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    final lowestPriceText = _lowestPriceTextFieldController.text;
    final highestPriceText = _highestPriceTextFieldController.text;
    final lowestPrice = double.tryParse(lowestPriceText);
    final highestPrice = double.tryParse(highestPriceText);
    return CustomField(
      children: [
        _buildFiltrationsChildrenTitle(
          theme: theme,
          title: 'Prix',
        ),
        CustomField(
            gap: r.size(4),
            padding: r.symmetric(horizontal: 8),
            crossAxisAlignment: CrossAxisAlignment.center,
            arrangement: FieldArrangement.row,
            children: [
              CustomText(
                text: 'De',
                fontSize: r.size(12),
              ),
              _buildPriceRangeTextField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                controller: _lowestPriceTextFieldController,
                isInAccurate: lowestPrice != null &&
                    highestPrice != null &&
                    lowestPrice > highestPrice,
              ),
              CustomText(
                text: 'à',
                fontSize: r.size(12),
              ),
              _buildPriceRangeTextField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                controller: _highestPriceTextFieldController,
                isInAccurate: lowestPrice != null &&
                    highestPrice != null &&
                    lowestPrice > highestPrice,
              ),
              CustomText(
                text: 'MAD',
                fontSize: r.size(8),
              ),
            ])
      ],
    );
  }

  Widget _buildFiltrations({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required FilteringDataEntity filteringData,
  }) {
    return CustomField(gap: r.size(8), children: [
      _buildFiltraionsHeader(
        theme: theme,
        ts: ts,
        isRtl: isRtl,
      ),
      CustomField(
          gap: r.size(8),
          padding: r.symmetric(horizontal: 12),
          children: [
            _buildAvailabilityFiltrations(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
            ),
            _buildPublicationDateFiltrations(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
            ),
            _buildFormatFiltrations(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
            ),
            _buildPriceRangeFiltrations(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
            ),
          ])
    ]);
  }

  Widget _buildFeaturedAuthors({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<AuthorEntity> featuredAuthors,
  }) {
    return ExpansionTile(
      title: CustomText(
        text: 'Auteurs phares',
        fontSize: r.size(12),
        fontWeight: FontWeight.bold,
      ),
      initiallyExpanded: true,
      controlAffinity: ListTileControlAffinity.leading,
      shape: const Border(
        top: BorderSide.none,
        bottom: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
      ),
      iconColor: theme.accent,
      tilePadding: r.symmetric(horizontal: 0),
      childrenPadding: r.symmetric(horizontal: 20),
      expandedAlignment: Alignment.centerLeft,
      children: [
        CustomField(gap: r.size(2), children: [
          ...featuredAuthors.map((author) {
            return CustomButton(
              text: '${author.firstName} ${author.lastName}',
              fontSize: r.size(11),
              fontWeight: FontWeight.normal,
              onHoverStyle:
                  CustomButtonStyle(textColor: theme.accent.withOpacity(0.6)),
              onPressed: (position, size) {
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
              },
            );
          }),
        ])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomField(width: r.size(220), gap: r.size(10), children: [
        if (widget.sections.isNotEmpty)
          _buildSectionsNavigator(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            sections: widget.sections,
          ),
        if (widget.sections.isNotEmpty)
          CustomLine(
            color: widget.theme.accent,
            thickness: r.size(0.2),
            size: double.infinity,
            isVertical: false,
          ),
        _buildFiltrations(
          theme: widget.theme,
          ts: widget.ts,
          isRtl: widget.isRtl,
          filteringData: widget.filteringData,
        ),
        CustomLine(
          color: widget.theme.accent,
          thickness: r.size(0.2),
          size: double.infinity,
          isVertical: false,
        ),
        if (widget.featuredAuthors.isNotEmpty)
          _buildFeaturedAuthors(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            featuredAuthors: widget.featuredAuthors,
          ),
      ]),
    );
  }
}
