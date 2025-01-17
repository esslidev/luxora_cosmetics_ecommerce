import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../widgets/common/custom_display.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_shrinking_line.dart';
import '../../../widgets/common/custom_text.dart';

class ServiceHighlightsWidget extends StatefulWidget {
  const ServiceHighlightsWidget({super.key});

  @override
  State<ServiceHighlightsWidget> createState() =>
      _ServiceHighlightsWidgetState();
}

class _ServiceHighlightsWidgetState extends State<ServiceHighlightsWidget> {
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
                screenLargeDesktop: _buildLargeDesktop(
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

  Widget _buildLargeDesktop(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(16),
      margin: r.only(bottom: 20),
      isRtl: language.isRtl,
      children: [
        CustomShrinkingLine(
          size: r.size(700),
          thickness: r.size(1),
          color: theme.accent.withOpacity(0.8),
        ),
        CustomField(
            width: double.infinity,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: r.size(60),
            arrangement: FieldArrangement.row,
            isRtl: language.isRtl,
            isWrap: true,
            wrapHorizontalSpacing: r.size(40),
            wrapVerticalSpacing: r.size(20),
            children: [
              CustomField(
                width: r.size(165),
                crossAxisAlignment: CrossAxisAlignment.center,
                gap: r.size(8),
                arrangement: FieldArrangement.row,
                isRtl: language.isRtl,
                children: [
                  CustomDisplay(
                    width: r.size(60),
                    height: r.size(42),
                    assetPath: AppPaths.vectors.securedPaymentIcon,
                    isSvg: true,
                    svgColor: theme.accent.withOpacity(0.8),
                  ),
                  Flexible(
                    child: CustomText(
                      text: ts.translate(
                          'screens.home.serviceHighlights.securedPayment'),
                      fontSize: r.size(12),
                      color: theme.bodyText,
                      lineHeight: 0,
                      textDirection: language.isRtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              CustomField(
                width: r.size(165),
                crossAxisAlignment: CrossAxisAlignment.center,
                gap: r.size(8),
                arrangement: FieldArrangement.row,
                isRtl: language.isRtl,
                children: [
                  CustomDisplay(
                    width: r.size(60),
                    height: r.size(42),
                    assetPath: AppPaths.vectors.assistanceIcon,
                    isSvg: true,
                    svgColor: theme.accent.withOpacity(0.8),
                  ),
                  Flexible(
                    child: CustomText(
                      text: ts.translate(
                          'screens.home.serviceHighlights.adviceOrderTracking'),
                      color: theme.bodyText,
                      fontSize: r.size(12),
                      lineHeight: 0,
                      textDirection: language.isRtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
              CustomField(
                width: r.size(165),
                crossAxisAlignment: CrossAxisAlignment.center,
                gap: r.size(8),
                arrangement: FieldArrangement.row,
                isRtl: language.isRtl,
                children: [
                  CustomDisplay(
                    width: r.size(60),
                    height: r.size(42),
                    assetPath: AppPaths.vectors.fastDeliveryIcon,
                    isSvg: true,
                    svgColor: theme.accent.withOpacity(0.8),
                  ),
                  Flexible(
                    child: CustomText(
                      text: ts.translate(
                          'screens.home.serviceHighlights.fastDelivery'),
                      color: theme.bodyText,
                      fontSize: r.size(12),
                      lineHeight: 0,
                      textDirection: language.isRtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ]),
        CustomShrinkingLine(
          size: r.size(700),
          thickness: r.size(1),
          color: theme.accent.withOpacity(0.8),
        ),
      ],
    );
  }
}
