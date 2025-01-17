import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/resources/bread_crumb_model.dart';
import 'package:librairie_alfia/features/domain/entities/category.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/notification_type.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/custom_timer.dart';
import '../../../../../core/util/remote_events_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../bloc/remote/category/category_bloc.dart';
import '../../../bloc/remote/category/category_state.dart';
import '../../../overlays/dropdown/dropdown.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_shrinking_line.dart';

class NavigatorWidget extends StatefulWidget {
  const NavigatorWidget({super.key});

  @override
  State<NavigatorWidget> createState() => _NavigatorWidgetState();
}

class _NavigatorWidgetState extends State<NavigatorWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;
  final GlobalKey _navigatorKey = GlobalKey();
  CustomTimer? _hoverTimer;
  final ScrollController _scrollStandaloneSubCategoryController =
      ScrollController();
  final ScrollController _scrollNestedSubCategoryController =
      ScrollController();

  late DropdownOverlay _categoryListDropdown;

  List<CategoryEntity> _categoriesResponse = [];

  final LayerLink _dropdownLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = locator<GlobalContexts>().homeContext;
      _categoryListDropdown = _buildCategoryListDropdown();
      RemoteEventsUtil.categoryEvents.getNavigatorAllCategories(context);
    });
  }

  //----------------------------------------------------------------------------------------------------//

  DropdownOverlay _buildCategoryListDropdown() {
    return DropdownOverlay(
      context: context,
      dismissOnHoverExit: true,
      borderRadius: Radius.circular(r.size(2)),
      borderWidth: r.size(1),
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
    );
  }

  Widget _buildCategoryListDropdownChild({
    required BaseTheme theme,
    required TranslationService ts,
    required LanguageModel language,
    required List<CategoryEntity> subCategories,
  }) {
    List<CategoryEntity> standaloneSubCategories = subCategories
        .where((category) =>
            category.subCategories == null || category.subCategories!.isEmpty)
        .toList();
    List<CategoryEntity> nestedSubCategories = subCategories
        .where((category) =>
            category.subCategories != null &&
            category.subCategories!.isNotEmpty)
        .toList();
    return CustomField(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      maxHeight: r.size(220),
      isRtl: language.isRtl,
      gap: r.size(24),
      padding: r.symmetric(vertical: 18, horizontal: 18),
      arrangement: FieldArrangement.row,
      children: [
        if (standaloneSubCategories != [])
          RawScrollbar(
            thumbColor: theme.primary.withOpacity(0.4),
            radius: Radius.circular(r.size(10)),
            thickness: r.size(5),
            thumbVisibility: true,
            controller: _scrollStandaloneSubCategoryController,
            child: SingleChildScrollView(
              controller: _scrollStandaloneSubCategoryController,
              child: CustomField(
                gap: r.size(2),
                isRtl: language.isRtl,
                children: standaloneSubCategories.map((standaloneSubCategory) {
                  String? categoryName = standaloneSubCategory.translations!
                      .firstWhere((translation) =>
                          translation.languageCode == language.languageCode)
                      .name;
                  return CustomButton(
                    text: categoryName,
                    fontSize: r.size(12),
                    fontWeight: FontWeight.bold,
                    textColor: theme.accent.withOpacity(0.8),
                    onHoverStyle: CustomButtonStyle(textColor: theme.accent),
                    onPressed: (position, size) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${standaloneSubCategory.categoryNumber}');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: categoryName ?? '',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${standaloneSubCategory.categoryNumber}'));
                      _categoryListDropdown.dismiss();
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        if (nestedSubCategories != [])
          Expanded(
            child: RawScrollbar(
              thumbColor: theme.primary.withOpacity(0.4),
              radius: Radius.circular(r.size(10)),
              thickness: r.size(5),
              thumbVisibility: true,
              controller: _scrollNestedSubCategoryController,
              child: SingleChildScrollView(
                controller: _scrollNestedSubCategoryController,
                child: CustomField(
                  isRtl: language.isRtl,
                  isWrap: true,
                  wrapHorizontalSpacing: r.size(12),
                  wrapVerticalSpacing: r.size(12),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  arrangement: FieldArrangement.row,
                  children: nestedSubCategories.map((nestedSubCategory) {
                    String? categoryName = nestedSubCategory.translations!
                        .firstWhere((translation) =>
                            translation.languageCode == language.languageCode)
                        .name;
                    return CustomField(
                      isRtl: language.isRtl,
                      minWidth: r.size(170),
                      children: [
                        CustomButton(
                          text: categoryName,
                          fontSize: r.size(11),
                          fontWeight: FontWeight.w800,
                          textColor: AppColors.colors.yellowHoneyGlow,
                          onHoverStyle: CustomButtonStyle(
                              textColor: AppColors.colors.yellowHoneyGlow
                                  .withOpacity(0.8)),
                          onPressed: (position, size) {
                            Beamer.of(context).beamToNamed(
                                '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${nestedSubCategory.categoryNumber}');
                            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                                breadCrumb: BreadCrumbModel(
                                    name: categoryName ?? '',
                                    path:
                                        '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${nestedSubCategory.categoryNumber}'));
                            _categoryListDropdown.dismiss();
                          },
                        ),
                        CustomField(
                          isRtl: language.isRtl,
                          children: nestedSubCategory.subCategories!
                              .map((subCategory) {
                            String? categoryName = subCategory.translations!
                                .firstWhere((translation) =>
                                    translation.languageCode ==
                                    language.languageCode)
                                .name;
                            return CustomButton(
                              text: categoryName,
                              fontSize: r.size(10),
                              fontWeight: FontWeight.normal,
                              onPressed: (position, size) {
                                Beamer.of(context).beamToNamed(
                                    '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${subCategory.categoryNumber}');
                                AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                                    breadCrumb: BreadCrumbModel(
                                        name: categoryName ?? '',
                                        path:
                                            '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${subCategory.categoryNumber}'));
                                _categoryListDropdown.dismiss();
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          )
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
            if (translationState.translationService != null &&
                translationState.language != null) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<RemoteCategoryBloc, RemoteCategoryState>(
                    listener: (context, state) {
                      if (state is RemoteCategoriesLoaded) {
                        if (state.navigatorAllCategories != null) {
                          setState(() {
                            _categoriesResponse = state.navigatorAllCategories!;
                          });
                        }
                      }

                      if (state is RemoteCategoryError) {
                        AppEventsUtil.liteNotifications
                            .addLiteNotification(context,
                                notification: LiteNotificationModel(
                                  notificationTitle:
                                      state.error?.response?.data["error"],
                                  notificationMessage:
                                      state.error?.response?.data["message"],
                                  notificationType: NotificationType.error,
                                ));
                      }
                    },
                  ),
                ],
                child: ResponsiveScreenAdapter(
                  screenLargeDesktop: _buildNavigator(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!,
                  ),
                  screenDesktop: _buildNavigator(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildMainCategoryButton({
    required String text,
    required bool isRtl,
    bool isLast = false,
    bool showArrow = false,
    required Function() onPressed,
    required Function() onHoverEnter,
    required Function() onHoverExit,
  }) {
    return CustomField(
        mainAxisSize: MainAxisSize.min,
        gap: r.nonMultipliedSize(6),
        isRtl: isRtl,
        arrangement: FieldArrangement.row,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
            animationDuration: 300.ms,
            text: text,
            padding: r.symmetric(vertical: 8),
            fontSize: r.nonMultipliedSize(12),
            fontWeight: FontWeight.bold,
            textColor: AppColors.colors.whiteSolid,
            svgIconPath: showArrow ? AppPaths.vectors.triangleBottomIcon : null,
            iconColor: AppColors.colors.whiteSolid,
            iconWidth: r.nonMultipliedSize(4),
            iconHeight: r.nonMultipliedSize(4),
            iconTextGap: r.nonMultipliedSize(4),
            iconPosition: CustomButtonIconPosition.right,
            onPressed: (position, size) {
              onPressed();
            },
            onHoverEnter: (position, size) {
              if (_hoverTimer?.isRunning() != true) {
                _hoverTimer = CustomTimer(
                  onTick: (_) {},
                  onTimerStop: () {
                    onHoverEnter();
                  },
                );
                _hoverTimer!.start(duration: 1000.ms);
              } else {
                _hoverTimer!.restart(duration: 1000.ms);
              }
            },
            onHoverExit: () {
              if (_hoverTimer?.isRunning() != true) {
                onHoverExit();
              } else {
                _hoverTimer?.stop();
              }
            },
            onHoverStyle: CustomButtonStyle(
              textColor: AppColors.colors.whiteMuffled,
              iconColor: AppColors.colors.whiteMuffled,
            ),
          ),
          if (isLast != true)
            CustomShrinkingLine(
              isVertical: true,
              color: AppColors.colors.whiteSolid,
              thickness: r.nonMultipliedSize(1),
              size: r.nonMultipliedSize(18),
            ),
        ]);
  }

  Widget _buildNavigator(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CompositedTransformTarget(
      link: _dropdownLayerLink,
      child: CustomField(
        key: _navigatorKey,
        width: double.infinity,
        backgroundColor: theme.primary,
        arrangement: FieldArrangement.row,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: r.symmetric(horizontal: 10),
        isRtl: language.isRtl,
        isWrap: true,
        wrapHorizontalSpacing: r.size(8),
        wrapVerticalSpacing: r.size(4),
        children: _categoriesResponse.asMap().entries.map((entry) {
          int index = entry.key;
          CategoryEntity category = entry.value;

          String? categoryName = category.translations!
              .firstWhere((translation) =>
                  translation.languageCode == language.languageCode)
              .name;

          return _buildMainCategoryButton(
              text: categoryName!,
              isRtl: language.isRtl,
              showArrow: category.subCategories!.isNotEmpty,
              isLast: index == _categoriesResponse.length - 1,
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${category.categoryNumber}');
                AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                    breadCrumb: BreadCrumbModel(
                        name: categoryName ?? '',
                        path:
                            '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=${category.categoryNumber}'));
              },
              onHoverEnter: () {
                if (category.subCategories != null &&
                    category.subCategories!.isNotEmpty) {
                  _categoryListDropdown.show(
                      layerLink: _dropdownLayerLink,
                      backgroundColor: theme.overlayBackgroundColor,
                      borderColor: theme.accent.withOpacity(0.4),
                      shadowColor: theme.shadowColor,
                      targetWidgetSize: Size(r.screenWidth,
                          AppUtil.getSizeByGlobalKey(_navigatorKey).height),
                      width: r.screenWidth - (r.screenWidth / 6),
                      dropdownAlignment: DropdownAlignment.center,
                      child: _buildCategoryListDropdownChild(
                        theme: theme,
                        ts: ts,
                        language: language,
                        subCategories: category.subCategories ?? [],
                      ));
                }
              },
              onHoverExit: () {
                _categoryListDropdown.dismiss(delay: 800.ms);
              });
        }).toList(),
      ),
    );
  }
}
