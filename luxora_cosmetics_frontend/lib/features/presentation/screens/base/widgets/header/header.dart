import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';

import '../../../../../../core/constants/app_paths.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/resources/global_contexts.dart';
import '../../../../../../core/util/app_events_util.dart';
import '../../../../../../core/util/remote_events_util.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../locator.dart';
import '../../../../../data/models/cart_item.dart';
import '../../../../../data/models/wishlist_item.dart';
import '../../../../overlays/create_account/create_account.dart';
import '../../../../overlays/dropdown/dropdown.dart';
import '../../../../overlays/sidebar/sidebar.dart';
import '../../../../overlays/sign_in/sign_in.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_display.dart';
import '../../../../widgets/common/custom_text.dart';
import 'widgets/cart_dropdown.dart';
import 'widgets/profile_dropdown.dart';
import 'widgets/wishlist_dropdown.dart';

class HeaderWidget extends StatefulWidget {
  final List<WishlistItemModel> wishlistItems;
  final bool isUserSignedIn;
  final List<CartItemModel> cartItems;
  const HeaderWidget({
    super.key,
    required this.wishlistItems,
    this.isUserSignedIn = false,
    required this.cartItems,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  final LayerLink _wishlistDropdownLayerLink = LayerLink();
  final LayerLink _profileDropdownLayerLink = LayerLink();
  final LayerLink _cartDropdownLayerLink = LayerLink();

  late SignInOverlay _signInOverlay;
  late CreateAccountOverlay _createAccountOverlay;
  late SidebarOverlay _sidebarOverlay;

  late DropdownOverlay _wishlistDropdown;
  late DropdownOverlay _profileDropdown;
  late DropdownOverlay _cartDropdown;
  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppEventsUtil.breadCrumbs.clearBreadCrumbs(context);

      _signInOverlay = SignInOverlay(context: homeContext!, r: r);
      _createAccountOverlay = CreateAccountOverlay(context: homeContext!, r: r);
      _sidebarOverlay = SidebarOverlay(context: homeContext!);

      _wishlistDropdown = _buildActionButtonsDropdown();
      _profileDropdown = _buildActionButtonsDropdown();
      _cartDropdown = _buildActionButtonsDropdown();
    });
  }

  //----------------------------------------------------------------------------------------------------//

  DropdownOverlay _buildActionButtonsDropdown() {
    return DropdownOverlay(
      context: context,
      borderRadius: Radius.circular(r.size(1)),
      margin: EdgeInsets.only(top: r.size(8)),
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
    );
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildLogoButton({double? height}) {
    return CustomDisplay(
      assetPath: AppPaths.images.logo,
      height: height ?? r.size(32),
      onPressed: () {
        Beamer.of(context).beamToNamed(AppPaths.routes.homePageScreen);
      },
    );
  }

  Widget _buildNavButton({required String name, required String path}) {
    return CustomButton(
      text: name,
      fontSize: r.size(9),
      fontWeight: FontWeight.w500,
      textColor: AppColors.colors.jetGrey,
      animationDuration: 200.ms,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      onHoverStyle: CustomButtonStyle(textColor: AppColors.light.primary),
      onPressed: (position, size) {
        Beamer.of(context).beamToNamed(path);
      },
    );
  }

  Widget _buildNavButtons() {
    return CustomField(
      gap: r.size(24),
      arrangement: FieldArrangement.row,
      children: [
        _buildNavButton(name: 'Produits', path: AppPaths.routes.boutiqueScreen),
        _buildNavButton(name: 'À propos', path: AppPaths.routes.boutiqueScreen),
        _buildNavButton(name: 'Blog', path: AppPaths.routes.boutiqueScreen),
        _buildNavButton(name: 'Avis', path: AppPaths.routes.boutiqueScreen),
      ],
    );
  }

  Widget _buildActionButton({
    required String svgIconPath,
    int? itemsLength,
    bool? isActive,
    required Function(Offset position, Size size)? onPressed,
  }) {
    return Stack(
      children: [
        CustomButton(
          height: r.size(24),
          width: r.size(24),
          svgIconPath: svgIconPath,
          iconWidth: r.size(9),
          iconHeight: r.size(9),
          iconColor: AppColors.colors.white,
          backgroundColor: AppColors.colors.jetGrey,
          borderRadius: BorderRadius.circular(r.size(15)),
          animationDuration: 200.ms,
          margin: r.all(3),
          onHoverStyle: CustomButtonStyle(
            backgroundColor: AppColors.light.primary,
          ),
          onPressed: onPressed,
        ),
        if (itemsLength != null)
          Positioned(
            right: 0,
            top: 0,
            child: IgnorePointer(
              ignoring: true,
              child: CustomField(
                backgroundColor: AppColors.colors.hotPepperGreen,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                borderWidth: r.size(0.6),
                borderColor: AppColors.light.backgroundPrimary,
                borderRadius: r.size(6),
                padding: r.all(3),
                children: [
                  CustomText(
                    text: itemsLength.toString(),
                    color: AppColors.colors.white,
                    fontSize: r.size(6),
                    lineHeight: 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          )
        else if (isActive == true)
          Positioned(
            right: 0,
            top: 0,
            child: IgnorePointer(
              ignoring: true,
              child: CustomField(
                width: r.size(6),
                height: r.size(6),
                borderRadius: r.size(3),
                backgroundColor: AppColors.colors.hotPepperGreen,
                children: const [],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons({
    required LayerLink wishlistLink,
    required LayerLink profileLink,
    required LayerLink cartLink,
  }) {
    return CustomField(
      arrangement: FieldArrangement.row,
      gap: r.size(10),
      children: [
        CompositedTransformTarget(
          link: wishlistLink,
          child: _buildActionButton(
            itemsLength: widget.wishlistItems.length,
            svgIconPath: AppPaths.vectors.wishlistIcon,
            onPressed: (Offset position, Size size) {
              _wishlistDropdown.show(
                layerLink: wishlistLink,
                targetWidgetSize: size,
                width: r.size(204),
                dropdownAlignment: DropdownAlignment.center,
                child: WishlistDropdown(),
              );
            },
          ),
        ),
        CompositedTransformTarget(
          link: profileLink,
          child: _buildActionButton(
            svgIconPath: AppPaths.vectors.profileIcon,
            isActive: widget.isUserSignedIn,
            onPressed: (Offset position, Size size) {
              _profileDropdown.show(
                layerLink: profileLink,
                targetWidgetSize: size,
                shadowColor: AppColors.light.accent.withValues(alpha: .2),
                width: r.size(170),
                dropdownAlignment: DropdownAlignment.end,
                child: ProfileDropdown(
                  onSignInPressed: () {
                    _signInOverlay.show();
                  },
                  onSignUpPressed: () {
                    _createAccountOverlay.show();
                  },
                  onSignOutPressed: () {
                    RemoteEventsUtil.authEvents.signOut(context);
                  },
                ),
              );
            },
          ),
        ),
        CompositedTransformTarget(
          link: cartLink,
          child: _buildActionButton(
            itemsLength: widget.cartItems.length,
            svgIconPath: AppPaths.vectors.cartIcon,
            onPressed: (Offset position, Size size) {
              _cartDropdown.show(
                layerLink: wishlistLink,
                targetWidgetSize: size,
                width: r.size(204),
                dropdownAlignment: DropdownAlignment.center,
                child: CartDropdown(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSideBarButton() {
    return CustomButton(
      backgroundColor: Colors.white,
      padding: r.all(8),
      svgIconPath: AppPaths.vectors.sidebarIcon,
      iconHeight: r.size(9),
      iconWidth: r.size(9),
      onPressed: (position, size) {
        _sidebarOverlay.show(r: r);
      },
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    bool? isDesktopScreen,
    bool? isTabletMobileScreen,
  }) {
    return CustomField(
      padding: r.symmetric(
        vertical: 12,
        horizontal:
            isTabletMobileScreen == true
                ? 10
                : isDesktopScreen == true
                ? 30
                : 140,
      ),
      margin: r.only(bottom: r.size(12)),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        _buildLogoButton(),
        CustomField(
          gap: r.size(24),
          crossAxisAlignment: CrossAxisAlignment.center,
          arrangement: FieldArrangement.row,
          children: [
            if (isTabletMobileScreen != true) _buildNavButtons(),
            if (isTabletMobileScreen != true)
              _buildActionButtons(
                wishlistLink: _wishlistDropdownLayerLink,
                profileLink: _profileDropdownLayerLink,
                cartLink: _cartDropdownLayerLink,
              ),
            if (isTabletMobileScreen == true) _buildSideBarButton(),
          ],
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildHeader(context),
      screenDesktop: _buildHeader(context, isDesktopScreen: true),
      screenTablet: _buildHeader(context, isTabletMobileScreen: true),
      screenMobile: _buildHeader(context, isTabletMobileScreen: true),
    );
  }
}
