import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/constants/shared_preference_keys.dart';
import 'package:librairie_alfia/core/util/prefs_util.dart';
import 'package:librairie_alfia/features/presentation/bloc/remote/auth/auth_bloc.dart';
import 'package:librairie_alfia/features/presentation/overlays/side_navigator/side_navigator.dart';
import 'package:librairie_alfia/features/presentation/screens/home/widgets/header/widgets/user_dropdown.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_tooltip.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_paths.dart';
import '../../../../../../core/constants/google_maps_constants.dart';
import '../../../../../../core/enums/notification_type.dart';
import '../../../../../../core/enums/theme_style.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/resources/currency_model.dart';
import '../../../../../../core/resources/global_contexts.dart';
import '../../../../../../core/resources/language_model.dart';
import '../../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../../core/util/app_events_util.dart';
import '../../../../../../core/util/remote_events_util.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';
import '../../../../../../locator.dart';
import '../../../../../domain/entities/cart.dart';

import '../../../../../domain/entities/wishlist.dart';
import '../../../../bloc/app/currency/currency_bloc.dart';
import '../../../../bloc/app/currency/currency_state.dart';
import '../../../../bloc/app/language/translation_bloc.dart';
import '../../../../bloc/app/language/translation_state.dart';
import '../../../../bloc/app/theme/theme_bloc.dart';
import '../../../../bloc/app/theme/theme_state.dart';
import '../../../../bloc/remote/auth/auth_state.dart';
import '../../../../bloc/remote/cart/cart_bloc.dart';
import '../../../../bloc/remote/cart/cart_state.dart';

import '../../../../bloc/remote/wishlist/wishlist_bloc.dart';
import '../../../../bloc/remote/wishlist/wishlist_state.dart';
import '../../../../overlays/create_account/create_account.dart';
import '../../../../overlays/dropdown/dropdown.dart';
import '../../../../overlays/loading/loading.dart';
import '../../../../overlays/sign_in/sign_in.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_display.dart';
import '../../../../widgets/common/custom_field.dart';
import '../../../../widgets/common/custom_text.dart';
import '../../../../widgets/features/google_map.dart';
import 'widgets/cart_dropdown.dart';
import 'widgets/searchbar/search_bar.dart';
import 'widgets/wishlist_dropdown.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  WishlistEntity? _wishlistResponse;
  CartEntity? _cartResponse;

  final LayerLink _wishlistDropdownLayerLink = LayerLink();
  final LayerLink _magasinLocationsDropdownLayerLink = LayerLink();
  final LayerLink _userDropdownLayerLink = LayerLink();
  final LayerLink _cartDropdownLayerLink = LayerLink();

  late LoadingOverlay _loadingOverlay;

  late SignInOverlay _signInOverlay;
  late CreateAccountOverlay _createAccountOverlay;

  late SideNavigatorOverlay _sideNavigatorOverlay;

  late DropdownOverlay _wishlistDropdown;
  late DropdownOverlay _cartDropdown;
  late DropdownOverlay _magasinLocationsDropdown;
  late DropdownOverlay _userDropdown;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingOverlay = LoadingOverlay(
        context: homeContext!,
      );

      _sideNavigatorOverlay = SideNavigatorOverlay(
        context: homeContext!,
      );

      _signInOverlay = SignInOverlay(
        context: homeContext!,
        r: r,
      );

      _createAccountOverlay = CreateAccountOverlay(
        context: homeContext!,
        r: r,
      );

      _wishlistDropdown = _buildActionButtonsDropdown();
      _cartDropdown = _buildActionButtonsDropdown();
      _magasinLocationsDropdown = _buildActionButtonsDropdown();
      _userDropdown = _buildActionButtonsDropdown();
      RemoteEventsUtil.wishlistEvents.getWishlist(context);
      RemoteEventsUtil.cartEvents.getCart(context);
    });
  }

  //----------------------------------------------------------------------------------------------------//

  DropdownOverlay _buildActionButtonsDropdown() {
    return DropdownOverlay(
      context: context,
      borderRadius: Radius.circular(r.size(3)),
      borderWidth: r.size(1),
      margin: EdgeInsets.only(top: r.size(8)),
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
    );
  }

  Widget _buildMagasinLocationsDropdownChild(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl}) {
    return CustomField(
        width: double.infinity,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: isRtl,
        gap: r.size(4),
        padding: r.only(top: 4, bottom: 8, left: 4, right: 4),
        children: [
          CustomText(
            text: ts.translate('screens.home.header.magasinLocations.title'),
            backgroundColor: theme.secondaryBackgroundColor,
            width: double.infinity,
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            padding: EdgeInsets.symmetric(
                vertical: r.size(4), horizontal: r.size(8)),
          ),
          CustomField(
            gap: r.size(4),
            children: [
              CustomText(
                text: 'Alfia Centre ville',
                fontSize: r.size(10),
                fontWeight: FontWeight.bold,
                color: theme.accent.withOpacity(0.7),
              ),
              GoogleMap(mapUrl: map1Url),
            ],
          ),
          CustomField(
            gap: r.size(4),
            children: [
              CustomText(
                text: 'Alfia Temara',
                fontSize: r.size(10),
                fontWeight: FontWeight.bold,
                color: theme.accent.withOpacity(0.7),
              ),
              GoogleMap(mapUrl: map2Url),
            ],
          ),
        ]);
  }

  //----------------------------------------------------------------------------------------------------//

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
                    BlocListener<RemoteAuthBloc, RemoteAuthState>(
                      listener: (context, state) {
                        if (state is RemoteAuthSignedUp) {
                          _loadingOverlay.dismiss();
                          setState(() {});
                        }
                        if (state is RemoteAuthSignedIn) {
                          _loadingOverlay.dismiss();
                          setState(() {});
                        }

                        if (state is RemoteAuthSigningOut) {
                          _loadingOverlay.show(
                            translationService:
                                translationState.translationService!,
                            r: r,
                            theme: themeState.theme,
                          );
                        }
                        if (state is RemoteAuthSignedOut) {
                          _loadingOverlay.dismiss();
                          setState(() {
                            RemoteEventsUtil.wishlistEvents
                                .getWishlist(context);
                            RemoteEventsUtil.cartEvents.getCart(context);
                          });
                          AppEventsUtil.liteNotifications
                              .addLiteNotification(context,
                                  notification: LiteNotificationModel(
                                    notificationTitle: translationState
                                        .translationService!
                                        .translate(
                                            'global.notifications.signedOut.title'),
                                    notificationMessage: translationState
                                        .translationService!
                                        .translate(
                                            'global.notifications.signedOut.message'),
                                    notificationType: NotificationType.success,
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
                            _wishlistResponse?.items?.add(state.item!);
                          });
                          AppEventsUtil.liteNotifications
                              .addLiteNotification(context,
                                  notification: LiteNotificationModel(
                                    notificationTitle: translationState
                                        .translationService!
                                        .translate(
                                            'global.notifications.wishlist.title'),
                                    notificationMessage: translationState
                                        .translationService!
                                        .translate(
                                            'global.notifications.wishlist.message'),
                                    notificationType: NotificationType.success,
                                  ));
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
                            _wishlistResponse?.items?.clear();
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
                            _cartResponse?.items?.add(state.item!);
                          });
                          AppEventsUtil.liteNotifications
                              .addLiteNotification(context,
                                  notification: LiteNotificationModel(
                                    notificationTitle: translationState
                                        .translationService!
                                        .translate(
                                            'global.notifications.cart.title'),
                                    notificationMessage: translationState
                                        .translationService!
                                        .translate(
                                            'global.notifications.cart.message'),
                                    notificationType: NotificationType.success,
                                  ));
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
                            _cartResponse?.items?.clear();
                          });
                        }
                      },
                    ),
                  ],
                  child: ResponsiveScreenAdapter(
                    fallbackScreen: _buildLargeDesktop(
                        context,
                        themeState.theme,
                        themeState.themeStyle,
                        translationState.translationService!,
                        currencyState.currency,
                        translationState.language!),
                    screenLargeDesktop: _buildLargeDesktop(
                        context,
                        themeState.theme,
                        themeState.themeStyle,
                        translationState.translationService!,
                        currencyState.currency,
                        translationState.language!),
                    screenDesktop: _buildDesktop(
                        context,
                        themeState.theme,
                        themeState.themeStyle,
                        translationState.translationService!,
                        currencyState.currency,
                        translationState.language!),
                    screenTablet: _buildTablet(
                        context,
                        themeState.theme,
                        themeState.themeStyle,
                        translationState.translationService!,
                        currencyState.currency,
                        translationState.language!),
                    screenMobile: _buildMobile(
                        context,
                        themeState.theme,
                        themeState.themeStyle,
                        translationState.translationService!,
                        currencyState.currency,
                        translationState.language!),
                  ),
                );
              });
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildLogoButton({required ThemeStyle themeStyle, double? height}) {
    return CustomDisplay(
      assetPath: themeStyle == ThemeStyle.light
          ? AppPaths.vectors.logo
          : AppPaths.vectors.logoDark,
      isSvg: true,
      height: height ?? r.size(42),
      onTap: () {
        Beamer.of(context).beamToNamed(
          AppPaths.routes.exploreScreen,
        );
      },
      cursor: SystemMouseCursors.click,
    );
  }

  Widget _buildActionButton(
      {required BaseTheme theme,
      double? width,
      double? height,
      required String svgIconPath,
      Color? iconColor,
      int? itemsCount,
      bool? isActive,
      required Function(Offset position, Size size)? onPressed}) {
    return Stack(
      children: [
        CustomButton(
          height: width ?? r.size(15),
          width: height ?? r.size(22),
          svgIconPath: svgIconPath,
          iconColor: iconColor,
          onPressed: onPressed,
        ),
        if (itemsCount != null || isActive == true)
          Positioned(
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                ignoring: true,
                child: CustomField(
                    backgroundColor: isActive == true
                        ? theme.primary
                        : theme.thirdBackgroundColor,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    borderRadius: r.size(6),
                    padding: r.symmetric(vertical: 2.5, horizontal: 2.5),
                    children: [
                      CustomText(
                        text: isActive == true ? '  ' : itemsCount.toString(),
                        fontSize: r.size(8),
                        lineHeight: 0.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ]),
              )),
      ],
    );
  }

  Widget _buildActionButtons({
    required BaseTheme theme,
    required ThemeStyle themeStyle,
    required TranslationService ts,
    required CurrencyModel currency,
    required LanguageModel language,
    required LayerLink wishlistLink,
    required LayerLink magasinLocationsLink,
    required LayerLink userLink,
    required LayerLink cartLink,
    double? gap,
    bool showNavButton = false,
  }) {
    return CustomField(
        arrangement: FieldArrangement.row,
        isRtl: language.isRtl,
        gap: gap ?? r.size(10),
        children: [
          CompositedTransformTarget(
            link: wishlistLink,
            child: CustomTooltip(
              message: ts.translate('screens.home.header.wishlist.title'),
              backgroundColor: theme.secondaryBackgroundColor,
              textColor: theme.accent.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              child: _buildActionButton(
                theme: theme,
                itemsCount: _wishlistResponse?.items?.length ?? 0,
                svgIconPath: AppPaths.vectors.heartIcon,
                onPressed: (Offset position, Size size) {
                  _wishlistDropdown.show(
                      layerLink: wishlistLink,
                      backgroundColor: theme.overlayBackgroundColor,
                      borderColor: theme.accent.withOpacity(0.4),
                      shadowColor: theme.shadowColor,
                      targetWidgetSize: size,
                      width: r.size(204),
                      dropdownAlignment: DropdownAlignment.center,
                      child: WishlistDropdown(
                        theme: theme,
                        ts: ts,
                        currency: currency,
                        isRtl: language.isRtl,
                      ));
                },
              ),
            ),
          ),
          CompositedTransformTarget(
            link: magasinLocationsLink,
            child: CustomTooltip(
              message:
                  ts.translate('screens.home.header.magasinLocations.title'),
              backgroundColor: theme.secondaryBackgroundColor,
              textColor: theme.accent.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              child: _buildActionButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.locationIcon,
                iconColor: theme.accent,
                onPressed: (Offset position, Size size) {
                  _magasinLocationsDropdown.show(
                      layerLink: magasinLocationsLink,
                      backgroundColor: theme.overlayBackgroundColor,
                      borderColor: theme.accent.withOpacity(0.4),
                      shadowColor: theme.shadowColor,
                      targetWidgetSize: size,
                      width: r.size(180),
                      dropdownAlignment: DropdownAlignment.center,
                      child: _buildMagasinLocationsDropdownChild(
                          theme: theme, ts: ts, isRtl: language.isRtl));
                },
              ),
            ),
          ),
          CompositedTransformTarget(
            link: userLink,
            child: CustomTooltip(
              message: ts.translate('Profil'),
              backgroundColor: theme.secondaryBackgroundColor,
              textColor: theme.accent.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              child: _buildActionButton(
                theme: theme,
                svgIconPath: AppPaths.vectors.profileIcon,
                iconColor: theme.accent,
                isActive:
                    PrefsUtil.containsKey(PrefsKeys.userAccessToken) == true,
                onPressed: (Offset position, Size size) {
                  _userDropdown.show(
                      layerLink: userLink,
                      backgroundColor: theme.overlayBackgroundColor,
                      borderColor: theme.accent.withOpacity(0.4),
                      shadowColor: theme.shadowColor,
                      targetWidgetSize: size,
                      width: r.size(170),
                      dropdownAlignment: language.isRtl
                          ? DropdownAlignment.start
                          : DropdownAlignment.end,
                      child: UserDropdown(
                        theme: theme,
                        themeStyle: themeStyle,
                        ts: ts,
                        isRtl: language.isRtl,
                        onDismiss: () {
                          _userDropdown.dismiss();
                        },
                        onSignInPressed: () {
                          _signInOverlay.show(
                              translationService: ts,
                              theme: theme,
                              isRtl: language.isRtl,
                              themeStyle: themeStyle);
                        },
                        onSignUpPressed: () {
                          _createAccountOverlay.show(
                            translationService: ts,
                            theme: theme,
                            isRtl: language.isRtl,
                            themeStyle: themeStyle,
                          );
                        },
                        onSignOutPressed: () {
                          RemoteEventsUtil.authEvents.signOut(context);
                        },
                      ));
                },
              ),
            ),
          ),
          CompositedTransformTarget(
            link: _cartDropdownLayerLink,
            child: CustomTooltip(
              message: ts.translate('screens.home.header.cart.title'),
              backgroundColor: theme.secondaryBackgroundColor,
              textColor: theme.accent.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              child: _buildActionButton(
                theme: theme,
                itemsCount: _cartResponse?.items?.length ?? 0,
                svgIconPath: AppPaths.vectors.cartIcon,
                iconColor: theme.accent,
                onPressed: (Offset position, Size size) {
                  _cartDropdown.show(
                      layerLink: _cartDropdownLayerLink,
                      backgroundColor: theme.overlayBackgroundColor,
                      borderColor: theme.accent.withOpacity(0.4),
                      shadowColor: theme.shadowColor,
                      targetWidgetSize: size,
                      width: r.size(204),
                      dropdownAlignment: language.isRtl
                          ? DropdownAlignment.start
                          : DropdownAlignment.end,
                      child: CartDropdown(
                        theme: theme,
                        ts: ts,
                        currency: currency,
                        isRtl: language.isRtl,
                      ));
                },
              ),
            ),
          ),
          if (showNavButton)
            _buildActionButton(
              theme: theme,
              height: r.size(16),
              svgIconPath: AppPaths.vectors.navigationIcon,
              iconColor: theme.accent,
              onPressed: (Offset position, Size size) {
                _sideNavigatorOverlay.show(
                  translationService: ts,
                  r: r,
                  theme: theme,
                  isRtl: language.isRtl,
                );
              },
            ),
        ]);
  }

  Widget _buildLargeDesktop(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    CurrencyModel currency,
    LanguageModel language,
  ) {
    return CustomField(
        width: double.infinity,
        backgroundColor: theme.primaryBackgroundColor,
        mainAxisSize: MainAxisSize.min,
        arrangement: FieldArrangement.row,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: language.isRtl,
        padding: r.symmetric(vertical: 12, horizontal: 30),
        children: [
          _buildLogoButton(themeStyle: themeStyle),
          SearchBarWidget(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            width: r.size(450),
          ),
          _buildActionButtons(
              theme: theme,
              themeStyle: themeStyle,
              ts: ts,
              currency: currency,
              language: language,
              wishlistLink: _wishlistDropdownLayerLink,
              magasinLocationsLink: _magasinLocationsDropdownLayerLink,
              userLink: _userDropdownLayerLink,
              cartLink: _cartDropdownLayerLink),
        ]);
  }

  Widget _buildDesktop(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    CurrencyModel currency,
    LanguageModel language,
  ) {
    return CustomField(
        width: double.infinity,
        backgroundColor: theme.primaryBackgroundColor,
        mainAxisSize: MainAxisSize.min,
        arrangement: FieldArrangement.row,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: language.isRtl,
        padding: r.symmetric(vertical: 12, horizontal: 20),
        children: [
          _buildLogoButton(themeStyle: themeStyle),
          SearchBarWidget(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            width: r.size(320),
          ),
          _buildActionButtons(
              theme: theme,
              themeStyle: themeStyle,
              ts: ts,
              currency: currency,
              language: language,
              wishlistLink: _wishlistDropdownLayerLink,
              magasinLocationsLink: _magasinLocationsDropdownLayerLink,
              userLink: _userDropdownLayerLink,
              cartLink: _cartDropdownLayerLink,
              gap: r.size(8)),
        ]);
  }

  Widget _buildTablet(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    CurrencyModel currency,
    LanguageModel language,
  ) {
    return CustomField(
        width: double.infinity,
        backgroundColor: theme.primaryBackgroundColor,
        mainAxisSize: MainAxisSize.min,
        arrangement: FieldArrangement.column,
        isRtl: language.isRtl,
        gap: r.size(8),
        padding: r.symmetric(vertical: 14, horizontal: 10),
        children: [
          CustomField(
              arrangement: FieldArrangement.row,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                _buildLogoButton(themeStyle: themeStyle),
                _buildActionButtons(
                    theme: theme,
                    themeStyle: themeStyle,
                    ts: ts,
                    currency: currency,
                    language: language,
                    wishlistLink: _wishlistDropdownLayerLink,
                    magasinLocationsLink: _magasinLocationsDropdownLayerLink,
                    userLink: _userDropdownLayerLink,
                    cartLink: _cartDropdownLayerLink,
                    gap: r.size(8),
                    showNavButton: true),
              ]),
          SearchBarWidget(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            width: double.infinity,
          ),
        ]);
  }

  Widget _buildMobile(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    CurrencyModel currency,
    LanguageModel language,
  ) {
    return CustomField(
        width: double.infinity,
        backgroundColor: theme.primaryBackgroundColor,
        mainAxisSize: MainAxisSize.min,
        arrangement: FieldArrangement.column,
        isRtl: language.isRtl,
        gap: r.size(8),
        padding: r.symmetric(vertical: 14, horizontal: 8),
        children: [
          CustomField(
              arrangement: FieldArrangement.row,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                _buildLogoButton(themeStyle: themeStyle),
                _buildActionButtons(
                    theme: theme,
                    themeStyle: themeStyle,
                    ts: ts,
                    currency: currency,
                    language: language,
                    wishlistLink: _wishlistDropdownLayerLink,
                    magasinLocationsLink: _magasinLocationsDropdownLayerLink,
                    userLink: _userDropdownLayerLink,
                    cartLink: _cartDropdownLayerLink,
                    gap: r.size(8),
                    showNavButton: true),
              ]),
          SearchBarWidget(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            width: double.infinity,
            isCompact: true,
          ),
        ]);
  }
}
