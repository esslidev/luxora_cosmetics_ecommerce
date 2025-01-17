import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:librairie_alfia/core/resources/lite_notification_bar_model.dart';
import 'package:librairie_alfia/core/util/remote_events_util.dart';
import 'package:librairie_alfia/features/domain/entities/review.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_dashed_line.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_line.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_text.dart';
import 'package:librairie_alfia/features/presentation/widgets/features/bread_crumbs.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/product.dart';
import '../../../../../core/enums/notification_type.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/bread_crumb_model.dart';
import '../../../../../core/resources/currency_model.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../../data/models/author.dart';
import '../../../../domain/entities/cart.dart';
import '../../../../domain/entities/category.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/wishlist.dart';
import '../../../bloc/app/currency/currency_bloc.dart';
import '../../../bloc/app/currency/currency_state.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';

import '../../../bloc/remote/cart/cart_bloc.dart';
import '../../../bloc/remote/cart/cart_state.dart';
import '../../../bloc/remote/category/category_bloc.dart';
import '../../../bloc/remote/category/category_state.dart';
import '../../../bloc/remote/product/product_bloc.dart';
import '../../../bloc/remote/product/product_state.dart';
import '../../../bloc/remote/wishlist/wishlist_bloc.dart';
import '../../../bloc/remote/wishlist/wishlist_state.dart';
import '../../../overlays/loading/loading.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_display.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/features/product_slider.dart';
import '../../../widgets/features/rating_stars.dart';

class BookOverviewScreen extends StatefulWidget {
  final String? productId;
  const BookOverviewScreen({super.key, this.productId});

  @override
  State<BookOverviewScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookOverviewScreen> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  late LoadingOverlay _loadingOverlay;

  ProductEntity _productResponse = const ProductEntity();
  List<CategoryEntity> _categoryPathResponse = [];
  List<ProductEntity> _productsWithSimilarCategory = [];
  //List<ProductEntity> _productsSuggestedView = [];

  CartEntity? _cartResponse;
  WishlistEntity? _wishlistResponse;

  ProductEntity? _selectedProduct;

  int _bookFormatIndex = 0;
  int _sectionIndex = 0;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = locator<GlobalContexts>().homeContext;
      AppUtil.jumpToTop(context);
      AppEventsUtil.routeEvents
          .changePath(context, AppPaths.routes.bookOverviewScreen);
      _loadingOverlay = LoadingOverlay(
        context: homeContext!,
      );

      if (int.tryParse(widget.productId ?? '') != null) {
        RemoteEventsUtil.productEvents
            .getProductById(context, int.parse(widget.productId!));
        RemoteEventsUtil.wishlistEvents.getWishlist(context);
        RemoteEventsUtil.cartEvents.getCart(context);
        /*if (widget.categoryPath != null) {
          RemoteEventsUtil.categoryEvents
              .getCategories(context, categoryNumbers: widget.categoryPath!);
        }*/
      } else {
        Beamer.of(context).beamToNamed(AppPaths.routes.exploreScreen);
      }
    });
  }

  void _beamToBoutique(int categoryNumber) {
    Beamer.of(context).beamToNamed(
        '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=$categoryNumber');
  }

  //------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
            if (translationState.translationService != null &&
                translationState.language != null) {
              return BlocBuilder<AppCurrencyBloc, AppCurrencyState>(
                  builder: (context, currencyState) {
                return MultiBlocListener(
                  listeners: [
                    BlocListener<RemoteProductBloc, RemoteProductState>(
                      listener: (context, state) {
                        if (state is RemoteProductLoading ||
                            state is RemoteProductsLoading) {
                          if (state.productLoading == true ||
                              state.productsWithSimilarCategoryLoading ==
                                  true) {
                            _loadingOverlay.show(
                                translationService:
                                    translationState.translationService!,
                                r: r,
                                theme: themeState.theme);
                          }
                        }
                        if (state is RemoteProductLoaded) {
                          if (state.product != null) {
                            setState(() {
                              _productResponse = state.product!;
                              _selectedProduct = _productResponse;
                              if (state.product?.primaryCategoryNumber !=
                                  null) {
                                RemoteEventsUtil.productEvents
                                    .getWithSimilarCategory(context,
                                        categoryNumber: state
                                            .product!.primaryCategoryNumber!);
                              }
                            });
                          }
                          _loadingOverlay.dismiss();
                        }
                        if (state is RemoteProductsLoaded) {
                          if (state.productsWithSimilarCategory != null) {
                            setState(() {
                              _productsWithSimilarCategory =
                                  state.productsWithSimilarCategory!;
                            });
                          }
                          _loadingOverlay.dismiss();
                        }
                        if (state is RemoteProductError) {
                          _loadingOverlay.dismiss();
                        }
                      },
                    ),
                    BlocListener<RemoteCategoryBloc, RemoteCategoryState>(
                      listener: (context, state) {
                        if (state is RemoteCategoriesLoaded) {
                          if (state.categories != null) {
                            setState(() {
                              _categoryPathResponse = state.categories!;
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
                    BlocListener<RemoteWishlistBloc, RemoteWishlistState>(
                      listener: (context, state) {
                        if (state is RemoteWishlistSynced) {
                          setState(() {
                            _wishlistResponse = state.wishlist;
                          });
                        }

                        if (state is RemoteWishlistLoaded) {
                          setState(() {
                            _wishlistResponse = state.wishlist;
                          });
                        }

                        if (state is RemoteWishlistItemAdded) {
                          setState(() {
                            final existingIndex =
                                _wishlistResponse?.items?.indexWhere(
                              (element) =>
                                  element.productId == state.item!.productId,
                            );

                            if (existingIndex != null && existingIndex >= 0) {
                              _wishlistResponse?.items?[existingIndex] =
                                  state.item!;
                            } else {
                              _wishlistResponse?.items?.add(state.item!);
                            }
                          });
                        }

                        if (state is RemoteWishlistItemUpdated) {
                          setState(() {
                            final index = _wishlistResponse?.items?.indexWhere(
                              (element) => element.id == state.item!.id,
                            );
                            if (index != null && index >= 0) {
                              _wishlistResponse?.items?[index] = state.item!;
                            }
                          });
                        }

                        if (state is RemoteWishlistItemRemoved) {
                          setState(() {
                            _wishlistResponse?.items?.removeWhere(
                              (element) => element.id == state.item?.id,
                            );
                          });
                        }

                        if (state is RemoteWishlistCleared) {
                          setState(() {
                            _wishlistResponse?.items?.clear();
                          });
                        }

                        if (state is RemoteWishlistError) {
                          _loadingOverlay.dismiss();
                          setState(() {
                            _wishlistResponse = null;
                          });
                        }
                      },
                    ),
                    BlocListener<RemoteCartBloc, RemoteCartState>(
                      listener: (context, state) {
                        if (state is RemoteCartSynced) {
                          setState(() {
                            _cartResponse = state.cart;
                          });
                        }

                        if (state is RemoteCartLoaded) {
                          if (state.cart != null) {
                            setState(() {
                              _cartResponse = state.cart;
                            });
                          }
                        }

                        if (state is RemoteCartItemAdded) {
                          setState(() {
                            final existingIndex =
                                _cartResponse?.items?.indexWhere(
                              (element) =>
                                  element.productId == state.item!.productId,
                            );

                            if (existingIndex != null && existingIndex >= 0) {
                              _cartResponse?.items?[existingIndex] =
                                  state.item!;
                            } else {
                              _cartResponse?.items?.add(state.item!);
                            }
                          });
                        }

                        if (state is RemoteCartItemUpdated) {
                          setState(() {
                            final index = _cartResponse?.items?.indexWhere(
                              (element) => element.id == state.item!.id,
                            );
                            if (index != null && index >= 0) {
                              _cartResponse?.items?[index] = state.item!;
                            }
                          });
                        }

                        if (state is RemoteCartItemRemoved) {
                          setState(() {
                            _cartResponse?.items?.removeWhere(
                              (element) => element.id == state.item?.id,
                            );
                          });
                        }

                        if (state is RemoteCartCleared) {
                          setState(() {
                            _cartResponse?.items?.clear();
                          });
                        }
                        if (state is RemoteCartError) {
                          setState(() {
                            _cartResponse = null;
                          });
                        }
                      },
                    ),
                  ],
                  child: _selectedProduct != null
                      ? ResponsiveScreenAdapter(
                          fallbackScreen: _buildLargeDesktop(
                            context,
                            themeState.theme,
                            translationState.translationService!,
                            translationState.language!,
                            currencyState.currency,
                          ),
                          screenDesktop: _buildDesktop(
                            context,
                            themeState.theme,
                            translationState.translationService!,
                            translationState.language!,
                            currencyState.currency,
                          ),
                          screenTablet: _buildTablet(
                            context,
                            themeState.theme,
                            translationState.translationService!,
                            translationState.language!,
                            currencyState.currency,
                          ),
                          screenMobile: _buildMobile(
                            context,
                            themeState.theme,
                            translationState.translationService!,
                            translationState.language!,
                            currencyState.currency,
                          ),
                        )
                      : const SizedBox(),
                );
              });
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  //------------------------------------------------------------------------------------------------//
  Widget _buildProductOfferBadge(
      {required TranslationService ts,
      required bool isRtl,
      double? size,
      double? fontSize,
      double discount = 0,
      bool? isNewArrival,
      bool? isBestSellers}) {
    return (discount != 0 || isNewArrival == true || isBestSellers == true)
        ? IgnorePointer(
            ignoring: true,
            child: CustomField(
              mainAxisSize: MainAxisSize.min,
              margin:
                  r.only(top: 4, left: !isRtl ? 4 : 0, right: isRtl ? 4 : 0),
              isRtl: isRtl,
              width: size ?? r.size(54),
              height: size ?? r.size(54),
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomDisplay(
                      assetPath: AppPaths.vectors.badge,
                      width: size ?? r.size(54),
                      height: size ?? r.size(54),
                      isSvg: true,
                      svgColor: discount != 0
                          ? AppColors.colors.redRouge
                          : isBestSellers == true
                              ? AppColors.colors.yellowHoneyGlow
                              : AppColors.colors.greenSwagger,
                    ),
                    CustomText(
                      text: discount != 0
                          ? AppUtil.getDiscountBadge(ts, discount)
                          : isBestSellers == true
                              ? ts.translate(
                                  'widgets.product.offerBadge.bestSellers')
                              : isNewArrival == true
                                  ? ts.translate(
                                      'widgets.product.offerBadge.newArrivals')
                                  : '',
                      fontSize: fontSize ?? r.size(7),
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w900,
                      color: AppColors.colors.whiteSolid,
                      padding: r.symmetric(horizontal: 4),
                    )
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _buildCover({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required ProductEntity book,
    double? width,
  }) {
    return Stack(
      children: [
        CustomDisplay(
          assetPath: book.imageUrl!,
          isNetwork: true,
          width: width ?? r.size(180),
          cursor: SystemMouseCursors.basic,
          loadingWidget: Container(
            width: r.size(200),
            color: theme.secondaryBackgroundColor,
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .shimmer(
                  delay: 200.ms,
                  duration: 300.ms,
                  curve: Curves.easeInOut,
                  color: theme.accent.withOpacity(0.2)),
          errorWidget: _buildNoCover(theme: theme, ts: ts),
        ),
        Align(
            alignment: !isRtl ? Alignment.topLeft : Alignment.topRight,
            child: _buildProductOfferBadge(
                ts: ts,
                size: r.size(70),
                fontSize: r.size(8),
                isRtl: isRtl,
                isBestSellers: book.isBestSeller,
                isNewArrival: book.isNewArrival,
                discount: book.price != null
                    ? (book.pricePromo != null
                        ? AppUtil.calculateDiscount(
                            book.price!, book.pricePromo!)
                        : (book.primaryCategoryPromoPercent != null
                            ? AppUtil.calculateDiscount(
                                book.price!,
                                AppUtil.calculatePricePromo(book.price!,
                                    book.primaryCategoryPromoPercent!),
                              )
                            : 0))
                    : 0)),
      ],
    );
  }

  Widget _buildNoCover(
      {required BaseTheme theme, required TranslationService ts}) {
    return CustomField(
      width: r.size(160),
      padding: r.symmetric(horizontal: 14, vertical: 40),
      backgroundColor: theme.secondaryBackgroundColor,
      gap: r.size(14),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IgnorePointer(
          ignoring: true,
          child: CustomDisplay(
            width: r.size(110),
            assetPath: AppPaths.vectors.noCover,
            svgColor: theme.primary.withOpacity(0.6),
            isSvg: true,
          ),
        ),
        CustomField(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: ts.translate('widgets.product.noCover'),
              fontSize: r.size(14),
              color: theme.primary.withOpacity(0.6),
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.center,
            ),
            CustomText(
              text: ts.translate('*400 x 600px'),
              fontSize: r.size(10),
              color: theme.primary.withOpacity(0.6),
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      String? title,
      ProductFormatType? format}) {
    return CustomField(
        crossAxisAlignment: CrossAxisAlignment.end,
        arrangement: FieldArrangement.row,
        mainAxisSize: MainAxisSize.min,
        isRtl: isRtl,
        gap: r.size(4),
        children: [
          Flexible(
            child: CustomText(
              text: title ?? ts.translate('screens.bookOverview.noTitle'),
              fontSize: r.size(16),
              fontWeight: FontWeight.bold,
              borderRadius: r.size(2),
              lineHeight: 0.8,
              backgroundColor: AppColors.colors.yellowHoneyGlow,
              padding: r.symmetric(vertical: 4, horizontal: 6),
            ),
          ),
          if (format != null)
            CustomText(
              text:
                  ' • ${AppUtil.productFormatToString(ts: ts, format: format)}',
              fontSize: r.size(13),
              fontWeight: FontWeight.bold,
              lineHeight: 1,
              color: theme.accent.withOpacity(0.6),
            )
        ]);
  }

  Widget _buildAuthorName(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      AuthorModel? author}) {
    return CustomField(
        crossAxisAlignment: CrossAxisAlignment.end,
        arrangement: FieldArrangement.row,
        mainAxisSize: MainAxisSize.min,
        isRtl: isRtl,
        gap: r.size(2),
        children: [
          CustomButton(
            text: author != null
                ? '${author.firstName} ${author.lastName}'
                : ts.translate('screens.bookOverview.noAuthor'),
            fontSize: r.size(11.5),
            fontWeight: FontWeight.bold,
            textColor: theme.secondary,
            onHoverStyle: CustomButtonStyle(
              textColor: theme.primary,
            ),
            lineHeight: 0.8,
            onPressed: (position, size) {
              if (author != null) {
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
              }
            },
          ),
          CustomText(
            text: '(${ts.translate('global.bookTerms.author')})',
            fontSize: r.size(9),
            fontWeight: FontWeight.normal,
            color: theme.accent.withOpacity(0.6),
            lineHeight: 1,
          ),
        ]);
  }

  Widget _buildRating(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      double? rating,
      int? ratingCount}) {
    return CustomField(
      gap: r.size(2),
      arrangement: FieldArrangement.row,
      isRtl: isRtl,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RatingStars(
          theme: theme,
          rating: rating ?? 0,
          starSize: r.size(9),
          isRtl: isRtl,
        ),
        CustomText(
          text:
              '(${ratingCount ?? 0} ${ts.translate('screens.bookOverview.reviews')})',
          fontSize: r.size(8),
          fontWeight: FontWeight.normal,
          lineHeight: 1,
          color: theme.accent.withOpacity(0.6),
        )
      ],
    );
  }

  Widget _buildShortDescription(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      double? maxShrinkHeight,
      String? description}) {
    bool showShowMoreButton = true;

    return CustomField(
      gap: r.size(4),
      isRtl: isRtl,
      children: [
        CustomText(
          text:
              description ?? ts.translate('screens.bookOverview.noDescription'),
          selectable: true,
          fontSize: r.size(11),
          textAlign: TextAlign.justify,
          maxHeight: _isDescriptionExpanded != true
              ? maxShrinkHeight ?? r.size(90)
              : null,
        ),
        if (showShowMoreButton == true)
          CustomButton(
            text: _isDescriptionExpanded != true
                ? ts.translate('global.showMore')
                : ts.translate('global.showLess'),
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            textColor: theme.secondary,
            onPressed: (position, size) {
              if (_isDescriptionExpanded != true) {
                setState(() {
                  _isDescriptionExpanded = true;
                });
              } else {
                setState(() {
                  _isDescriptionExpanded = false;
                });
              }
            },
          )
      ],
    );
  }

  Widget _buildPriceText({
    required BaseTheme theme,
    required TranslationService ts,
    required CurrencyModel currency,
    required bool isRtl,
    double? price,
    double? pricePromo,
    double? pricePromoPercentage,
  }) {
    return CustomField(
      mainAxisSize: MainAxisSize.min,
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(4),
      children: [
        CustomText(
          text:
              '${AppUtil.formatToTwoDecimalPlaces(pricePromo ?? AppUtil.calculatePricePromo(price ?? 0.0, pricePromoPercentage ?? 0.0)).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
          fontSize: r.size(15),
          letterSpacing: r.size(1.5),
          fontWeight: FontWeight.w900,
          color: AppColors.colors.whiteOut,
          backgroundColor: theme.primary,
          borderRadius: r.size(1.5),
          padding: r.symmetric(horizontal: 10),
        ),
        if (pricePromo != null || pricePromoPercentage != null)
          CustomText(
            text:
                '${AppUtil.formatToTwoDecimalPlaces(price ?? 0.0).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
            textDecoration: TextDecoration.lineThrough,
            textDecorationStyle: TextDecorationStyle.solid,
            fontSize: r.size(9),
            color: theme.accent.withOpacity(0.6),
            textDecorationColor: theme.accent,
            textDecorationThickness: r.size(0.8),
            fontWeight: FontWeight.bold,
          ),
      ],
    );
  }

  Widget _buildBookFormatsButton({
    required BaseTheme theme,
    required TranslationService ts,
    required CurrencyModel currency,
    required bool isRtl,
    required ProductFormatType format,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
    double? price,
    double? pricePromo,
    double? pricePromoPercentage,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: CustomField(
          backgroundColor: theme.secondaryBackgroundColor,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          borderColor:
              isActive ? theme.secondary : theme.accent.withOpacity(0.4),
          borderWidth: isActive ? r.size(1) : r.size(0.6),
          borderRadius: r.size(2),
          padding: r.symmetric(vertical: 4, horizontal: 8),
          gap: r.size(4),
          isRtl: isRtl,
          arrangement: FieldArrangement.row,
          children: [
            CustomText(
              text: '${AppUtil.productFormatToString(ts: ts, format: format)}:',
              fontSize: r.size(10),
              fontWeight: FontWeight.bold,
            ),
            CustomField(
              gap: r.size(4),
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              isRtl: isRtl,
              arrangement: FieldArrangement.row,
              children: [
                CustomText(
                  text:
                      '${AppUtil.formatToTwoDecimalPlaces(pricePromo ?? AppUtil.calculatePricePromo(price ?? 0.0, pricePromoPercentage ?? 0.0)).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
                  fontSize: r.size(9),
                  fontWeight: FontWeight.bold,
                  color: AppColors.colors.redRouge,
                  lineHeight: 1,
                ),
                if (pricePromo != null || pricePromoPercentage != null)
                  CustomText(
                    text:
                        '${AppUtil.formatToTwoDecimalPlaces(price ?? 0.0).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
                    textDecoration: TextDecoration.lineThrough,
                    textDecorationStyle: TextDecorationStyle.solid,
                    fontSize: r.size(8),
                    color: theme.accent.withOpacity(0.6),
                    textDecorationColor: theme.accent,
                    textDecorationThickness: r.size(0.8),
                    fontWeight: FontWeight.bold,
                    lineHeight: 1,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookFormatsSelector({
    required BaseTheme theme,
    required TranslationService ts,
    required CurrencyModel currency,
    required bool isRtl,
    required ProductEntity mainBook,
    required List<ProductEntity> formats,
    double? pricePromoPercentage,
  }) {
    List<ProductEntity> allFormats = [mainBook, ...formats];
    return CustomField(
      gap: r.size(2),
      isRtl: isRtl,
      children: [
        CustomText(
          text:
              ts.translate('${ts.translate('screens.bookOverview.formats')}:'),
          fontSize: r.size(9),
          fontWeight: FontWeight.bold,
        ),
        CustomField(
          isRtl: isRtl,
          isWrap: true,
          wrapHorizontalSpacing: r.size(4),
          wrapVerticalSpacing: r.size(4),
          arrangement: FieldArrangement.row,
          children: [
            // Map over all variations to create selectable buttons
            ...allFormats.asMap().entries.map((entry) {
              int index = entry.key;
              ProductEntity format = entry.value;

              return _buildBookFormatsButton(
                theme: theme,
                ts: ts,
                currency: currency,
                format: format.formatType ?? ProductFormatType.none,
                index: index,
                isActive: _bookFormatIndex == index,
                onTap: () {
                  setState(() {
                    _bookFormatIndex = index;
                    _selectedProduct = format;
                  });
                },
                price: format.price,
                pricePromo: format.pricePromo,
                pricePromoPercentage: pricePromoPercentage,
                isRtl: isRtl,
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildStockAvailability({
    required BaseTheme theme,
    required TranslationService ts,
    int? stockCount = 0,
    bool isFlexible = true,
  }) {
    return CustomField(
      gap: r.size(4),
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        CustomDisplay(
          assetPath: stockCount! <= 0
              ? AppPaths.vectors.xFilledIcon
              : AppPaths.vectors.checkFilledIcon,
          isSvg: true,
          width: r.size(10),
          height: r.size(10),
          svgColor: stockCount <= 0
              ? AppColors.colors.redRouge
              : stockCount > 0 && stockCount <= 30
                  ? AppColors.colors.yellowHoneyGlow
                  : AppColors.colors.greenSwagger,
        ),
        if (isFlexible)
          Flexible(
            child: CustomText(
              color: stockCount <= 0
                  ? AppColors.colors.redRouge
                  : stockCount > 0 && stockCount <= 30
                      ? AppColors.colors.yellowHoneyGlow
                      : AppColors.colors.greenSwagger,
              text: stockCount <= 0
                  ? ts.translate('screens.bookOverview.stock.outOfStock')
                  : stockCount > 0 && stockCount <= 30
                      ? ts.translate('screens.bookOverview.stock.limited')
                      : ts.translate('screens.bookOverview.stock.available'),
              fontSize: r.size(11),
              fontWeight: FontWeight.bold,
            ),
          )
        else
          CustomText(
            color: stockCount <= 0
                ? AppColors.colors.redRouge
                : stockCount > 0 && stockCount <= 30
                    ? AppColors.colors.yellowHoneyGlow
                    : AppColors.colors.greenSwagger,
            text: stockCount <= 0
                ? ts.translate('screens.bookOverview.stock.outOfStock')
                : stockCount > 0 && stockCount <= 30
                    ? ts.translate('screens.bookOverview.stock.limited')
                    : ts.translate('screens.bookOverview.stock.available'),
            fontSize: r.size(11),
            fontWeight: FontWeight.bold,
          ),
      ],
    );
  }

  Widget _buildDeliveryDate({
    required BaseTheme theme,
    required TranslationService ts,
    int? deliveryTime,
    bool isFlexible = true,
  }) {
    final DateTime today = DateTime.now();

    // Check if deliveryTime is provided
    if (deliveryTime == null) {
      return CustomField(
        gap: r.size(4),
        crossAxisAlignment: CrossAxisAlignment.center,
        arrangement: FieldArrangement.row,
        children: [
          if (isFlexible)
            Flexible(
              child: CustomText(
                text: ts.translate('screens.bookOverview.delivery.unavailable'),
                fontSize: r.size(10),
                fontWeight: FontWeight.normal,
              ),
            )
          else
            CustomText(
              text: ts.translate('screens.bookOverview.delivery.unavailable'),
              fontSize: r.size(10),
              fontWeight: FontWeight.normal,
            ),
        ],
      );
    }

    // Calculate the delivery date range
    final DateTime endDate = today.add(Duration(days: deliveryTime));
    final DateTime startDate = today; // Starts from today

    // Format the dates
    final String startDateStr = DateFormat('dd MMMM').format(startDate);
    final String endDateStr = DateFormat('dd MMMM').format(endDate);

    return CustomText(
      text:
          '${ts.translate('screens.bookOverview.delivery.available1')} $startDateStr ${ts.translate('screens.bookOverview.delivery.available2')} $endDateStr',
      fontSize: r.size(10),
      fontWeight: FontWeight.normal,
      lineHeight: 1,
    );
  }

  Widget _buildDeliveryDateRange({
    required BaseTheme theme,
    required TranslationService ts,
    int? deliveryTime, // delivery time in days
  }) {
    final DateTime today = DateTime.now();

    // Check if deliveryTime is provided
    if (deliveryTime != null) {
      // Calculate the delivery date range
      final DateTime endDate = today.add(Duration(days: deliveryTime));
      final DateTime startDate = today;
      final int deliveryRange = endDate.difference(startDate).inDays;
      return CustomField(
        gap: r.size(2),
        crossAxisAlignment: CrossAxisAlignment.center,
        arrangement: FieldArrangement.row,
        children: [
          CustomText(
            text: '*',
            fontSize: r.size(12),
            fontWeight: FontWeight.bold,
            color: AppColors.colors.redRouge,
            lineHeight: 1,
          ),
          Flexible(
            child: CustomText(
              text:
                  'Cet article disponible en librairie et vous sera envoyé $deliveryRange à ${deliveryRange + 1} jours après la date de votre commande.',
              fontSize: r.size(10),
              fontWeight: FontWeight.bold,
              lineHeight: 1,
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildPurchaseButton({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String svgIconPath,
    String? text,
    Color? backgroundColor,
    Color? onHoverBackgroundColor,
    Color? iconColor,
    Color? onHoverIconColor,
    Color? textColor,
    Color? onHoverTextColor,
    bool isOutOfStock = false,
    required Function() onPressed,
  }) {
    return CustomButton(
      svgIconPath: svgIconPath,
      enabled: !isOutOfStock,
      iconColor: iconColor ?? AppColors.colors.whiteOut,
      useIntrinsicWidth: false,
      height: r.size(22),
      iconWidth: r.size(9),
      text: text,
      fontSize: r.size(10),
      fontWeight: FontWeight.bold,
      textColor: textColor ?? AppColors.colors.whiteOut,
      backgroundColor: backgroundColor ?? AppColors.colors.greenSwagger,
      onHoverStyle: CustomButtonStyle(
        iconColor: onHoverIconColor,
        textColor: onHoverTextColor,
        backgroundColor: onHoverBackgroundColor,
      ),
      onDisabledStyle: CustomButtonStyle(
        textColor: theme.accent.withOpacity(0.3),
        iconColor: theme.accent.withOpacity(0.3),
        backgroundColor: theme.secondaryBackgroundColor,
      ),
      animationDuration: 300.ms,
      borderRadius: BorderRadius.all(Radius.circular(r.size(1.5))),
      padding: r.symmetric(vertical: 4, horizontal: 12),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildPurchaseButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    bool isOutOfStock = true,
  }) {
    return CustomField(
        mainAxisSize: MainAxisSize.min,
        gap: r.size(4),
        width: r.size(150),
        children: [
          _buildPurchaseButton(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            svgIconPath: AppPaths.vectors.bookStoreIcon,
            text: ts.translate('screens.bookOverview.actionButtons.pickUp'),
            isOutOfStock: isOutOfStock,
            backgroundColor: theme.primary,
            onHoverBackgroundColor: theme.secondary,
            onPressed: () {},
          ),
          _buildPurchaseButton(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            svgIconPath: AppPaths.vectors.purchaseFillIcon,
            text: ts.translate('screens.bookOverview.actionButtons.purchase'),
            isOutOfStock: isOutOfStock,
            backgroundColor: AppColors.colors.redRouge,
            onHoverBackgroundColor: AppColors.colors.redRouge.withOpacity(0.8),
            onPressed: () {},
          ),
        ]);
  }

  Widget _buildWishlistCartButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    bool? isOutOfStock = true,
    required ProductEntity book,
  }) {
    return CustomField(
      gap: r.size(4),
      arrangement: FieldArrangement.row,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPurchaseButton(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          svgIconPath: AppPaths.vectors.heartIcon,
          text: ts.translate((_wishlistResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false)
              ? 'Retirer de ma liste'
              : 'Ajouter à ma liste'),
          iconColor: (_wishlistResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false)
              ? AppColors.colors.redRouge
              : theme.accent,
          onHoverIconColor: (_wishlistResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false)
              ? AppColors.colors.redRouge.withOpacity(0.8)
              : theme.accent.withOpacity(0.8),
          textColor: (_wishlistResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false)
              ? AppColors.colors.redRouge
              : theme.accent,
          backgroundColor: theme.thirdBackgroundColor,
          onPressed: () {
            if (_selectedProduct?.id != null) {
              final existingInWishlist = (_wishlistResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false);
              if (existingInWishlist) {
                RemoteEventsUtil.wishlistEvents.removeItemFromWishlist(context,
                    productId: _selectedProduct!.id!, allQuantity: true);
              } else {
                RemoteEventsUtil.wishlistEvents
                    .addItemToWishlist(context, _selectedProduct!.id!);
              }
            }
          },
        ),
        CustomButton(
          svgIconPath: AppPaths.vectors.cartFillIcon,
          iconColor: (_cartResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false)
              ? theme.primary
              : theme.accent,
          width: r.size(22),
          height: r.size(22),
          iconWidth: r.size(9),
          iconHeight: r.size(9),
          backgroundColor: theme.thirdBackgroundColor,
          animationDuration: 300.ms,
          onHoverStyle: CustomButtonStyle(
            iconColor: (_cartResponse?.items?.any(
                      (item) => item.productId == book.id,
                    ) ??
                    false)
                ? theme.primary.withOpacity(0.8)
                : theme.accent.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.all(Radius.circular(r.size(1.5))),
          padding: r.all(4),
          onPressed: (position, size) {
            if (_selectedProduct?.id != null) {
              final existingInCart = (_cartResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false);
              if (existingInCart) {
                RemoteEventsUtil.cartEvents.removeItemFromCart(context,
                    productId: _selectedProduct!.id!, allQuantity: true);
              } else {
                RemoteEventsUtil.cartEvents
                    .addItemToCart(context, productId: _selectedProduct!.id!);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildSectionSelectorButton(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      double? width,
      String? title,
      String? svgIconPath,
      bool? isActive,
      required VoidCallback onPressed}) {
    return CustomButton(
      text: title,
      svgIconPath: svgIconPath,
      iconHeight: r.size(16),
      iconColor:
          isActive == true ? theme.accent : theme.accent.withOpacity(0.7),
      width: svgIconPath != null ? r.size(18) : width ?? r.size(106),
      fontSize: r.size(12),
      textColor:
          isActive == true ? theme.accent : theme.accent.withOpacity(0.7),
      onHoverStyle: CustomButtonStyle(textColor: theme.accent),
      fontWeight: FontWeight.w600,
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildSectionsSelector({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    int? reviewsCount = 0,
    bool? isCompact = false,
  }) {
    return CustomField(
      crossAxisAlignment: CrossAxisAlignment.center,
      isRtl: isRtl,
      children: [
        IntrinsicWidth(
          child: CustomField(gap: r.size(6), isRtl: isRtl, children: [
            CustomField(
              arrangement: FieldArrangement.row,
              isRtl: isRtl,
              gap: r.size(20),
              children: [
                _buildSectionSelectorButton(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    width: r.size(50),
                    svgIconPath: isCompact == true
                        ? AppPaths.vectors.descriptionIcon
                        : null,
                    title: isCompact != true
                        ? ts.translate(
                            'screens.bookOverview.sectionsSelector.aboutBook')
                        : null,
                    isActive: _sectionIndex == 0,
                    onPressed: () {
                      setState(() {
                        _sectionIndex = 0;
                      });
                    }),
                _buildSectionSelectorButton(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    width: r.size(100),
                    svgIconPath:
                        isCompact == true ? AppPaths.vectors.bookIcon : null,
                    title: isCompact != true
                        ? ts.translate(
                            'screens.bookOverview.sectionsSelector.specifications')
                        : null,
                    isActive: _sectionIndex == 1,
                    onPressed: () {
                      setState(() {
                        _sectionIndex = 1;
                      });
                    }),
                _buildSectionSelectorButton(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    width: r.size(140),
                    svgIconPath:
                        isCompact == true ? AppPaths.vectors.usersIcon : null,
                    title: isCompact != true
                        ? ts.translate(
                            'screens.bookOverview.sectionsSelector.bookReviews')
                        : null,
                    isActive: _sectionIndex == 2,
                    onPressed: () {
                      setState(() {
                        _sectionIndex = 2;
                      });
                    }),
              ],
            ),
            AnimatedAlign(
              duration: 600.ms,
              curve: Curves.easeInOut,
              alignment: _sectionIndex == 0
                  ? !isRtl
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight
                  : _sectionIndex == 1
                      ? Alignment.bottomCenter
                      : !isRtl
                          ? Alignment.bottomRight
                          : Alignment.bottomLeft,
              child: CustomLine(
                color: theme.primary,
                thickness: r.size(2),
                size: isCompact != true
                    ? _sectionIndex == 0
                        ? r.size(50)
                        : _sectionIndex == 1
                            ? r.size(100)
                            : r.size(140)
                    : r.size(18),
              ),
            )
          ]),
        ),
      ],
    );
  }

  Widget _buildResume(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      double? maxShrinkHeight,
      String? description}) {
    bool showShowMoreButton = true;

    return CustomField(
      gap: r.size(4),
      isRtl: isRtl,
      borderColor: theme.accent.withOpacity(0.4),
      borderWidth: r.size(0.6),
      borderRadius: r.size(2),
      padding: r.symmetric(vertical: 8, horizontal: 12),
      children: [
        CustomText(
          text:
              description ?? ts.translate('screens.bookOverview.noDescription'),
          selectable: true,
          fontSize: r.size(11),
          textAlign: TextAlign.justify,
          maxHeight: _isDescriptionExpanded != true
              ? maxShrinkHeight ?? r.size(90)
              : null,
        ),
        if (showShowMoreButton == true)
          CustomButton(
            text: _isDescriptionExpanded != true
                ? ts.translate('global.showMore')
                : ts.translate('global.showLess'),
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            textColor: theme.secondary,
            onPressed: (position, size) {
              if (_isDescriptionExpanded != true) {
                setState(() {
                  _isDescriptionExpanded = true;
                });
              } else {
                setState(() {
                  _isDescriptionExpanded = false;
                });
              }
            },
          )
      ],
    );
  }

  Widget _buildCharacteristicsField({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String name,
    required String value,
    String? unit,
  }) {
    return CustomField(
        crossAxisAlignment: CrossAxisAlignment.center,
        arrangement: FieldArrangement.row,
        isRtl: isRtl,
        gap: r.size(8),
        children: [
          CustomText(
            text: name,
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
          ),
          Expanded(
            child: CustomDashedLine(
              thickness: r.size(0.6),
              color: theme.accent.withOpacity(0.4),
            ),
          ),
          CustomText(
            text: '$value${unit != null ? ' $unit' : ''}',
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
          ),
        ]);
  }

  Widget _buildCharacteristics({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required ProductEntity book,
    bool isWrap = false,
  }) {
    return CustomField(
        gap: r.size(12),
        arrangement: FieldArrangement.row,
        isRtl: isRtl,
        isWrap: isWrap,
        borderColor: theme.accent.withOpacity(0.4),
        borderWidth: r.size(0.6),
        borderRadius: r.size(2),
        padding: r.symmetric(vertical: 8, horizontal: 12),
        children: [
          Expanded(
            flex: 50,
            child: CustomField(isRtl: isRtl, children: [
              _buildCharacteristicsField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                name: ts.translate('global.bookTerms.isbn'),
                value: book.isbn ?? 'xxxxxxxxxxx',
              ),
              _buildCharacteristicsField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                name: ts.translate('global.bookTerms.format'),
                value: AppUtil.productFormatToString(
                    ts: ts, format: book.formatType ?? ProductFormatType.none),
              ),
              _buildCharacteristicsField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                name: ts.translate('global.bookTerms.author'),
                value: book.author != null
                    ? '${book.author!.firstName} ${book.author!.lastName}'
                    : ts.translate('screens.bookOverview.noAuthor'),
              ),
              _buildCharacteristicsField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                name: ts.translate('global.bookTerms.editor'),
                value: book.editor ??
                    ts.translate('screens.bookOverview.noEditor'),
              ),
            ]),
          ),
          Expanded(
            flex: 50,
            child: CustomField(isRtl: isRtl, children: [
              _buildCharacteristicsField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                name: ts.translate('global.bookTerms.publicationDate'),
                value: book.publicationDate != null
                    ? AppUtil.formatDateToCustomFormat(
                        DateTime.parse(book.publicationDate!))
                    : 'XX/XX/XXXX',
              ),
              _buildCharacteristicsField(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  name: ts.translate('global.bookTerms.pagesNumber'),
                  value: book.pagesNumber != null
                      ? book.pagesNumber.toString()
                      : '0',
                  unit: ts.translate('global.units.pages')),
              _buildCharacteristicsField(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  name: ts.translate('global.bookTerms.weight'),
                  value: book.weight != null ? book.weight.toString() : '0',
                  unit: ts.translate('global.units.kg')),
              _buildCharacteristicsField(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                name: ts.translate('global.bookTerms.dimensions'),
                value:
                    '${int.parse(book.width ?? '0')} ${ts.translate('global.units.cm')} • ${int.parse(book.height ?? '0')} ${ts.translate('global.units.cm')} • ${int.parse(book.thickness ?? '')} ${ts.translate('global.units.cm')}',
              ),
            ]),
          )
        ]);
  }

  Widget _buildReviews({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<ReviewEntity> reviews,
  }) {
    return CustomField(
        borderColor: theme.accent.withOpacity(0.4),
        borderWidth: r.size(0.6),
        borderRadius: r.size(2),
        padding: r.symmetric(vertical: 8, horizontal: 12),
        arrangement: FieldArrangement.row,
        children: []);
  }

  ProductSliderWidget _buildProductSlider({
    required String title,
    required List<ProductEntity> books,
    required int productCount,
    required bool hideController,
    required bool isRtl,
    Function()? onSeeAllPressed,
    Function(int productId, String productName)? onPressed,
    Function(int productId)? onWishlistPressed,
    Function(int productId)? onCartPressed,
    Function(int productId)? onPurchasePressed,
    Function(AuthorModel author)? onAuthorPressed,
  }) {
    return ProductSliderWidget(
      books: books,
      productCount: productCount,
      height: r.size(260),
      hideController: hideController,
      reverse: isRtl,
      authorFontSize: r.size(10),
      titleFontSize: r.size(10),
      priceFontSize: r.size(12),
      title: title,
      onSeeAllPressed: onSeeAllPressed,
      onPressed: onPressed,
      onPurchasePressed: onPurchasePressed,
      onAuthorPressed: onAuthorPressed,
    );
  }

  //------------------------------------------------------------------------------------------------//

  Widget _buildLargeDesktop(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
  ) {
    return CustomField(
      isRtl: language.isRtl,
      padding: r.symmetric(horizontal: 140, vertical: 12),
      gap: r.size(16),
      children: [
        BreadCrumbs(
          theme: theme,
          isRtl: language.isRtl,
        ),
        CustomField(
            isRtl: language.isRtl,
            arrangement: FieldArrangement.row,
            crossAxisAlignment: CrossAxisAlignment.start,
            gap: r.size(36),
            children: [
              _buildCover(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
                book: _selectedProduct!,
              ),
              Expanded(
                  child: CustomField(
                      padding: r.symmetric(vertical: 10),
                      gap: r.size(10),
                      isRtl: language.isRtl,
                      children: [
                    CustomField(
                        gap: r.size(8),
                        isRtl: language.isRtl,
                        children: [
                          _buildTitle(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            title: _selectedProduct!.title,
                            format: _selectedProduct!.formatType,
                          ),
                          _buildAuthorName(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            author: _selectedProduct!.author,
                          ),
                          /*_buildRating(
                              theme: theme,
                              ts: ts,
                              isRtl: language.isRtl,
                              rating: _productResponse.ratingAverage,
                              ratingCount: _productResponse.ratingCount)*/
                        ]),
                    _buildShortDescription(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                    ),
                    CustomField(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        arrangement: FieldArrangement.row,
                        children: [
                          _buildPriceText(
                            theme: theme,
                            ts: ts,
                            currency: currency,
                            isRtl: language.isRtl,
                            price: _selectedProduct!.price,
                            pricePromo: _selectedProduct!.pricePromo,
                            pricePromoPercentage:
                                _selectedProduct!.primaryCategoryPromoPercent,
                          ),
                          _buildWishlistCartButtons(
                              theme: theme,
                              ts: ts,
                              isRtl: language.isRtl,
                              book: _selectedProduct!,
                              isOutOfStock:
                                  _selectedProduct!.stockCount == null ||
                                      _selectedProduct!.stockCount! <= 0)
                        ]),
                    if (_productResponse.formats != null)
                      _buildBookFormatsSelector(
                        theme: theme,
                        ts: ts,
                        currency: currency,
                        isRtl: language.isRtl,
                        mainBook: _productResponse,
                        formats: _productResponse.formats!,
                        pricePromoPercentage:
                            _selectedProduct!.primaryCategoryPromoPercent,
                      ),
                    CustomField(
                        gap: r.size(10),
                        isRtl: language.isRtl,
                        children: [
                          CustomField(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            arrangement: FieldArrangement.row,
                            children: [
                              CustomField(gap: r.size(2), children: [
                                _buildStockAvailability(
                                    theme: theme,
                                    ts: ts,
                                    stockCount: _selectedProduct!.stockCount,
                                    isFlexible: false),
                                _buildDeliveryDate(
                                    theme: theme,
                                    ts: ts,
                                    deliveryTime:
                                        _selectedProduct!.deliveryTime,
                                    isFlexible: false),
                              ]),
                              _buildPurchaseButtons(
                                  theme: theme,
                                  ts: ts,
                                  isRtl: language.isRtl,
                                  isOutOfStock:
                                      _selectedProduct!.stockCount == null ||
                                          _selectedProduct!.stockCount! <= 0),
                            ],
                          ),
                          _buildDeliveryDateRange(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime)
                        ]),
                  ])),
            ]),
        CustomField(
            gap: r.size(8),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionsSelector(
                  theme: theme,
                  ts: ts,
                  isRtl: language.isRtl,
                  reviewsCount: _productResponse.ratingCount),
              CustomField(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  width: double.infinity,
                  isRtl: language.isRtl,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _sectionIndex == 0
                          ? _buildResume(
                              theme: theme,
                              ts: ts,
                              isRtl: language.isRtl,
                              description: _selectedProduct!.description,
                            )
                          : _sectionIndex == 1
                              ? _buildCharacteristics(
                                  theme: theme,
                                  ts: ts,
                                  isRtl: language.isRtl,
                                  book: _selectedProduct!)
                              : _buildReviews(
                                  theme: theme,
                                  ts: ts,
                                  isRtl: language.isRtl,
                                  reviews: []),
                    )
                  ]),
            ]),
        _buildProductSlider(
          title: ts.translate('screens.bookOverview.sliderTitles.sameCategory'),
          books: _productsWithSimilarCategory,
          productCount: 4,
          hideController: false,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //     _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
          },
        ),
        _buildProductSlider(
          title:
              ts.translate('screens.bookOverview.sliderTitles.suggestedBooks'),
          books: _productsWithSimilarCategory,
          productCount: 4,
          hideController: false,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?categoryPath=${_productResponse.primaryCategoryNumber}');
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        )
      ],
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
  ) {
    return CustomField(
      isRtl: language.isRtl,
      padding: r.symmetric(horizontal: 40, vertical: 12),
      gap: r.size(16),
      children: [
        BreadCrumbs(
          theme: theme,
          isRtl: language.isRtl,
        ),
        CustomField(
            isRtl: language.isRtl,
            arrangement: FieldArrangement.row,
            crossAxisAlignment: CrossAxisAlignment.start,
            gap: r.size(36),
            children: [
              _buildCover(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
                book: _selectedProduct!,
              ),
              Expanded(
                  child: CustomField(
                      padding: r.symmetric(vertical: 10),
                      gap: r.size(10),
                      isRtl: language.isRtl,
                      children: [
                    CustomField(
                        gap: r.size(8),
                        isRtl: language.isRtl,
                        children: [
                          _buildTitle(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            title: _selectedProduct!.title,
                            format: _selectedProduct!.formatType,
                          ),
                          _buildAuthorName(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            author: _selectedProduct!.author,
                          ),
                          /*_buildRating(
                              theme: theme,
                              ts: ts,
                              isRtl: language.isRtl,
                              rating: _productResponse.ratingAverage,
                              ratingCount: _productResponse.ratingCount)*/
                        ]),
                    _buildShortDescription(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                    ),
                    CustomField(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      arrangement: FieldArrangement.row,
                      children: [
                        _buildPriceText(
                          theme: theme,
                          ts: ts,
                          currency: currency,
                          isRtl: language.isRtl,
                          price: _selectedProduct!.price,
                          pricePromo: _selectedProduct!.pricePromo,
                          pricePromoPercentage:
                              _selectedProduct!.primaryCategoryPromoPercent,
                        ),
                        _buildWishlistCartButtons(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            book: _selectedProduct!,
                            isOutOfStock:
                                _selectedProduct!.stockCount == null ||
                                    _selectedProduct!.stockCount! <= 0)
                      ],
                    ),
                    if (_productResponse.formats != null)
                      _buildBookFormatsSelector(
                        theme: theme,
                        ts: ts,
                        currency: currency,
                        isRtl: language.isRtl,
                        mainBook: _productResponse,
                        formats: _productResponse.formats!,
                        pricePromoPercentage:
                            _selectedProduct!.primaryCategoryPromoPercent,
                      ),
                    CustomField(
                        gap: r.size(4),
                        isRtl: language.isRtl,
                        children: [
                          _buildStockAvailability(
                              theme: theme,
                              ts: ts,
                              stockCount: _selectedProduct!.stockCount),
                          _buildDeliveryDate(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime),
                          _buildDeliveryDateRange(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime)
                        ]),
                    _buildPurchaseButtons(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        isOutOfStock: _selectedProduct!.stockCount == null ||
                            _selectedProduct!.stockCount! <= 0),
                  ])),
            ]),
        _buildSectionsSelector(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            reviewsCount: _productResponse.ratingCount),
        CustomField(
            crossAxisAlignment: CrossAxisAlignment.center,
            width: double.infinity,
            isRtl: language.isRtl,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _sectionIndex == 0
                    ? _buildResume(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        description: _selectedProduct!.description,
                      )
                    : _sectionIndex == 1
                        ? _buildCharacteristics(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            book: _selectedProduct!)
                        : _buildReviews(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            reviews: []),
              )
            ]),
        _buildProductSlider(
          title: ts.translate('screens.bookOverview.sliderTitles.sameCategory'),
          books: _productsWithSimilarCategory,
          productCount: 3,
          hideController: false,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //    _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        ),
        _buildProductSlider(
          title:
              ts.translate('screens.bookOverview.sliderTitles.suggestedBooks'),
          books: _productsWithSimilarCategory,
          productCount: 3,
          hideController: false,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //   _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        )
      ],
    );
  }

  Widget _buildTablet(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
  ) {
    return CustomField(
      isRtl: language.isRtl,
      padding: r.symmetric(horizontal: 20, vertical: 12),
      gap: r.size(16),
      children: [
        BreadCrumbs(
          theme: theme,
          isRtl: language.isRtl,
        ),
        CustomField(
            isRtl: language.isRtl,
            arrangement: FieldArrangement.row,
            crossAxisAlignment: CrossAxisAlignment.start,
            gap: r.size(14),
            children: [
              _buildCover(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
                book: _selectedProduct!,
              ),
              Expanded(
                  child: CustomField(
                      padding: r.symmetric(vertical: 10),
                      gap: r.size(10),
                      isRtl: language.isRtl,
                      children: [
                    CustomField(
                        gap: r.size(8),
                        isRtl: language.isRtl,
                        children: [
                          _buildTitle(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            title: _selectedProduct!.title,
                            format: _selectedProduct!.formatType,
                          ),
                          _buildAuthorName(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            author: _selectedProduct!.author,
                          ),
                          /* _buildRating(
                              theme: theme,
                              ts: ts,
                              isRtl: language.isRtl,
                              rating: _productResponse.ratingAverage,
                              ratingCount: _productResponse.ratingCount)*/
                        ]),
                    _buildShortDescription(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                    ),
                    _buildPriceText(
                      theme: theme,
                      ts: ts,
                      currency: currency,
                      isRtl: language.isRtl,
                      price: _selectedProduct!.price,
                      pricePromo: _selectedProduct!.pricePromo,
                      pricePromoPercentage:
                          _selectedProduct!.primaryCategoryPromoPercent,
                    ),
                    _buildWishlistCartButtons(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        book: _selectedProduct!,
                        isOutOfStock: _selectedProduct!.stockCount == null ||
                            _selectedProduct!.stockCount! <= 0),
                    if (_productResponse.formats != null)
                      _buildBookFormatsSelector(
                        theme: theme,
                        ts: ts,
                        currency: currency,
                        isRtl: language.isRtl,
                        mainBook: _productResponse,
                        formats: _productResponse.formats!,
                        pricePromoPercentage:
                            _selectedProduct!.primaryCategoryPromoPercent,
                      ),
                    CustomField(
                        gap: r.size(2),
                        isRtl: language.isRtl,
                        children: [
                          _buildStockAvailability(
                              theme: theme,
                              ts: ts,
                              stockCount: _selectedProduct!.stockCount),
                          _buildDeliveryDate(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime),
                          _buildDeliveryDateRange(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime)
                        ]),
                    _buildPurchaseButtons(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        isOutOfStock: _selectedProduct!.stockCount == null ||
                            _selectedProduct!.stockCount! <= 0),
                  ])),
            ]),
        _buildSectionsSelector(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            reviewsCount: _productResponse.ratingCount),
        CustomField(
            crossAxisAlignment: CrossAxisAlignment.center,
            width: double.infinity,
            isRtl: language.isRtl,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _sectionIndex == 0
                    ? _buildResume(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        description: _selectedProduct!.description,
                      )
                    : _sectionIndex == 1
                        ? _buildCharacteristics(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            book: _selectedProduct!)
                        : _buildReviews(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            reviews: []),
              )
            ]),
        _buildProductSlider(
          title: ts.translate('screens.bookOverview.sliderTitles.sameCategory'),
          books: _productsWithSimilarCategory,
          productCount: 2,
          hideController: true,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //    _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        ),
        _buildProductSlider(
          title:
              ts.translate('screens.bookOverview.sliderTitles.suggestedBooks'),
          books: _productsWithSimilarCategory,
          productCount: 2,
          hideController: true,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //    _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        )
      ],
    );
  }

  Widget _buildMobile(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
  ) {
    return CustomField(
      isRtl: language.isRtl,
      padding: r.symmetric(horizontal: 20, vertical: 12),
      gap: r.size(16),
      children: [
        BreadCrumbs(
          theme: theme,
          isRtl: language.isRtl,
        ),
        CustomField(
            isRtl: language.isRtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            gap: r.size(14),
            children: [
              _buildCover(
                theme: theme,
                width: double.infinity,
                ts: ts,
                isRtl: language.isRtl,
                book: _selectedProduct!,
              ),
              CustomField(
                  padding: r.symmetric(vertical: 10),
                  gap: r.size(10),
                  isRtl: language.isRtl,
                  children: [
                    CustomField(
                        gap: r.size(8),
                        isRtl: language.isRtl,
                        children: [
                          _buildTitle(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            title: _selectedProduct!.title,
                            format: _selectedProduct!.formatType,
                          ),
                          _buildAuthorName(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            author: _selectedProduct!.author,
                          ),
                          /*_buildRating(
                              theme: theme,
                              ts: ts,
                              isRtl: language.isRtl,
                              rating: _productResponse.ratingAverage,
                              ratingCount: _productResponse.ratingCount)*/
                        ]),
                    _buildShortDescription(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                    ),
                    _buildPriceText(
                      theme: theme,
                      ts: ts,
                      currency: currency,
                      isRtl: language.isRtl,
                      price: _selectedProduct!.price,
                      pricePromo: _selectedProduct!.pricePromo,
                      pricePromoPercentage:
                          _selectedProduct!.primaryCategoryPromoPercent,
                    ),
                    _buildWishlistCartButtons(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        book: _selectedProduct!,
                        isOutOfStock: _selectedProduct!.stockCount == null ||
                            _selectedProduct!.stockCount! <= 0),
                    if (_productResponse.formats != null)
                      _buildBookFormatsSelector(
                        theme: theme,
                        ts: ts,
                        currency: currency,
                        isRtl: language.isRtl,
                        mainBook: _productResponse,
                        formats: _productResponse.formats!,
                        pricePromoPercentage:
                            _selectedProduct!.primaryCategoryPromoPercent,
                      ),
                    CustomField(
                        gap: r.size(2),
                        isRtl: language.isRtl,
                        children: [
                          _buildStockAvailability(
                              theme: theme,
                              ts: ts,
                              stockCount: _selectedProduct!.stockCount),
                          _buildDeliveryDate(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime),
                          _buildDeliveryDateRange(
                              theme: theme,
                              ts: ts,
                              deliveryTime: _selectedProduct!.deliveryTime)
                        ]),
                    _buildPurchaseButtons(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        isOutOfStock: _selectedProduct!.stockCount == null ||
                            _selectedProduct!.stockCount! <= 0),
                  ]),
            ]),
        _buildSectionsSelector(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            isCompact: true,
            reviewsCount: _productResponse.ratingCount),
        CustomField(
            crossAxisAlignment: CrossAxisAlignment.center,
            width: double.infinity,
            isRtl: language.isRtl,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _sectionIndex == 0
                    ? _buildResume(
                        theme: theme,
                        ts: ts,
                        isRtl: language.isRtl,
                        description: _selectedProduct!.description,
                      )
                    : _sectionIndex == 1
                        ? _buildCharacteristics(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            isWrap: true,
                            book: _selectedProduct!)
                        : _buildReviews(
                            theme: theme,
                            ts: ts,
                            isRtl: language.isRtl,
                            reviews: []),
              )
            ]),
        _buildProductSlider(
          title: ts.translate('screens.bookOverview.sliderTitles.sameCategory'),
          books: _productsWithSimilarCategory,
          productCount: 1,
          hideController: true,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //   _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        ),
        _buildProductSlider(
          title:
              ts.translate('screens.bookOverview.sliderTitles.suggestedBooks'),
          books: _productsWithSimilarCategory,
          productCount: 1,
          hideController: true,
          isRtl: language.isRtl,
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onSeeAllPressed: () {
            //   _beamToBoutique(_productResponse.primaryCategoryNumber);
          },
          onAuthorPressed: (author) {
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
        )
      ],
    );
  }
}
