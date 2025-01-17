import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/data/models/author.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_dashed_line.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/resources/language_model.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';
import '../../../../../domain/entities/product.dart';
import '../../../../bloc/app/language/translation_bloc.dart';
import '../../../../bloc/app/language/translation_state.dart';
import '../../../../bloc/app/theme/theme_bloc.dart';
import '../../../../bloc/app/theme/theme_state.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_field.dart';
import '../../../../widgets/common/custom_shrinking_line.dart';
import '../../../../widgets/common/custom_text.dart';
import '../../../../widgets/features/product.dart';

class TopProductsWidget extends StatefulWidget {
  final List<ProductEntity> topBooks;
  final double? width;
  final EdgeInsets? padding;
  final bool? isHorizontal;
  // action callbacks
  final Function()? onSeeAllPressed;
  final Function(int productId, String productName)? onPressed;
  final Function(int productId)? onWishlistPressed;
  final Function(int productId)? onCartPressed;
  final Function(int productId)? onPurchasePressed;
  final Function(AuthorModel author)? onAuthorPressed;
  const TopProductsWidget(
      {super.key,
      required this.topBooks,
      this.width,
      this.padding,
      this.isHorizontal,
      this.onSeeAllPressed,
      this.onPressed,
      this.onWishlistPressed,
      this.onCartPressed,
      this.onPurchasePressed,
      this.onAuthorPressed});

  @override
  State<TopProductsWidget> createState() => _TopProductsWidgetState();
}

class _TopProductsWidgetState extends State<TopProductsWidget> {
  late ResponsiveSizeAdapter r;
  final ScrollController _scrollController = ScrollController();

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
              if (widget.isHorizontal == true) {
                return _buildHorizontalTopProducts(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!);
              } else {
                return _buildVerticalTopProducts(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!);
              }
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildVerticalTopProducts(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      width: r.size(240),
      maxHeight: r.size(1041),
      gap: r.size(6),
      borderColor: theme.primary,
      borderWidth: r.size(2),
      isRtl: language.isRtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(bottom: r.size(12)),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: r.size(8)),
          color: theme.primary,
          width: double.infinity,
          alignment: Alignment.center,
          child: CustomText(
            fontSize: r.size(14),
            color: AppColors.colors.whiteSolid,
            fontWeight: FontWeight.bold,
            letterSpacing: r.size(1),
            text: ts.translate('screens.explore.topProducts.title'),
          ),
        ),
        Expanded(
          child: RawScrollbar(
            thumbColor: theme.primary.withOpacity(0.4),
            radius: Radius.circular(r.size(10)),
            thickness: r.size(5),
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: CustomField(
                gap: r.size(18),
                padding: widget.padding ??
                    EdgeInsets.symmetric(
                        vertical: r.size(16), horizontal: r.size(12)),
                mainAxisAlignment: MainAxisAlignment.center,
                isRtl: language.isRtl,
                children: [
                  ...widget.topBooks.asMap().entries.map((entry) {
                    int index = entry.key;
                    ProductEntity book = entry.value;

                    return CustomField(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      gap: r.size(18),
                      children: [
                        CustomField(
                          arrangement: FieldArrangement.row,
                          isRtl: language.isRtl,
                          gap: r.size(8),
                          children: [
                            CustomText(
                              text: '${index + 1}',
                              lineHeight: 1,
                              fontSize: r.size(16),
                              color: AppColors.colors.redRouge,
                              fontWeight: FontWeight.bold,
                            ),
                            Expanded(
                              child: ProductWidget(
                                productId: book.id,
                                networkImageUrl: book.imageUrl,
                                author: book.author,
                                title: book.title,
                                titleMaxWidth: r.size(80),
                                price: book.price,
                                pricePromo: book.pricePromo,
                                pricePromoPercentage:
                                    book.primaryCategoryPromoPercent,
                                isBestSellers: book.isBestSeller,
                                isNewArrival: book.isNewArrival,
                                isHorizontal: true,
                                offerBadgeSize: r.size(30),
                                offerBadgeFontSize: r.size(4),
                                isActionsCardVisible: false,
                                coverWidth: r.size(100),
                                authorFontSize: r.size(9),
                                titleFontSize: r.size(9),
                                priceFontSize: r.size(10),
                                onPressed: widget.onPressed,
                                onWishlistPressed: widget.onWishlistPressed,
                                onCartPressed: widget.onCartPressed,
                                onPurchasePressed: widget.onPurchasePressed,
                                onAuthorPressed: widget.onAuthorPressed,
                              ),
                            ),
                          ],
                        ),
                        if (index != (widget.topBooks.length - 1))
                          CustomDashedLine(
                            color: theme.accent.withOpacity(0.4),
                            thickness: r.size(1),
                            dashGap: r.size(4),
                            dashLength: r.size(1),
                            size: r.size(200),
                          )
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
        CustomField(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              text: ts.translate('widgets.productSlider.seeAll'),
              textColor: theme.bodyText,
              fontSize: r.size(16),
              fontWeight: FontWeight.bold,
              onPressed: (position, size) {
                if (widget.onSeeAllPressed != null) {
                  widget.onSeeAllPressed!();
                }
              },
            ),
            CustomShrinkingLine(
              color: theme.accent.withOpacity(0.8),
              thickness: r.size(1),
              size: r.size(50),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHorizontalTopProducts(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      gap: r.size(6),
      borderColor: theme.primary,
      borderWidth: r.size(2),
      isRtl: language.isRtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(bottom: r.size(12)),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: r.size(8)),
          color: theme.primary,
          width: double.infinity,
          alignment: Alignment.center,
          child: CustomText(
            fontSize: r.size(14),
            color: AppColors.colors.whiteSolid,
            fontWeight: FontWeight.bold,
            letterSpacing: r.size(1),
            text: ts.translate('screens.explore.topProducts.title'),
          ),
        ),
        RawScrollbar(
          thumbColor: theme.primary.withOpacity(0.6),
          radius: Radius.circular(r.size(10)),
          thickness: r.size(5),
          thumbVisibility: true,
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: CustomField(
                gap: r.size(18),
                padding: widget.padding ??
                    EdgeInsets.symmetric(
                        vertical: r.size(12),
                        horizontal: r.size(16)), // Adjust padding
                mainAxisAlignment: MainAxisAlignment.center,
                isRtl: language.isRtl,
                arrangement: FieldArrangement.row,
                children: [
                  ...widget.topBooks.asMap().entries.map((entry) {
                    int index = entry.key;
                    ProductEntity book = entry.value;

                    return CustomField(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      arrangement: FieldArrangement.row,
                      gap: r.size(18),
                      children: [
                        CustomField(
                          arrangement: FieldArrangement.row,
                          isRtl: language.isRtl,
                          width: r.size(140),
                          height: r.size(220),
                          gap: r.size(8),
                          children: [
                            CustomText(
                              text: '${index + 1}',
                              lineHeight: 1,
                              fontSize: r.size(16),
                              color: AppColors.colors.redRouge,
                              fontWeight: FontWeight.bold,
                            ),
                            Expanded(
                              child: ProductWidget(
                                productId: book.id,
                                networkImageUrl: book.imageUrl,
                                author: book.author,
                                title: book.title,
                                price: book.price,
                                pricePromo: book.pricePromo,
                                pricePromoPercentage:
                                    book.primaryCategoryPromoPercent,
                                isBestSellers: book.isBestSeller,
                                isNewArrival: book.isNewArrival,
                                isActionsCardVisible: false,
                                authorFontSize: r.size(10),
                                titleFontSize: r.size(10),
                                priceFontSize: r.size(12),
                                onPressed: widget.onPressed,
                                onWishlistPressed: widget.onWishlistPressed,
                                onCartPressed: widget.onCartPressed,
                                onPurchasePressed: widget.onPurchasePressed,
                                onAuthorPressed: widget.onAuthorPressed,
                              ),
                            ),
                          ],
                        ),
                        if (index != (widget.topBooks.length - 1))
                          CustomDashedLine(
                            color: theme.accent.withOpacity(0.4),
                            thickness: r.size(1),
                            dashGap: r.size(4),
                            dashLength: r.size(1),
                            size: r.size(240),
                            isVertical: true,
                          )
                      ],
                    );
                  })
                ]),
          ),
        ),
        CustomField(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              text: ts.translate('widgets.productSlider.seeAll'),
              textColor: theme.bodyText,
              fontSize: r.size(16),
              fontWeight: FontWeight.bold,
              onPressed: (position, size) {
                if (widget.onSeeAllPressed != null) {
                  widget.onSeeAllPressed!();
                }
              },
            ),
            CustomShrinkingLine(
              color: theme.accent.withOpacity(0.8),
              thickness: r.size(1),
              size: r.size(50),
            ),
          ],
        ),
      ],
    );
  }
}
