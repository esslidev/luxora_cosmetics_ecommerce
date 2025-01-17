import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/data/models/author.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_display.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/resources/language_model.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';
import '../../../../bloc/app/language/translation_bloc.dart';
import '../../../../bloc/app/language/translation_state.dart';
import '../../../../bloc/app/theme/theme_bloc.dart';
import '../../../../bloc/app/theme/theme_state.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_field.dart';
import '../../../../widgets/common/custom_text.dart';
import '../../../../widgets/features/product.dart';

class AuthorOfMonthWidget extends StatefulWidget {
  const AuthorOfMonthWidget({super.key});

  @override
  State<AuthorOfMonthWidget> createState() => _AuthorOfMonthWidgetState();
}

class _AuthorOfMonthWidgetState extends State<AuthorOfMonthWidget> {
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
                fallbackScreen: _buildAuthorOfMonth(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!),
                screenMobile: _buildAuthorOfMonth(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!,
                    isOnlyAuthorImage: true),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  ProductWidget _buildProduct(
      {required String networkAssetPath,
      required String authorName,
      required String title,
      required double price}) {
    return ProductWidget(
      width: r.size(90),
      height: r.size(110),
      isOfferBadgeVisible: false,
      isActionsCardVisible: false,
      networkImageUrl: networkAssetPath,
      author: const AuthorModel(
        firstName: 'Elif',
        lastName: 'Shafak',
      ),
      title: "Changez d'alimentation",
      price: 109,
      authorFontSize: r.size(6),
      titleFontSize: r.size(6),
      priceFontSize: r.size(8),
    );
  }

  Widget _buildAuthorCard({
    required BaseTheme theme,
    required TranslationService ts,
    required String authorAssetNetwork,
    required List<String> books,
    bool? isOnlyAuthorImage,
  }) {
    return CustomField(
        arrangement: FieldArrangement.row,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        height: r.size(280),
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOnlyAuthorImage != true)
            CustomField(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              padding: r.symmetric(vertical: 10),
              backgroundColor: theme.secondaryBackgroundColor,
              gap: r.size(10),
              children: [
                CustomField(
                  width: r.size(200),
                  arrangement: FieldArrangement.row,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  isWrap: true,
                  wrapVerticalSpacing: r.size(10),
                  wrapHorizontalSpacing: r.size(10),
                  children: [
                    _buildProduct(
                        networkAssetPath: books[0],
                        authorName: 'Elif Shafak',
                        title: "Changez d'alimentation",
                        price: 109),
                    _buildProduct(
                        networkAssetPath: books[0],
                        authorName: 'Elif Shafak',
                        title: "Changez d'alimentation",
                        price: 109),
                    _buildProduct(
                        networkAssetPath: books[0],
                        authorName: 'Elif Shafak',
                        title: "Changez d'alimentation",
                        price: 109),
                    _buildProduct(
                        networkAssetPath: books[0],
                        authorName: 'Elif Shafak',
                        title: "Changez d'alimentation",
                        price: 109),
                  ],
                ),
                CustomButton(
                  text: ts.translate('widgets.productSlider.seeAll'),
                  textColor: theme.bodyText,
                  fontSize: r.size(12),
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          CustomDisplay(
            assetPath: authorAssetNetwork,
            fit: BoxFit.cover,
            width: r.size(200),
            height: double.infinity,
            cursor: SystemMouseCursors.click,
          )
        ]);
  }

  Widget _buildAuthorOfMonth(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language,
      {bool? isOnlyAuthorImage}) {
    return CustomField(
      width: double.infinity,
      gap: r.size(30),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      isRtl: language.isRtl,
      children: [
        CustomText(
          width: double.infinity,
          textPosition: TextPosition.center,
          color: AppColors.colors.whiteSolid,
          letterSpacing: r.size(1),
          text: ts.translate('screens.explore.authorOfMonth.title'),
          fontSize: r.size(14),
          fontWeight: FontWeight.bold,
          backgroundColor: theme.primary,
          padding: r.symmetric(vertical: 6),
          textDirection: language.isRtl ? TextDirection.rtl : TextDirection.ltr,
        ),
        CustomField(
            arrangement: FieldArrangement.row,
            isRtl: language.isRtl,
            width: double.infinity,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            isWrap: true,
            wrapHorizontalSpacing: r.size(14),
            wrapVerticalSpacing: r.size(14),
            children: [
              _buildAuthorCard(
                  theme: theme,
                  ts: ts,
                  authorAssetNetwork: AppPaths.images.author1Example,
                  books: [
                    'https://m.media-amazon.com/images/I/61UI+IWTuQL._SL1500_.jpg',
                    'https://m.media-amazon.com/images/I/61UI+IWTuQL._SL1500_.jpg',
                    'https://m.media-amazon.com/images/I/61UI+IWTuQL._SL1500_.jpg',
                    'https://m.media-amazon.com/images/I/61UI+IWTuQL._SL1500_.jpg',
                  ],
                  isOnlyAuthorImage: isOnlyAuthorImage),
              _buildAuthorCard(
                  theme: theme,
                  ts: ts,
                  authorAssetNetwork: AppPaths.images.author2Example,
                  books: [
                    'https://m.media-amazon.com/images/I/71iQ+eEKBUL._SL1500_.jpg',
                    'https://m.media-amazon.com/images/I/71iQ+eEKBUL._SL1500_.jpg',
                    'https://m.media-amazon.com/images/I/71iQ+eEKBUL._SL1500_.jpg',
                    'https://m.media-amazon.com/images/I/71iQ+eEKBUL._SL1500_.jpg',
                  ],
                  isOnlyAuthorImage: isOnlyAuthorImage),
            ])
      ],
    );
  }
}
