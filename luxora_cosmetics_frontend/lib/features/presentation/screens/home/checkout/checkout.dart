import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_display.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_line.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/constants/google_maps_constants.dart';
import '../../../../../core/enums/notification_type.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/remote_events_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../../data/models/cart_item.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/purchase_item.dart';
import '../../../../domain/entities/user.dart';
import '../../../bloc/app/currency/currency_bloc.dart';
import '../../../bloc/app/currency/currency_state.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../bloc/remote/cart/cart_bloc.dart';
import '../../../bloc/remote/cart/cart_state.dart';
import '../../../bloc/remote/product/product_bloc.dart';
import '../../../bloc/remote/product/product_state.dart';
import '../../../bloc/remote/user/user_bloc.dart';
import '../../../bloc/remote/user/user_state.dart';
import '../../../overlays/loading/loading.dart';
import '../../../widgets/common/custom_text.dart';
import '../../../widgets/features/google_map.dart';

class CheckoutScreen extends StatefulWidget {
  final String? productIds;
  final bool? isDelivered;
  final bool? isCart;
  const CheckoutScreen(
      {super.key, this.productIds, this.isDelivered, this.isCart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  late LoadingOverlay _loadingOverlay;

  UserEntity? _userResponse;
  bool _isUserLoading = true;
  List<PurchaseItemEntity>? _itemsResponse;

  final ValueNotifier<bool> _isDelivered = ValueNotifier(true);
  final ValueNotifier<int> _mapIndex = ValueNotifier(0);
  final ValueNotifier<bool> _isPaymentOnline = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingOverlay = LoadingOverlay(
        context: homeContext!,
      );
      AppEventsUtil.breadCrumbs.clearBreadCrumbs(
        context,
      );
      if (widget.productIds == null && widget.isCart != true) {
        _beamToExploreScreen();
      }
      if (widget.isCart == true) {
        RemoteEventsUtil.userEvents.getLoggedInUser(context);
        RemoteEventsUtil.cartEvents.getCart(context);
      } else {
        RemoteEventsUtil.userEvents.getLoggedInUser(context);
        RemoteEventsUtil.productEvents
            .geCartProducts(context, productIds: widget.productIds!);
      }
    });
  }

  String _getProductIds(List<CartItemModel> cartItems) {
    return cartItems.map((item) => item.productId.toString()).join('_');
  }

  void _getProducts({required List<CartItemModel> cartItems}) {
    if (cartItems.isNotEmpty) {
      RemoteEventsUtil.productEvents
          .getCheckoutProducts(context, productIds: _getProductIds(cartItems));
    } else {}
  }

  void _beamToExploreScreen() {
    Beamer.of(context).beamToNamed(AppPaths.routes.exploreScreen);
  }

  //--------------------------------------------------------------------------//

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
                BlocListener<RemoteUserBloc, RemoteUserState>(
                  listener: (context, state) {
                    if (state is RemoteUserLoading) {
                      _isUserLoading = true;
                    }
                    if (state is RemoteUserLoaded) {
                      _isUserLoading = false;
                      if (state.user != null) {
                        setState(() {
                          _userResponse = state.user;
                        });
                      }
                    }

                    if (state is RemoteUserError) {
                      AppEventsUtil.liteNotifications
                          .addLiteNotification(context,
                              notification: LiteNotificationModel(
                                notificationTitle:
                                    state.error?.response?.data["error"],
                                notificationMessage:
                                    state.error?.response?.data["message"],
                                notificationType: NotificationType.error,
                              ));
                      _beamToExploreScreen();
                    }
                  },
                ),
                BlocListener<RemoteCartBloc, RemoteCartState>(
                  listener: (context, state) {
                    if (state is RemoteCartLoaded) {
                      if (state.cart != null) {
                        setState(() {
                          if (state.cart != null) {
                            _itemsResponse = state.cart!.items
                                ?.map((cartItem) => PurchaseItemEntity(
                                      product: ProductEntity(
                                        id: cartItem.productId,
                                      ),
                                      quantity: cartItem.quantity,
                                    ))
                                .toList();
                            print('iems1: $_itemsResponse');
                            _getProducts(cartItems: state.cart!.items!);
                          }
                        });
                      }
                    }

                    if (state is RemoteCartError) {
                      AppEventsUtil.liteNotifications
                          .addLiteNotification(context,
                              notification: LiteNotificationModel(
                                notificationTitle:
                                    state.error?.response?.data["error"],
                                notificationMessage:
                                    state.error?.response?.data["message"],
                                notificationType: NotificationType.error,
                              ));
                      _beamToExploreScreen();
                    }
                  },
                ),
                BlocListener<RemoteProductBloc, RemoteProductState>(
                  listener: (context, state) {
                    if (state is RemoteProductsLoading) {
                      if (state.cartProductsLoading != null) {
                        _loadingOverlay.show(
                            translationService:
                                translationState.translationService!,
                            r: r,
                            theme: themeState.theme);
                      }
                    }

                    if (state is RemoteProductsLoaded) {
                      if (state.cartProducts != null) {
                        _loadingOverlay.dismiss();
                        setState(() {
                          _itemsResponse = _itemsResponse?.map((purchaseItem) {
                            final product = state.cartProducts!.firstWhere(
                              (cartProduct) =>
                                  cartProduct.id == purchaseItem.product.id,
                            );
                            return PurchaseItemEntity(
                              product: product,
                              quantity: purchaseItem.quantity,
                            );
                          }).toList();
                        });
                      }
                    }
                    if (state is RemoteProductError) {
                      _loadingOverlay.dismiss();
                      AppEventsUtil.liteNotifications
                          .addLiteNotification(context,
                              notification: LiteNotificationModel(
                                notificationTitle:
                                    state.error?.response?.data["error"],
                                notificationMessage:
                                    state.error?.response?.data["message"],
                                notificationType: NotificationType.error,
                              ));
                      _beamToExploreScreen();
                    }
                  },
                ),
              ],
              child: ResponsiveScreenAdapter(
                fallbackScreen: _buildLargeDesktopDesktop(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                ),
                screenDesktop: _buildLargeDesktopDesktop(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!,
                    isDesktop: true),
                screenTablet: _buildTabletMobile(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                ),
                screenMobile: _buildTabletMobile(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!,
                    isMobile: true),
              ),
            );
          });
        }
        return const SizedBox();
      });
    });
  }

  Widget _buildHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String title,
    required String subTitle,
  }) {
    return CustomField(
      isRtl: isRtl,
      children: [
        CustomText(
          text: title,
          color: theme.secondary,
          fontSize: r.size(14),
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          text: subTitle,
          fontSize: r.size(10),
        ),
      ],
    );
  }

  Widget _buildTicket(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required String title,
      bool isEditEnabled = false,
      Function()? onEditPressed,
      required List<Widget> children,
      double gap = 0.0}) {
    return CustomField(
        isRtl: isRtl,
        padding: r.symmetric(vertical: 6, horizontal: 8),
        borderRadius: r.size(2),
        borderColor: theme.accent.withOpacity(0.2),
        borderWidth: r.size(0.6),
        gap: gap,
        children: [
          CustomField(isRtl: isRtl, gap: r.size(4), children: [
            CustomField(
              isRtl: isRtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              arrangement: FieldArrangement.row,
              children: [
                CustomText(
                  text: title,
                  fontSize: r.size(10),
                  fontWeight: FontWeight.bold,
                ),
                if (isEditEnabled)
                  CustomButton(
                    svgIconPath: AppPaths.vectors.editIcon,
                    width: r.size(10),
                    height: r.size(10),
                    iconColor: theme.accent.withOpacity(0.6),
                    onHoverStyle: CustomButtonStyle(
                      iconColor: theme.accent,
                    ),
                    onPressed: (position, size) {
                      if (onEditPressed != null) {
                        onEditPressed();
                      }
                    },
                  )
              ],
            ),
            CustomLine(
              color: theme.accent.withOpacity(0.4),
              thickness: r.size(0.2),
            ),
          ]),
          CustomField(isRtl: isRtl, gap: gap, children: children)
        ]);
  }

  Widget _buildItemsList({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return _buildTicket(
      theme: theme,
      ts: ts,
      isRtl: isRtl,
      title: ts.translate('screens.checkout.itemsList.title'),
      children: [],
    );
  }

  Widget _buildShippingDetailsDataField({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String name,
    required String value,
  }) {
    return CustomField(
        isRtl: isRtl,
        gap: r.size(4),
        arrangement: FieldArrangement.row,
        children: [
          CustomText(
            text: name,
            fontSize: r.size(9),
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            text: value,
            fontSize: r.size(9),
            fontWeight: FontWeight.bold,
            color: theme.accent.withOpacity(0.5),
            overflow: TextOverflow.ellipsis,
          )
        ]);
  }

  Widget _buildShippingDetails({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return _buildTicket(
      theme: theme,
      ts: ts,
      isRtl: isRtl,
      title: ts.translate('screens.checkout.shippingDetails.title'),
      gap: r.size(4),
      isEditEnabled: true,
      onEditPressed: () {
        Beamer.of(context).beamToNamed(
          AppPaths.routes.editProfileScreen,
        );
      },
      children: [
        _buildShippingDetailsDataField(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            name: '${ts.translate('global.authentication.fullName')} :',
            value: '${_userResponse?.firstName}'),
        _buildShippingDetailsDataField(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            name: '${ts.translate('global.authentication.phone')} :',
            value: '${_userResponse?.phone}'),
        _buildShippingDetailsDataField(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            name: '${ts.translate('global.authentication.address')} :',
            value: '${_userResponse?.addressMain}'),
        if (_userResponse?.addressSecond != null)
          _buildShippingDetailsDataField(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              name:
                  '${ts.translate('global.authentication.addressOptional')} :',
              value: '${_userResponse?.addressSecond}'),
        CustomField(
            isRtl: isRtl,
            gap: r.size(20),
            arrangement: FieldArrangement.row,
            children: [
              _buildShippingDetailsDataField(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  name: '${ts.translate('global.authentication.city')} :',
                  value: '${_userResponse?.city}'),
              _buildShippingDetailsDataField(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  name: '${ts.translate('global.authentication.zipCode')} :',
                  value: '${_userResponse?.zip}'),
            ])
      ],
    );
  }

  Widget _buildRadioBar({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String svgPath,
    required String text,
    bool isEnabled = false,
    bool isPaymentLogosShown = false,
    required Function() onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: CustomField(
          isRtl: isRtl,
          gap: r.size(8),
          crossAxisAlignment: CrossAxisAlignment.center,
          arrangement: FieldArrangement.row,
          padding: r.symmetric(vertical: 4, horizontal: 8),
          borderRadius: r.size(2),
          borderColor:
              isEnabled ? theme.primary : theme.accent.withOpacity(0.4),
          borderWidth: r.size(0.6),
          backgroundColor: isEnabled ? theme.primary.withOpacity(0.1) : null,
          children: [
            CustomField(
              isRtl: isRtl,
              width: r.size(9),
              height: r.size(9),
              borderColor:
                  isEnabled ? theme.primary : theme.accent.withOpacity(0.4),
              borderWidth: r.size(0.6),
              borderRadius: r.size(5),
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomField(
                  isRtl: isRtl,
                  width: r.size(4),
                  height: r.size(4),
                  borderRadius: r.size(4),
                  backgroundColor: isEnabled ? theme.primary : null,
                  children: [],
                ),
              ],
            ),
            CustomDisplay(
              assetPath: svgPath,
              isSvg: true,
              width: r.size(18),
              height: r.size(9),
              svgColor: theme.primary,
              cursor: SystemMouseCursors.click,
            ),
            CustomText(
              text: text,
              fontSize: r.size(9),
            ),
            if (isPaymentLogosShown)
              CustomDisplay(
                assetPath: AppPaths.images.paymentMethods,
                height: r.size(10),
                cursor: SystemMouseCursors.click,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioMagasinMapField({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String name,
    required String mapUrl,
    bool isEnabled = false,
    required Function() onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: CustomField(
          isRtl: isRtl,
          gap: r.size(8),
          padding: r.symmetric(vertical: 4, horizontal: 8),
          borderRadius: r.size(2),
          borderColor:
              isEnabled ? theme.primary : theme.accent.withOpacity(0.4),
          borderWidth: r.size(0.6),
          backgroundColor: isEnabled ? theme.primary.withOpacity(0.1) : null,
          children: [
            CustomField(
              isRtl: isRtl,
              gap: r.size(8),
              crossAxisAlignment: CrossAxisAlignment.center,
              arrangement: FieldArrangement.row,
              children: [
                CustomField(
                  isRtl: isRtl,
                  width: r.size(9),
                  height: r.size(9),
                  borderColor:
                      isEnabled ? theme.primary : theme.accent.withOpacity(0.4),
                  borderWidth: r.size(0.6),
                  borderRadius: r.size(5),
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomField(
                      isRtl: isRtl,
                      width: r.size(4),
                      height: r.size(4),
                      borderRadius: r.size(4),
                      backgroundColor: isEnabled ? theme.primary : null,
                      children: [],
                    ),
                  ],
                ),
                CustomText(
                  text: name,
                  fontSize: r.size(10),
                  fontWeight: FontWeight.bold,
                  color: theme.accent.withOpacity(0.7),
                ),
              ],
            ),
            GoogleMap(
              mapUrl: mapUrl,
              height: r.size(120),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMagasinsLocations({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return ValueListenableBuilder(
        valueListenable: _mapIndex,
        builder: (context, mapIndex, child) {
          return _buildTicket(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              title: ts.translate(
                  'screens.checkout.deliveryOptions.magasinsLocationsTitle'),
              gap: r.size(8),
              children: [
                CustomField(
                  isRtl: isRtl,
                  gap: r.size(6),
                  arrangement: FieldArrangement.row,
                  children: [
                    Expanded(
                        child: _buildRadioMagasinMapField(
                            theme: theme,
                            ts: ts,
                            isRtl: isRtl,
                            name: 'Alfia Centre Ville',
                            isEnabled: mapIndex == 0,
                            onPressed: () {
                              _mapIndex.value = 0;
                            },
                            mapUrl: map1Url)),
                    Expanded(
                        child: _buildRadioMagasinMapField(
                            theme: theme,
                            ts: ts,
                            isRtl: isRtl,
                            name: 'Alfia Temara',
                            isEnabled: mapIndex == 1,
                            onPressed: () {
                              _mapIndex.value = 1;
                            },
                            mapUrl: map2Url)),
                  ],
                )
              ]);
        });
  }

  Widget _buildDeliveryOptionsButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return ValueListenableBuilder(
      valueListenable: _isDelivered,
      builder: (context, isDelivered, child) {
        return ValueListenableBuilder(
            valueListenable: _isPaymentOnline,
            builder: (context, isPaymentOnline, child) {
              return _buildTicket(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                title: ts.translate('screens.checkout.deliveryOptions.title'),
                gap: r.size(8),
                children: [
                  _buildRadioBar(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    svgPath: AppPaths.vectors.deliveryIcon,
                    text:
                        '${ts.translate('screens.checkout.deliveryOptions.deliveredText1')} 2 ${ts.translate('screens.checkout.deliveryOptions.deliveredText2')}',
                    isEnabled: isDelivered,
                    onPressed: () {
                      _isDelivered.value = true;
                    },
                  ),
                  _buildRadioBar(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    svgPath: AppPaths.vectors.bookStoreIcon,
                    text: ts.translate(
                        'screens.checkout.deliveryOptions.pickupInMagasins'),
                    isEnabled: !isDelivered,
                    onPressed: () {
                      _isDelivered.value = false;
                    },
                  ),
                  if (!isDelivered)
                    _buildMagasinsLocations(theme: theme, ts: ts, isRtl: isRtl),
                ],
              );
            });
      },
    );
  }

  Widget _buildPaymentOptionsButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return ValueListenableBuilder(
        valueListenable: _isDelivered,
        builder: (context, isDelivered, child) {
          return ValueListenableBuilder(
              valueListenable: _isPaymentOnline,
              builder: (context, isPaymentOnline, child) {
                return _buildTicket(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  title: ts.translate('screens.checkout.paymentOptions.title'),
                  gap: r.size(8),
                  children: [
                    _buildRadioBar(
                      theme: theme,
                      ts: ts,
                      isRtl: isRtl,
                      svgPath: AppPaths.vectors.creditCardFilledIcon,
                      text: ts.translate(
                          'screens.checkout.paymentOptions.payOnline'),
                      isPaymentLogosShown: true,
                      isEnabled: isPaymentOnline,
                      onPressed: () {
                        _isPaymentOnline.value = true;
                      },
                    ),
                    _buildRadioBar(
                      theme: theme,
                      ts: ts,
                      isRtl: isRtl,
                      svgPath: AppPaths.vectors.payMoneyFilledIcon,
                      text: isDelivered
                          ? ts.translate(
                              'screens.checkout.paymentOptions.payOnDelivery')
                          : ts.translate(
                              'screens.checkout.paymentOptions.payAtMagasin'),
                      isEnabled: !isPaymentOnline,
                      onPressed: () {
                        _isPaymentOnline.value = false;
                      },
                    )
                  ],
                );
              });
        });
  }

  Widget _buildOrderSummaryDataField({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    int? quantity,
    required String title,
    required double price,
  }) {
    return CustomField(
        isRtl: isRtl,
        gap: r.size(2),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        arrangement: FieldArrangement.row,
        children: [
          CustomField(
              isRtl: isRtl,
              gap: r.size(4),
              arrangement: FieldArrangement.row,
              children: [
                if (quantity != null)
                  CustomText(
                    text: 'x$quantity',
                    fontSize: r.size(9),
                    fontWeight: FontWeight.bold,
                    color: theme.accent.withOpacity(0.4),
                  ),
                CustomText(
                  text: title,
                  fontSize: r.size(9),
                ),
              ]),
          CustomText(
            text: '$price',
            fontSize: r.size(9),
          ),
        ]);
  }

  Widget _buildOrderSummaryItemsList({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      isRtl: isRtl,
      gap: r.size(4),
      children: [
        if (_itemsResponse != null)
          ..._itemsResponse!.map((purchaseItem) {
            return _buildOrderSummaryDataField(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              quantity: purchaseItem.quantity,
              title: purchaseItem.product.title ?? 'Unknown Product',
              price: purchaseItem.product.price ?? 0.0,
            );
          }),
      ],
    );
  }

  Widget _buildOrderSummaryDeliveryTax({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      isRtl: isRtl,
      gap: r.size(4),
      children: [
        _buildOrderSummaryDataField(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          title: ts
              .translate('screens.checkout.orderSummary.deliveryTax.totalExc'),
          price: 155.85,
        ),
        _buildOrderSummaryDataField(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          title: ts
              .translate('screens.checkout.orderSummary.deliveryTax.delivery'),
          price: 55.85,
        ),
        _buildOrderSummaryDataField(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          title: ts.translate('screens.checkout.orderSummary.deliveryTax.tax'),
          price: 22.85,
        )
      ],
    );
  }

  Widget _buildOrderSummaryTotal({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      isRtl: isRtl,
      width: double.infinity,
      padding: r.symmetric(vertical: 6, horizontal: 12),
      borderRadius: r.size(2),
      borderColor: theme.primary,
      borderWidth: r.size(0.6),
      backgroundColor: theme.primary.withOpacity(0.1),
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: ts.translate('screens.checkout.orderSummary.totalText'),
          fontSize: r.size(9),
          fontWeight: FontWeight.bold,
          color: theme.primary,
        ),
        CustomText(
          text: '200.55',
          fontSize: r.size(10),
          fontWeight: FontWeight.bold,
          color: theme.primary,
        ),
      ],
    );
  }

  Widget _buildOrderSummary({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return _buildTicket(
      theme: theme,
      ts: ts,
      isRtl: isRtl,
      title: ts.translate('screens.checkout.orderSummary.title'),
      gap: r.size(8),
      children: [
        _buildOrderSummaryItemsList(theme: theme, ts: ts, isRtl: isRtl),
        CustomLine(
          color: theme.accent.withOpacity(0.4),
          thickness: r.size(0.2),
        ),
        _buildOrderSummaryDeliveryTax(theme: theme, ts: ts, isRtl: isRtl),
        CustomLine(
          color: theme.accent.withOpacity(0.4),
          thickness: r.size(0.2),
        ),
        _buildOrderSummaryTotal(theme: theme, ts: ts, isRtl: isRtl)
      ],
    );
  }

  Widget _buildConfirmPaymentButtons(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      bool useIntrinsicWidth = true,
      bool isEnabled = true}) {
    return CustomButton(
      text: '${ts.translate('screens.checkout.confirmPayment')} 270.55 DH',
      fontSize: r.size(10),
      fontWeight: FontWeight.bold,
      textColor: AppColors.colors.whiteOut,
      backgroundColor: theme.primary,
      padding: r.symmetric(vertical: 4, horizontal: 16),
      borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
      animationDuration: 300.ms,
      useIntrinsicWidth: useIntrinsicWidth,
      enabled: isEnabled,
      onHoverStyle: CustomButtonStyle(
        backgroundColor: theme.secondary,
      ),
      onDisabledStyle: CustomButtonStyle(
          backgroundColor: theme.secondaryBackgroundColor,
          textColor: theme.accent.withOpacity(0.3)),
      onPressed: (position, size) {},
    );
  }

  //----------------------------------------------------------------//

  Widget _buildLargeDesktopDesktop(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language, {
    bool isDesktop = false,
  }) {
    return CustomField(
        isRtl: language.isRtl,
        padding: r.symmetric(horizontal: isDesktop ? 20 : 100, vertical: 20),
        gap: r.size(20),
        children: [
          _buildHeader(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            title: ts.translate('screens.checkout.title'),
            subTitle: ts.translate('screens.checkout.subTitle'),
          ),
          CustomField(
            isRtl: language.isRtl,
            gap: r.size(10),
            children: [
              CustomField(
                  isRtl: language.isRtl,
                  gap: r.size(isDesktop ? 10 : 20),
                  arrangement: FieldArrangement.row,
                  children: [
                    Expanded(
                        flex: 65,
                        child: CustomField(
                            isRtl: language.isRtl,
                            gap: r.size(6),
                            children: [
                              _buildItemsList(
                                theme: theme,
                                ts: ts,
                                isRtl: language.isRtl,
                              ),
                              _buildShippingDetails(
                                theme: theme,
                                ts: ts,
                                isRtl: language.isRtl,
                              ),
                              _buildDeliveryOptionsButtons(
                                theme: theme,
                                ts: ts,
                                isRtl: language.isRtl,
                              ),
                              _buildPaymentOptionsButtons(
                                theme: theme,
                                ts: ts,
                                isRtl: language.isRtl,
                              ),
                            ])),
                    Expanded(
                        flex: 35,
                        child: _buildOrderSummary(
                          theme: theme,
                          ts: ts,
                          isRtl: language.isRtl,
                        )),
                  ]),
              _buildConfirmPaymentButtons(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
              )
            ],
          ),
        ]);
  }

  Widget _buildTabletMobile(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language, {
    bool isMobile = false,
  }) {
    return CustomField(
      isRtl: language.isRtl,
      padding: r.symmetric(horizontal: 10, vertical: 20),
      gap: r.size(20),
      children: [
        _buildHeader(
          theme: theme,
          ts: ts,
          isRtl: language.isRtl,
          title: ts.translate('screens.checkout.title'),
          subTitle: ts.translate('screens.checkout.subTitle'),
        ),
        CustomField(isRtl: language.isRtl, gap: r.size(6), children: [
          _buildItemsList(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
          ),
          _buildShippingDetails(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
          ),
          _buildDeliveryOptionsButtons(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
          ),
          _buildPaymentOptionsButtons(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
          ),
          _buildOrderSummary(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
          ),
        ]),
        _buildConfirmPaymentButtons(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            useIntrinsicWidth: !isMobile),
      ],
    );
  }
}
