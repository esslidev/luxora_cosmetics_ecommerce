import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/util/responsive_screen_adapter.dart';
import 'package:librairie_alfia/features/data/models/author.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/resources/language_model.dart';
import '../../../../core/util/custom_timer.dart';
import '../../../../core/util/remote_events_util.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../../core/util/translation_service.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/wishlist.dart';
import '../../bloc/app/language/translation_bloc.dart';
import '../../bloc/app/language/translation_state.dart';
import '../../bloc/app/theme/theme_bloc.dart';
import '../../bloc/app/theme/theme_state.dart';
import '../../bloc/remote/cart/cart_bloc.dart';
import '../../bloc/remote/cart/cart_state.dart';
import '../../bloc/remote/wishlist/wishlist_bloc.dart';
import '../../bloc/remote/wishlist/wishlist_state.dart';
import '../common/custom_button.dart';
import '../common/custom_field.dart';
import '../common/custom_shrinking_line.dart';
import '../common/custom_text.dart';
import 'product.dart';

class ProductSliderWidget extends StatefulWidget {
  final List<ProductEntity> books;
  final double? height;
  final String? title;
  final double? authorFontSize;
  final double? titleFontSize;
  final double? priceFontSize;
  final int productCount;
  final bool hideController;
  final bool reverse;

  // action callbacks
  final Function()? onSeeAllPressed;
  final Function(int productId, String productName)? onPressed;
  final Function(int productId)? onPurchasePressed;
  final Function(AuthorModel author)? onAuthorPressed;

  const ProductSliderWidget(
      {super.key,
      required this.books,
      this.height,
      this.title,
      this.authorFontSize,
      this.titleFontSize,
      this.priceFontSize,
      this.productCount = 5,
      this.hideController = false,
      this.reverse = false,
      this.onSeeAllPressed,
      this.onPressed,
      this.onPurchasePressed,
      this.onAuthorPressed});

  @override
  State<ProductSliderWidget> createState() => _ProductSliderWidgetState();
}

class _ProductSliderWidgetState extends State<ProductSliderWidget> {
  late ResponsiveSizeAdapter r;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  CustomTimer? _autoPlayTimer;

  CartEntity? _cartResponse;
  WishlistEntity? _wishlistResponse;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RemoteEventsUtil.wishlistEvents.getWishlist(context);
      RemoteEventsUtil.cartEvents.getCart(context);
      _autoPlayTimer = CustomTimer(
        onTimerStop: () {
          _nextPage(widget.productCount);
          _autoPlayTimer?.restart(duration: 12.seconds);
        },
      );
      _autoPlayTimer?.start(duration: 12.seconds);
    });
  }

  Future<void> _nextPage(int steps) async {
    Duration duration = steps > 4
        ? 200.ms
        : steps > 2
            ? 300.ms
            : 400.ms;
    for (int i = 0; i < steps; i++) {
      await _carouselController.nextPage(duration: duration);
      _autoPlayTimer?.restart(duration: 12.seconds);
    }
  }

  Future<void> _previousPage(int steps) async {
    Duration duration = steps > 4
        ? 200.ms
        : steps > 2
            ? 300.ms
            : 400.ms;
    for (int i = 0; i < steps; i++) {
      await _carouselController.previousPage(duration: duration);
      _autoPlayTimer?.restart(duration: 12.seconds);
    }
  }

  //----------------------------------------------------------//

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

                      if (state is RemoteWishlistError) {}
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
                            _cartResponse?.items?[existingIndex] = state.item!;
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

                      if (state is RemoteCartError) {}
                    },
                  ),
                ],
                child: ResponsiveScreenAdapter(
                  fallbackScreen: _buildProductSlider(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!),
                  screenMobile: _buildProductSlider(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!,
                      isMobile: true),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    bool isMobile = false,
  }) {
    return CustomField(
      gap: isMobile ? r.size(4) : r.size(8),
      padding: !isMobile ? r.symmetric(horizontal: 20) : null,
      isRtl: isRtl,
      children: [
        CustomField(
            arrangement: FieldArrangement.row,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            isRtl: isRtl,
            children: [
              CustomText(
                text: widget.title ?? '',
                color: theme.secondary,
                fontSize: isMobile ? r.size(12) : r.size(20),
                fontWeight: FontWeight.bold,
              ),
              CustomButton(
                text: ts.translate('widgets.productSlider.seeAll'),
                textColor: theme.bodyText,
                fontSize: isMobile ? r.size(12) : r.size(14),
                fontWeight: FontWeight.bold,
                onPressed: (position, size) {
                  if (widget.onSeeAllPressed != null) {
                    widget.onSeeAllPressed!();
                  }
                },
              ),
            ]),
        CustomShrinkingLine(
          color: theme.accent.withOpacity(0.8),
          thickness: r.size(1),
        ),
      ],
    );
  }

  Widget _buildProductSlider(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language,
      {bool isMobile = false}) {
    return CustomField(
      gap: r.size(20),
      children: [
        _buildHeader(
            theme: theme, ts: ts, isRtl: language.isRtl, isMobile: isMobile),
        CustomField(
          arrangement: FieldArrangement.row,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: r.size(10),
          children: [
            if (!widget.hideController && widget.books.isNotEmpty)
              CustomButton(
                svgIconPath: AppPaths.vectors.arrowLeftIcon,
                iconColor: theme.accent.withOpacity(0.6),
                iconHeight: r.size(14),
                width: r.size(26),
                height: r.size(26),
                borderRadius: BorderRadius.all(Radius.circular(r.size(10))),
                backgroundColor: theme.secondaryBackgroundColor,
                onHoverStyle: CustomButtonStyle(iconColor: theme.accent),
                onPressed: (position, size) {
                  _previousPage(widget.productCount);
                },
              ),
            if (widget.books.isNotEmpty)
              Expanded(
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: false,
                    reverse: widget.reverse,
                    //autoPlayInterval: const Duration(seconds: 12),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 300),
                    padEnds: false,
                    enlargeCenterPage: false,
                    autoPlayCurve: Curves.decelerate,
                    enableInfiniteScroll: true,
                    height: widget.height ?? r.size(300),
                    viewportFraction: 1 / widget.productCount,
                  ),
                  items: widget.books
                      .map((book) => ProductWidget(
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
                            authorFontSize: widget.authorFontSize,
                            titleFontSize: widget.titleFontSize,
                            priceFontSize: widget.priceFontSize,
                            borderOnHover: true,
                            isOnWishlist: (_wishlistResponse?.items?.any(
                                  (item) => item.productId == book.id,
                                ) ??
                                false),
                            isOnCart: (_cartResponse?.items?.any(
                                  (item) => item.productId == book.id,
                                ) ??
                                false),
                            onPressed: widget.onPressed,
                            onWishlistPressed: (productId) {
                              final existingInWishlist =
                                  (_wishlistResponse?.items?.any(
                                        (item) => item.productId == productId,
                                      ) ??
                                      false);
                              if (existingInWishlist) {
                                RemoteEventsUtil.wishlistEvents
                                    .removeItemFromWishlist(context,
                                        productId: productId,
                                        allQuantity: true);
                              } else {
                                RemoteEventsUtil.wishlistEvents
                                    .addItemToWishlist(context, productId);
                              }
                            },
                            onCartPressed: (productId) {
                              final existingInCart = (_cartResponse?.items?.any(
                                    (item) => item.productId == productId,
                                  ) ??
                                  false);
                              if (existingInCart) {
                                RemoteEventsUtil.cartEvents.removeItemFromCart(
                                    context,
                                    productId: productId,
                                    allQuantity: true);
                              } else {
                                RemoteEventsUtil.cartEvents.addItemToCart(
                                    context,
                                    productId: productId);
                              }
                            },
                            onPurchasePressed: widget.onPurchasePressed,
                            onAuthorPressed: widget.onAuthorPressed,
                          ))
                      .toList(),
                ),
              )
            else
              Expanded(
                  child: CustomField(
                      backgroundColor: theme.secondaryBackgroundColor,
                      height: r.size(200),
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    CustomText(
                      text: 'Data is not available yet.',
                      fontSize: r.size(12),
                      padding: r.symmetric(vertical: 16),
                      fontWeight: FontWeight.bold,
                      color: theme.accent.withOpacity(0.4),
                    )
                  ])),
            if (!widget.hideController && widget.books.isNotEmpty)
              CustomButton(
                svgIconPath: AppPaths.vectors.arrowRightIcon,
                iconColor: theme.accent.withOpacity(0.6),
                iconHeight: r.size(14),
                width: r.size(26),
                height: r.size(26),
                borderRadius: BorderRadius.all(Radius.circular(r.size(10))),
                backgroundColor: theme.secondaryBackgroundColor,
                onHoverStyle: CustomButtonStyle(iconColor: theme.accent),
                onPressed: (position, size) async {
                  _nextPage(widget.productCount);
                },
              ),
          ],
        ),
      ],
    );
  }
}
