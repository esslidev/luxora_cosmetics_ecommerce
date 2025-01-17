import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_line.dart';
import 'package:librairie_alfia/features/presentation/widgets/features/quantity_selector.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_paths.dart';
import '../../../../../../../core/enums/product.dart';
import '../../../../../../../core/enums/widgets.dart';
import '../../../../../../../core/resources/currency_model.dart';
import '../../../../../../../core/util/app_util.dart';
import '../../../../../../../core/util/remote_events_util.dart';
import '../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../../core/util/translation_service.dart';
import '../../../../../../data/models/cart_item.dart';
import '../../../../../../domain/entities/cart.dart';
import '../../../../../../domain/entities/product.dart';
import '../../../../../bloc/remote/cart/cart_bloc.dart';
import '../../../../../bloc/remote/cart/cart_state.dart';
import '../../../../../bloc/remote/product/product_bloc.dart';
import '../../../../../bloc/remote/product/product_state.dart';
import '../../../../../widgets/common/custom_button.dart';
import '../../../../../widgets/common/custom_display.dart';
import '../../../../../widgets/common/custom_field.dart';
import '../../../../../widgets/common/custom_text.dart';

class CartDropdown extends StatefulWidget {
  final BaseTheme theme;
  final TranslationService ts;
  final CurrencyModel currency;
  final bool isRtl;

  const CartDropdown({
    required this.theme,
    required this.ts,
    required this.currency,
    required this.isRtl,
    super.key,
  });

  @override
  State<CartDropdown> createState() => _CartDropdownState();
}

class _CartDropdownState extends State<CartDropdown> {
  late ResponsiveSizeAdapter r;
  CartEntity? _cartResponse;
  List<ProductEntity>? _cartBooksResponse;
  bool _dataLoading = true;
  bool _dataErrorLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    RemoteEventsUtil.cartEvents.getCart(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getProductIds(List<CartItemModel> cartItems) {
    return cartItems.map((item) => item.productId.toString()).join('_');
  }

  void getProducts() {
    if (_cartResponse?.items != null && _cartResponse!.items!.isNotEmpty) {
      RemoteEventsUtil.productEvents.geCartProducts(context,
          productIds: getProductIds(_cartResponse!.items!));
    }
  }

  // ------------------------------------------------------- //

  Widget _buildProductOfferBadge(
      {required TranslationService ts,
      required bool isRtl,
      double discount = 0,
      bool? isNewArrival,
      bool? isBestSellers}) {
    return (discount != 0 || isNewArrival == true || isBestSellers == true)
        ? IgnorePointer(
            ignoring: true,
            child: CustomField(
              mainAxisSize: MainAxisSize.min,
              margin:
                  r.only(top: 2, left: !isRtl ? 2 : 0, right: isRtl ? 2 : 0),
              isRtl: isRtl,
              width: r.size(26),
              height: r.size(26),
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomDisplay(
                      assetPath: AppPaths.vectors.badge,
                      width: r.size(26),
                      height: r.size(26),
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
                      fontSize: r.size(4),
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w900,
                      color: AppColors.colors.whiteSolid,
                      padding: r.symmetric(horizontal: 2),
                    )
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _buildNoCover(
      {required BaseTheme theme, required TranslationService ts}) {
    return CustomField(
      width: r.size(60),
      height: r.size(86),
      isRtl: widget.isRtl,
      padding: r.symmetric(horizontal: 14, vertical: 10),
      backgroundColor: theme.secondaryBackgroundColor,
      gap: r.size(8),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IgnorePointer(
          ignoring: true,
          child: CustomDisplay(
            height: r.size(30),
            assetPath: AppPaths.vectors.noCover,
            svgColor: theme.primary.withOpacity(0.6),
            isSvg: true,
          ),
        ),
        CustomText(
          text: ts.translate('widgets.product.noCover'),
          fontSize: r.size(5),
          color: theme.primary.withOpacity(0.6),
          fontWeight: FontWeight.w900,
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget _buildCover({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required ProductEntity book,
    required Function() onPressed,
  }) {
    return Stack(
      children: [
        CustomDisplay(
          assetPath: book.imageUrl!,
          isNetwork: true,
          width: r.size(64),
          cursor: SystemMouseCursors.click,
          onTap: () {
            onPressed();
          },
          loadingWidget: Container(
            width: r.size(60),
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

  Widget _buildTitle({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    String? title,
    ProductFormatType? format,
    required Function() onPressed,
  }) {
    return CustomField(mainAxisSize: MainAxisSize.min, isRtl: isRtl, children: [
      Flexible(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: CustomText(
              width: r.size(120),
              text: title ?? ts.translate('screens.bookOverview.noTitle'),
              fontSize: r.size(11),
              fontWeight: FontWeight.w500,
              lineHeight: 1,
            ),
          ),
        ),
      ),
      if (format != null)
        CustomText(
          text: AppUtil.productFormatToString(ts: ts, format: format),
          fontSize: r.size(9),
          fontWeight: FontWeight.bold,
          color: theme.accent.withOpacity(0.5),
        )
    ]);
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
      isRtl: isRtl,
      mainAxisSize: MainAxisSize.min,
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(4),
      children: [
        CustomText(
          text:
              '${AppUtil.formatToTwoDecimalPlaces(pricePromo ?? AppUtil.calculatePricePromo(price ?? 0.0, pricePromoPercentage ?? 0.0)).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
          fontSize: r.size(9),
          fontWeight: FontWeight.w900,
          color: AppColors.colors.whiteOut,
          backgroundColor: theme.secondary,
          borderRadius: r.size(1),
          padding: r.symmetric(vertical: 2, horizontal: 4),
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

  Widget _buildStockUnAvailable({
    required BaseTheme theme,
    required TranslationService ts,
  }) {
    return CustomField(
      isRtl: widget.isRtl,
      width: r.size(120),
      gap: r.size(4),
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        CustomDisplay(
          assetPath: AppPaths.vectors.xFilledIcon,
          isSvg: true,
          width: r.size(8),
          height: r.size(8),
          svgColor: AppColors.colors.redRouge,
        ),
        Flexible(
          child: CustomText(
            color: AppColors.colors.redRouge,
            text: widget.ts
                .translate('screens.home.header.wishlistCart.outOfStock'),
            fontSize: r.size(8),
            lineHeight: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required Function() onPurchasePressed,
      required Function() onRemovePressed,
      bool enabled = true,
      bool? isOutOfStock = false}) {
    return CustomField(
      gap: r.size(2),
      arrangement: FieldArrangement.row,
      isRtl: isRtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          svgIconPath: AppPaths.vectors.purchaseFillIcon,
          iconColor: isOutOfStock != true
              ? AppColors.colors.whiteOut
              : theme.accent.withOpacity(0.3),
          height: r.size(16),
          iconWidth: r.size(8),
          iconTextGap: r.size(2),
          text: ts.translate('screens.bookOverview.actionButtons.purchase'),
          fontSize: r.size(7),
          fontWeight: FontWeight.bold,
          lineHeight: 1,
          enabled: enabled,
          cursor: isOutOfStock != true
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          textColor: isOutOfStock != true
              ? AppColors.colors.whiteOut
              : theme.accent.withOpacity(0.3),
          backgroundColor: isOutOfStock != true
              ? AppColors.colors.yellowHoneyGlow
              : theme.secondaryBackgroundColor,
          onHoverStyle: isOutOfStock != true
              ? CustomButtonStyle(
                  backgroundColor:
                      AppColors.colors.yellowHoneyGlow.withOpacity(0.8))
              : null,
          animationDuration: 300.ms,
          borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
          padding: r.symmetric(vertical: 4, horizontal: 6),
          onPressed: (position, size) {
            onPurchasePressed();
          },
        ),
        CustomButton(
          svgIconPath: AppPaths.vectors.trashIcon,
          iconColor: theme.accent,
          width: r.size(16),
          height: r.size(16),
          iconWidth: r.size(8),
          enabled: enabled,
          backgroundColor: theme.thirdBackgroundColor,
          animationDuration: 300.ms,
          onHoverStyle: CustomButtonStyle(
            iconColor: theme.accent.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
          padding: r.all(4),
          onPressed: (position, size) {
            onRemovePressed();
          },
        ),
      ],
    );
  }

  Widget _buildProduct({
    required BaseTheme theme,
    required TranslationService ts,
    required CurrencyModel currency,
    required bool isRtl,
    required ProductEntity book,
    required int quantity,
  }) {
    return CustomField(
        isRtl: isRtl,
        gap: r.size(6),
        crossAxisAlignment: CrossAxisAlignment.center,
        arrangement: FieldArrangement.row,
        children: [
          _buildCover(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              book: book,
              onPressed: () {
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.bookOverviewScreen}?productId=${book.id}');
              }),
          CustomField(isRtl: isRtl, gap: r.size(4), children: [
            _buildTitle(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                title: book.title,
                format: book.formatType,
                onPressed: () {
                  Beamer.of(context).beamToNamed(
                      '${AppPaths.routes.bookOverviewScreen}?productId=${book.id}');
                }),
            _buildPriceText(
                theme: theme,
                ts: ts,
                currency: currency,
                isRtl: isRtl,
                price: book.price,
                pricePromo: book.pricePromo,
                pricePromoPercentage: book.primaryCategoryPromoPercent),
            if (book.stockCount != null && book.stockCount! > 0)
              QuantitySelector(
                theme: theme,
                isRtl: isRtl,
                delayResponse: 1400.ms,
                enabled: !_dataLoading,
                initialQuantity: quantity,
                maxQuantity: book.stockCount ?? 0,
                onQuantityChanged: (value) {
                  if (book.id != null) {
                    setState(() {
                      RemoteEventsUtil.cartEvents.updateCartItem(context,
                          productId: book.id!, quantity: value);
                    });
                  }
                },
              )
            else
              _buildStockUnAvailable(theme: theme, ts: ts),
            _buildActionButtons(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                enabled: !_dataLoading,
                isOutOfStock: book.stockCount == null || book.stockCount! == 0,
                onPurchasePressed: () {},
                onRemovePressed: () {
                  if (book.id != null) {
                    setState(() {
                      RemoteEventsUtil.cartEvents.removeItemFromCart(context,
                          productId: book.id!, allQuantity: true);
                    });
                  }
                })
          ])
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _cartResponse?.items ?? [];

    return MultiBlocListener(
      listeners: [
        BlocListener<RemoteCartBloc, RemoteCartState>(
          listener: (context, state) {
            if (state is RemoteCartLoading ||
                state is RemoteCartLoading ||
                state is RemoteCartUpdatingItem ||
                state is RemoteCartRemovingItem ||
                state is RemoteCartClearing) {
              if (state.cart != null) {
                setState(() {
                  _dataLoading = true;
                });
              }
            }

            if (state is RemoteCartLoaded) {
              if (state.cart != null) {
                setState(() {
                  _dataLoading = false;
                  _cartResponse = state.cart;
                  getProducts();
                });
              }
            }

            if (state is RemoteCartItemUpdated) {
              setState(() {
                _dataLoading = false;
                final index = _cartResponse?.items?.indexWhere(
                  (element) => element.id == state.item!.id,
                );
                if (index != null && index >= 0) {
                  _cartResponse?.items?[index] = state.item!;
                }
                getProducts();
              });
            }

            if (state is RemoteCartItemRemoved) {
              setState(() {
                _dataLoading = false;
                _cartResponse?.items?.removeWhere(
                  (element) => element.id == state.item?.id,
                );
                getProducts();
              });
            }

            if (state is RemoteCartCleared) {
              setState(() {
                _dataLoading = false;
                _cartResponse?.items?.clear();
                _cartBooksResponse?.clear();
              });
            }

            if (state is RemoteCartError) {
              setState(() {
                _dataLoading = false;
                _dataErrorLoading = true;
              });
            }
          },
        ),
        BlocListener<RemoteProductBloc, RemoteProductState>(
          listener: (context, state) {
            if (state is RemoteProductsLoading) {
              if (state.cartProductsLoading == true) {
                setState(() {
                  _dataLoading = true;
                });
              }
            }

            if (state is RemoteProductsLoaded) {
              if (state.cartProducts != null) {
                setState(() {
                  _dataLoading = false;
                  _cartBooksResponse = state.cartProducts!;
                });
              }
            }
            if (state is RemoteProductError) {
              setState(() {
                _dataLoading = false;
                _dataErrorLoading = true;
              });
            }
          },
        ),
      ],
      child: CustomField(
        width: double.infinity,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: widget.isRtl,
        gap: r.size(6),
        padding: r.all(4),
        children: [
          CustomField(
            padding: r.symmetric(vertical: 4, horizontal: 4),
            arrangement: FieldArrangement.row,
            isRtl: widget.isRtl,
            backgroundColor: widget.theme.secondaryBackgroundColor,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomField(
                gap: r.size(6),
                crossAxisAlignment: CrossAxisAlignment.center,
                isRtl: widget.isRtl,
                arrangement: FieldArrangement.row,
                children: [
                  CustomText(
                    text: widget.ts.translate('screens.home.header.cart.title'),
                    fontSize: r.size(10),
                    fontWeight: FontWeight.bold,
                  ),
                  if (_dataLoading == true)
                    SizedBox(
                      width: r.size(8),
                      height: r.size(8),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.theme.accent.withOpacity(0.6),
                        ),
                        strokeWidth: r.size(1.5),
                      ),
                    )
                ],
              ),
              if (cartItems.isNotEmpty &&
                  _cartBooksResponse != null &&
                  _cartBooksResponse!.isNotEmpty)
                CustomButton(
                  text: widget.ts.translate('global.clearAll'),
                  fontSize: r.size(8),
                  padding: r.symmetric(vertical: 2, horizontal: 4),
                  backgroundColor: widget.theme.thirdBackgroundColor,
                  borderRadius: BorderRadius.circular(r.size(1)),
                  onPressed: (position, size) {
                    RemoteEventsUtil.cartEvents.clearCart(context);
                  },
                ),
            ],
          ),
          if (_dataErrorLoading == true)
            CustomText(
              text: widget.ts.translate('screens.home.header.cart.error'),
              fontSize: r.size(10),
              padding: r.symmetric(vertical: 16),
              fontWeight: FontWeight.bold,
              color: widget.theme.accent.withOpacity(0.4),
            )
          else if (cartItems.isEmpty ||
              _cartBooksResponse == null ||
              _cartBooksResponse!.isEmpty)
            CustomText(
              text: widget.ts.translate('screens.home.header.cart.empty'),
              fontSize: r.size(10),
              padding: r.symmetric(vertical: 16),
              fontWeight: FontWeight.bold,
              color: widget.theme.accent.withOpacity(0.4),
            )
          else
            IntrinsicHeight(
              child: CustomField(
                  isRtl: widget.isRtl,
                  maxHeight: r.size(240),
                  gap: r.size(8),
                  children: [
                    Expanded(
                      child: RawScrollbar(
                        thumbColor: widget.theme.primary.withOpacity(0.4),
                        radius: Radius.circular(r.size(10)),
                        thickness: r.size(5),
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: CustomField(
                              isRtl: widget.isRtl,
                              width: double.infinity,
                              gap: r.size(8),
                              children: [
                                ...cartItems.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  CartItemModel cartItem = entry.value;
                                  ProductEntity? cartProduct =
                                      _cartBooksResponse?.firstWhere(
                                    (product) =>
                                        product.id == cartItem.productId,
                                  );

                                  if (cartProduct == null) {
                                    return const SizedBox();
                                  }

                                  return CustomField(
                                    gap: r.size(8),
                                    isRtl: widget.isRtl,
                                    children: [
                                      _buildProduct(
                                          theme: widget.theme,
                                          ts: widget.ts,
                                          currency: widget.currency,
                                          isRtl: widget.isRtl,
                                          book: cartProduct,
                                          quantity: cartItem.quantity ?? 0),
                                      if (index != cartItems.length - 1)
                                        CustomLine(
                                          color: widget.theme.accent
                                              .withOpacity(0.4),
                                          thickness: r.size(0.2),
                                        ),
                                    ],
                                  );
                                }),
                              ]),
                        ),
                      ),
                    ),
                    CustomButton(
                      width: double.infinity,
                      useIntrinsicWidth: false,
                      text: widget.ts
                          .translate('screens.home.header.cart.checkoutAll'),
                      fontSize: r.size(10),
                      fontWeight: FontWeight.bold,
                      borderRadius:
                          BorderRadius.all(Radius.circular(r.size(1))),
                      textColor: widget.theme.subtle,
                      backgroundColor: widget.theme.accent,
                      animationDuration: 300.ms,
                      onHoverStyle: CustomButtonStyle(
                        backgroundColor: widget.theme.accent.withOpacity(0.8),
                      ),
                      height: r.size(20),
                      onPressed: (position, size) {
                        Beamer.of(context).beamToNamed(
                            '${AppPaths.routes.checkoutScreen}?isCart=true');
                      },
                    ),
                  ]),
            )
        ],
      ),
    );
  }
}
