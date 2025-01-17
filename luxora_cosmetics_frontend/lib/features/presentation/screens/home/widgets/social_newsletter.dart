import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/util/app_util.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/constants/social_media_paths.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_text.dart';
import '../../../widgets/common/custom_text_field.dart';

class SocialNewsletterWidget extends StatefulWidget {
  const SocialNewsletterWidget({super.key});

  @override
  State<SocialNewsletterWidget> createState() => _SocialNewsletterWidgetState();
}

class _SocialNewsletterWidgetState extends State<SocialNewsletterWidget> {
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
                fallbackScreen: _buildLargeDesktop(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!),
                screenTablet: _buildLargeTabletMobile(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!),
                screenMobile: _buildLargeTabletMobile(
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

  _buildSocialButton(
      {required BaseTheme theme,
      required String svgIconPath,
      required Color onHoverColor,
      required String launcherUrl}) {
    return CustomButton(
      svgIconPath: svgIconPath,
      iconColor: theme.bodyText,
      iconHeight: r.size(22),
      borderRadius: BorderRadius.all(Radius.circular(r.size(12))),
      onHoverStyle: CustomButtonStyle(backgroundColor: onHoverColor),
      onPressed: (position, size) {
        AppUtil.launchURL(launcherUrl);
      },
    );
  }

  Widget _buildLargeDesktop(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      backgroundColor: theme.secondaryBackgroundColor,
      padding: r.symmetric(vertical: 16),
      mainAxisAlignment: MainAxisAlignment.center,
      gap: r.size(26),
      crossAxisAlignment: CrossAxisAlignment.center,
      margin: r.only(bottom: 20),
      arrangement: FieldArrangement.row,
      isRtl: language.isRtl,
      children: [
        CustomField(
          arrangement: FieldArrangement.row,
          gap: r.size(10),
          isRtl: language.isRtl,
          children: [
            CustomText(
              text: ts.translate('screens.home.socialNewsLetter.followUs'),
              fontSize: r.size(14),
              color: theme.bodyText,
              textDirection:
                  language.isRtl ? TextDirection.rtl : TextDirection.ltr,
            ),
            _buildSocialButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.facebookIcon,
                onHoverColor: AppColors.colors.blueDeepSky,
                launcherUrl: facebookPath),
            _buildSocialButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.instagramIcon,
                onHoverColor: AppColors.colors.purpleHarleyHair,
                launcherUrl: instagramPath),
            _buildSocialButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.youtubeIcon,
                onHoverColor: AppColors.colors.redRouge,
                launcherUrl: youtubePath),
          ],
        ),
        CustomField(
            arrangement: FieldArrangement.row,
            gap: r.size(10),
            crossAxisAlignment: CrossAxisAlignment.center,
            isRtl: language.isRtl,
            children: [
              CustomText(
                text: ts.translate('screens.home.socialNewsLetter.subscribe'),
                fontSize: r.size(14),
                color: theme.bodyText,
                textDirection:
                    language.isRtl ? TextDirection.rtl : TextDirection.ltr,
              ),
              CustomField(
                  arrangement: FieldArrangement.row,
                  gap: r.size(2),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  isRtl: language.isRtl,
                  children: [
                    CustomTextField(
                      width: r.size(200),
                      height: r.size(26),
                      keyboardType: TextInputType.emailAddress,
                      hintText: ts.translate(
                          'screens.home.socialNewsLetter.enterEmailHint'),
                      backgroundColor: AppColors.colors.whiteOut,
                      padding: EdgeInsets.symmetric(horizontal: r.size(8)),
                      fontSize: r.size(10),
                      textColor: AppColors.colors.blackVelvet,
                      hintColor: AppColors.colors.blackVelvet.withOpacity(0.5),
                      border:
                          Border.all(width: r.size(0.5), color: theme.accent),
                    ),
                    CustomButton(
                      height: r.size(27),
                      backgroundColor: theme.newsLetterBackgroundColor,
                      text:
                          ts.translate('screens.home.socialNewsLetter.signUp'),
                      fontSize: r.size(14),
                      textColor: AppColors.colors.whiteOut,
                      padding: EdgeInsets.symmetric(horizontal: r.size(16)),
                    )
                  ])
            ])
      ],
    );
  }

  Widget _buildLargeTabletMobile(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
  ) {
    return CustomField(
      backgroundColor: theme.secondaryBackgroundColor,
      padding: r.symmetric(vertical: 16),
      gap: r.size(14),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      margin: r.only(bottom: 20),
      arrangement: FieldArrangement.column,
      isRtl: language.isRtl,
      width: double.infinity,
      children: [
        CustomField(
          arrangement: FieldArrangement.row,
          gap: r.size(10),
          isRtl: language.isRtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSocialButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.facebookIcon,
                onHoverColor: AppColors.colors.blueDeepSky,
                launcherUrl: facebookPath),
            _buildSocialButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.instagramIcon,
                onHoverColor: AppColors.colors.purpleHarleyHair,
                launcherUrl: instagramPath),
            _buildSocialButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.youtubeIcon,
                onHoverColor: AppColors.colors.redRouge,
                launcherUrl: youtubePath),
          ],
        ),
        CustomField(
            arrangement: FieldArrangement.row,
            gap: r.size(10),
            crossAxisAlignment: CrossAxisAlignment.center,
            isRtl: language.isRtl,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomField(
                  arrangement: FieldArrangement.row,
                  gap: r.size(4),
                  crossAxisAlignment: CrossAxisAlignment.center,
                  isRtl: language.isRtl,
                  children: [
                    CustomTextField(
                      width: r.size(160),
                      height: r.size(26),
                      keyboardType: TextInputType.emailAddress,
                      hintText: ts.translate(
                          'screens.home.socialNewsLetter.enterEmailHint'),
                      backgroundColor: AppColors.colors.whiteOut,
                      padding: EdgeInsets.symmetric(horizontal: r.size(8)),
                      fontSize: r.size(10),
                      textColor: AppColors.colors.blackVelvet,
                      hintColor: AppColors.colors.blackVelvet.withOpacity(0.5),
                      border:
                          Border.all(width: r.size(0.5), color: theme.accent),
                    ),
                    CustomButton(
                      height: r.size(27),
                      backgroundColor: theme.newsLetterBackgroundColor,
                      text: ts
                          .translate('screens.home.socialNewsLetter.subscribe'),
                      fontSize: r.size(10),
                      textColor: AppColors.colors.whiteOut,
                      padding: r.symmetric(horizontal: 5),
                    )
                  ])
            ])
      ],
    );
  }
}
