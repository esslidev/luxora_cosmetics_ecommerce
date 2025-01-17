import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../../../core/enums/widgets.dart';
import '../../../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../../../../core/util/translation_service.dart';
import '../../../../../../../widgets/common/custom_button.dart';
import '../../../../../../../widgets/common/custom_field.dart';
import '../../../../../../../widgets/common/custom_text.dart';
import '../../../../../../../widgets/common/custom_text_field.dart';

class AdvancedSearchValues {
  final String? title;
  final String? authorName;
  final String? editor;
  final String? categoryName;
  final String? publicationDate;

  AdvancedSearchValues({
    this.title,
    this.authorName,
    this.editor,
    this.categoryName,
    this.publicationDate,
  });
}

class SearchbarAdvancedDropdown extends StatefulWidget {
  final BaseTheme theme;
  final TranslationService ts;
  final bool isRtl;
  final Function(AdvancedSearchValues searchValues) onSubmitPressed;
  const SearchbarAdvancedDropdown({
    super.key,
    required this.theme,
    required this.ts,
    required this.isRtl,
    required this.onSubmitPressed,
  });

  @override
  State<SearchbarAdvancedDropdown> createState() =>
      _SearchbarAdvancedDropdownState();
}

class _SearchbarAdvancedDropdownState extends State<SearchbarAdvancedDropdown> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  //-------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return _buildSearchbarAdvancedDropdown(
      theme: widget.theme,
      ts: widget.ts,
      isRtl: widget.isRtl,
    );
  }

  //---------------------------------------------------------------//

  Widget _buildTitle({
    required BaseTheme theme,
    required TranslationService ts,
    required String title,
  }) {
    return CustomText(
      text: title,
      backgroundColor: theme.secondaryBackgroundColor,
      width: double.infinity,
      fontSize: r.size(10),
      fontWeight: FontWeight.bold,
      padding: EdgeInsets.symmetric(vertical: r.size(4), horizontal: r.size(8)),
    );
  }

  Widget _buildSearchbarAdvancedTextField({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String name,
    required String hint,
    required void Function(String value) onChanged,
  }) {
    return CustomField(
        arrangement: FieldArrangement.row,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        padding: r.symmetric(horizontal: 8),
        isRtl: isRtl,
        children: [
          CustomButton(
            cursor: SystemMouseCursors.basic,
            width: r.size(110),
            height: r.size(28),
            text: name,
            fontSize: r.size(10),
            padding: r.symmetric(horizontal: 8),
            borderRadius: BorderRadius.only(
              topLeft: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
              bottomLeft: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
              topRight: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
              bottomRight: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
            ),
            backgroundColor: theme.searchbarAdvancedBackgroundColor,
            fontWeight: FontWeight.bold,
            textColor: theme.bodyText,
            border: Border(
              top: BorderSide(color: theme.accent, width: r.size(1)),
              bottom: BorderSide(color: theme.accent, width: r.size(1)),
              left: !isRtl
                  ? BorderSide(color: theme.accent, width: r.size(1))
                  : BorderSide.none,
              right: isRtl
                  ? BorderSide(color: theme.accent, width: r.size(1))
                  : BorderSide.none,
            ),
          ),
          Expanded(
            child: CustomTextField(
              height: r.size(28),
              hintText: hint,
              fontSize: r.size(10),
              padding: EdgeInsets.symmetric(horizontal: r.size(8)),
              borderRadius: BorderRadius.only(
                topLeft: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                bottomLeft: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                topRight: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                bottomRight: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
              ),
              onChanged: (value, position, size) {
                onChanged(value);
              },
              border: Border(
                top: BorderSide(color: theme.accent, width: r.size(1)),
                bottom: BorderSide(color: theme.accent, width: r.size(1)),
                left: isRtl
                    ? BorderSide(color: theme.accent, width: r.size(1))
                    : BorderSide.none,
                right: !isRtl
                    ? BorderSide(color: theme.accent, width: r.size(1))
                    : BorderSide.none,
              ),
            ),
          ),
        ]);
  }

  Widget _buildSearchbarAdvancedDropdown(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl}) {
    final ValueNotifier<String> titleInputNotifier = ValueNotifier('');
    final ValueNotifier<String> authorNameInputNotifier = ValueNotifier('');
    final ValueNotifier<String> editorInputNotifier = ValueNotifier('');
    final ValueNotifier<String> categoryNameInputNotifier = ValueNotifier('');
    final ValueNotifier<String> publicationDateInputNotifier =
        ValueNotifier('');
    return CustomField(
        width: double.infinity,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: isRtl,
        gap: r.size(6),
        padding: r.all(4),
        children: [
          _buildTitle(
            theme: theme,
            ts: ts,
            title: ts.translate(
                'screens.home.header.searchbar.advancedOverlay.title'),
          ),
          CustomField(
              padding: r.only(top: 2, bottom: 2),
              gap: r.size(8),
              isRtl: isRtl,
              children: [
                CustomText(
                  text: ts.translate(
                      'screens.home.header.searchbar.advancedOverlay.searchCriteria'),
                  fontSize: r.size(12),
                  fontWeight: FontWeight.bold,
                ),
                CustomField(gap: r.size(6), isRtl: isRtl, children: [
                  _buildSearchbarAdvancedTextField(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    name: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.titleName'),
                    hint: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.titleHint'),
                    onChanged: (value) {
                      titleInputNotifier.value = value;
                    },
                  ),
                  _buildSearchbarAdvancedTextField(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    name: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.authorName'),
                    hint: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.authorHint'),
                    onChanged: (value) {
                      authorNameInputNotifier.value = value;
                    },
                  ),
                  _buildSearchbarAdvancedTextField(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    name: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.editorName'),
                    hint: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.editorHint'),
                    onChanged: (value) {
                      editorInputNotifier.value = value;
                    },
                  ),
                  _buildSearchbarAdvancedTextField(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    name: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.categoryName'),
                    hint: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.categoryHint'),
                    onChanged: (value) {
                      categoryNameInputNotifier.value = value;
                    },
                  ),
                  _buildSearchbarAdvancedTextField(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    name: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.publicationDateName'),
                    hint: ts.translate(
                        'screens.home.header.searchbar.advancedOverlay.publicationDateHint'),
                    onChanged: (value) {
                      publicationDateInputNotifier.value = value;
                    },
                  ),
                ]),
                Center(
                  child: ValueListenableBuilder<String>(
                    valueListenable: titleInputNotifier,
                    builder: (BuildContext context, String titleInput,
                        Widget? child) {
                      return ValueListenableBuilder<String>(
                        valueListenable: authorNameInputNotifier,
                        builder: (BuildContext context, String authorNameInput,
                            Widget? child) {
                          return ValueListenableBuilder<String>(
                            valueListenable: editorInputNotifier,
                            builder: (BuildContext context, String editorInput,
                                Widget? child) {
                              return ValueListenableBuilder<String>(
                                valueListenable: categoryNameInputNotifier,
                                builder: (BuildContext context,
                                    String categoryNameInput, Widget? child) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable:
                                        publicationDateInputNotifier,
                                    builder: (BuildContext context,
                                        String publicationDateInput,
                                        Widget? child) {
                                      final isEnabled = titleInput
                                              .trim()
                                              .isNotEmpty ||
                                          authorNameInput.trim().isNotEmpty ||
                                          editorInput.trim().isNotEmpty ||
                                          categoryNameInput.trim().isNotEmpty ||
                                          publicationDateInput
                                              .trim()
                                              .isNotEmpty;
                                      return CustomButton(
                                        enabled: isEnabled,
                                        text: ts.translate(
                                            'screens.home.header.searchbar.advancedOverlay.startSearch'),
                                        textColor: isEnabled
                                            ? AppColors.colors.whiteOut
                                            : theme.accent.withOpacity(0.3),
                                        fontSize: r.size(11),
                                        fontWeight: FontWeight.w800,
                                        backgroundColor: theme.primary,
                                        animationDuration: 300.ms,
                                        padding: r.symmetric(
                                            vertical: 2, horizontal: 18),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(r.size(2))),
                                        onHoverStyle: CustomButtonStyle(
                                            backgroundColor: theme.secondary),
                                        onDisabledStyle: CustomButtonStyle(
                                          backgroundColor:
                                              theme.secondaryBackgroundColor,
                                        ),
                                        onPressed: (position, size) {
                                          widget.onSubmitPressed(
                                              AdvancedSearchValues(
                                                  title: titleInput
                                                          .trim()
                                                          .isNotEmpty
                                                      ? titleInput
                                                      : null,
                                                  authorName: authorNameInput
                                                          .trim()
                                                          .isNotEmpty
                                                      ? authorNameInput
                                                      : null,
                                                  editor: editorInput
                                                          .trim()
                                                          .isNotEmpty
                                                      ? editorInput
                                                      : null,
                                                  categoryName:
                                                      categoryNameInput
                                                              .trim()
                                                              .isNotEmpty
                                                          ? categoryNameInput
                                                          : null,
                                                  publicationDate:
                                                      publicationDateInput
                                                              .trim()
                                                              .isNotEmpty
                                                          ? publicationDateInput
                                                          : null));
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
              ]),
        ]);
  }
}
