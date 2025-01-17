import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../widgets/common/custom_display.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_text.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
            if (translationState.translationService != null &&
                translationState.language != null) {
              return ResponsiveScreenAdapter(
                fallbackScreen: buildLargeDesktop(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!),
                screenMobile: buildMobile(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget buildLargeDesktop(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
        backgroundColor: theme.footerBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: r.symmetric(vertical: 6),
        isRtl: language.isRtl,
        children: [
          CustomField(
              isRtl: language.isRtl,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              padding: r.symmetric(vertical: 12),
              gap: r.size(40),
              arrangement: FieldArrangement.row,
              children: [
                CustomField(isRtl: language.isRtl, gap: r.size(4), children: [
                  CustomText(
                    text: ts.translate('screens.home.footer.paymentMode'),
                    color: AppColors.colors.whiteMuffled.withOpacity(0.8),
                    fontSize: r.size(10),
                    textDirection:
                        language.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  CustomDisplay(
                    assetPath: AppPaths.images.paymentMethods,
                    height: r.size(20),
                    fit: BoxFit.cover,
                  ),
                ]),
                CustomField(
                  gap: r.size(12),
                  arrangement: FieldArrangement.row,
                  children: [
                    CustomDisplay(
                      width: r.size(50),
                      height: r.size(50),
                      assetPath: AppPaths.images.mjccLogo,
                      fit: BoxFit.cover,
                      cursor: SystemMouseCursors.click,
                      onTap: () {
                        AppUtil.launchURL(mjccUrl);
                      },
                    ),
                    CustomDisplay(
                      width: r.size(50),
                      height: r.size(50),
                      assetPath: AppPaths.images.cnlReferenceLogo,
                      fit: BoxFit.cover,
                      cursor: SystemMouseCursors.click,
                      onTap: () {
                        AppUtil.launchURL(cnlRefUrl);
                      },
                    ),
                  ],
                ),
              ]),
          CustomField(
              arrangement: FieldArrangement.row,
              mainAxisAlignment: MainAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                CustomText(
                  text: ts.translate('screens.home.footer.allRights'),
                  fontSize: r.size(9),
                  color: AppColors.colors.whiteOut,
                  textDirection:
                      language.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: TextAlign.center,
                )
              ])
        ]);
  }

  Widget buildMobile(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
        backgroundColor: theme.footerBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: r.symmetric(vertical: 6),
        isRtl: language.isRtl,
        gap: r.size(8),
        children: [
          CustomField(
              crossAxisAlignment: CrossAxisAlignment.center,
              isRtl: language.isRtl,
              gap: r.size(4),
              children: [
                CustomText(
                  text: ts.translate('screens.home.footer.paymentMode'),
                  color: AppColors.colors.whiteMuffled.withOpacity(0.8),
                  fontSize: r.size(10),
                  textDirection:
                      language.isRtl ? TextDirection.rtl : TextDirection.ltr,
                ),
                CustomDisplay(
                  assetPath: AppPaths.images.paymentMethods,
                  height: r.size(20),
                  fit: BoxFit.cover,
                ),
              ]),
          CustomField(
            gap: r.size(12),
            mainAxisSize: MainAxisSize.min,
            arrangement: FieldArrangement.row,
            children: [
              CustomDisplay(
                width: r.size(80),
                height: r.size(80),
                assetPath: AppPaths.images.mjccLogo,
                fit: BoxFit.cover,
                cursor: SystemMouseCursors.click,
                onTap: () {
                  AppUtil.launchURL(mjccUrl);
                },
              ),
              CustomDisplay(
                width: r.size(80),
                height: r.size(80),
                assetPath: AppPaths.images.cnlReferenceLogo,
                fit: BoxFit.cover,
                cursor: SystemMouseCursors.click,
                onTap: () {
                  AppUtil.launchURL(cnlRefUrl);
                },
              ),
            ],
          ),
          CustomField(
              arrangement: FieldArrangement.row,
              mainAxisAlignment: MainAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                CustomText(
                  text: ts.translate('screens.home.footer.allRights'),
                  fontSize: r.size(9),
                  color: AppColors.colors.whiteOut,
                  textDirection:
                      language.isRtl ? TextDirection.rtl : TextDirection.ltr,
                  textAlign: TextAlign.center,
                )
              ])
        ]);
  }
}
