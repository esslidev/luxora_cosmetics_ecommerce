import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:librairie_alfia/core/constants/google_maps_constants.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_text.dart';

class QuickLinksWidget extends StatefulWidget {
  const QuickLinksWidget({super.key});

  @override
  State<QuickLinksWidget> createState() => _QuickLinksWidgetState();
}

class _QuickLinksWidgetState extends State<QuickLinksWidget> {
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
                screenTablet: _buildTablet(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!),
                screenMobile: _buildMobile(
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

  Widget _buildListTitle({required String title}) {
    return CustomText(
      text: title,
      fontSize: r.size(13),
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildLinkButton(
      {required BaseTheme theme,
      required String name,
      required Function() onPressed}) {
    return CustomButton(
      text: name,
      fontSize: r.size(11),
      fontWeight: FontWeight.w500,
      textColor: theme.accent.withOpacity(0.8),
      onHoverStyle: CustomButtonStyle(textColor: theme.accent),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildGoogleMap(String url) {
    if (kIsWeb) {
      return SizedBox(
        height: r.size(110),
        width: r.size(140),
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(url),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        height: r.size(110),
        width: r.size(140),
        child: const CustomText(
          text: 'google maps only available for web',
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildLargeDesktop(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
        width: double.infinity,
        backgroundColor: theme.secondaryBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: r.symmetric(vertical: 20),
        gap: r.size(30),
        arrangement: FieldArrangement.row,
        isRtl: language.isRtl,
        children: [
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildListTitle(title: ts.translate('Alfia Centre ville')),
                _buildGoogleMap(map1Url),
              ]),
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildListTitle(title: ts.translate('Alfia Temara')),
                _buildGoogleMap(map2Url),
              ]),
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildListTitle(
                    title: ts.translate(
                        'screens.home.quickLinks.information.title')),
                CustomField(
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.whoWeAre'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.deliveryInformation'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.privacyPolicy'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.salesTerms'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.contactUs'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.siteMap'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.newsletter'),
                        onPressed: () {}),
                  ],
                ),
              ]),
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildListTitle(
                    title:
                        ts.translate('screens.home.quickLinks.extras.title')),
                CustomField(
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLinkButton(
                        theme: theme,
                        name: ts
                            .translate('screens.home.quickLinks.extras.author'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.giftVouchers'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.affiliations'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.promotions'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.returnPolicy'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.orderHistory'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.wishlist'),
                        onPressed: () {}),
                  ],
                ),
              ])
        ]);
  }

  Widget _buildTablet(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      children: [
        CustomField(
            width: double.infinity,
            backgroundColor: theme.secondaryBackgroundColor,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: r.symmetric(vertical: 20),
            gap: r.size(30),
            arrangement: FieldArrangement.row,
            isRtl: language.isRtl,
            children: [
              CustomField(
                  gap: r.size(4),
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  minWidth: r.size(140),
                  children: [
                    _buildListTitle(
                        title: ts.translate(
                            'screens.home.quickLinks.information.title')),
                    CustomField(
                      isRtl: language.isRtl,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.whoWeAre'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.deliveryInformation'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.privacyPolicy'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.salesTerms'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.contactUs'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.siteMap'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.information.newsletter'),
                            onPressed: () {}),
                      ],
                    ),
                  ]),
              CustomField(
                  gap: r.size(4),
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  minWidth: r.size(140),
                  children: [
                    _buildListTitle(
                        title: ts
                            .translate('screens.home.quickLinks.extras.title')),
                    CustomField(
                      isRtl: language.isRtl,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.author'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.giftVouchers'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.affiliations'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.promotions'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.returnPolicy'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.orderHistory'),
                            onPressed: () {}),
                        _buildLinkButton(
                            theme: theme,
                            name: ts.translate(
                                'screens.home.quickLinks.extras.wishlist'),
                            onPressed: () {}),
                      ],
                    ),
                  ])
            ]),
        CustomField(
            width: double.infinity,
            backgroundColor: theme.secondaryBackgroundColor,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: r.symmetric(vertical: 20),
            gap: r.size(30),
            arrangement: FieldArrangement.row,
            isRtl: language.isRtl,
            children: [
              CustomField(
                  gap: r.size(4),
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildListTitle(title: ts.translate('Alfia Centre ville')),
                    _buildGoogleMap(map1Url),
                  ]),
              CustomField(
                  gap: r.size(4),
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildListTitle(title: ts.translate('Alfia Temara')),
                    _buildGoogleMap(map2Url),
                  ]),
            ]),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
        width: double.infinity,
        backgroundColor: theme.secondaryBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: r.symmetric(vertical: 20),
        gap: r.size(10),
        isRtl: language.isRtl,
        children: [
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildListTitle(
                    title: ts.translate(
                        'screens.home.quickLinks.information.title')),
                CustomField(
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.whoWeAre'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.deliveryInformation'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.privacyPolicy'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.salesTerms'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.contactUs'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.siteMap'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.information.newsletter'),
                        onPressed: () {}),
                  ],
                ),
              ]),
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildListTitle(
                    title:
                        ts.translate('screens.home.quickLinks.extras.title')),
                CustomField(
                  isRtl: language.isRtl,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLinkButton(
                        theme: theme,
                        name: ts
                            .translate('screens.home.quickLinks.extras.author'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.giftVouchers'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.affiliations'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.promotions'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.returnPolicy'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.orderHistory'),
                        onPressed: () {}),
                    _buildLinkButton(
                        theme: theme,
                        name: ts.translate(
                            'screens.home.quickLinks.extras.wishlist'),
                        onPressed: () {}),
                  ],
                ),
              ]),
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildListTitle(title: ts.translate('Alfia Centre ville')),
                _buildGoogleMap(map1Url),
              ]),
          CustomField(
              gap: r.size(4),
              isRtl: language.isRtl,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildListTitle(title: ts.translate('Alfia Temara')),
                _buildGoogleMap(map2Url),
              ]),
        ]);
  }
}
