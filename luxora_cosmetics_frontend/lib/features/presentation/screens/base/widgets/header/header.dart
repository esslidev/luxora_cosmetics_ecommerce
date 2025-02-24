import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';

import '../../../../../../core/constants/app_paths.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/resources/global_contexts.dart';
import '../../../../../../core/util/app_events_util.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../locator.dart';
import '../../../../../data/models/cart_item.dart';
import '../../../../../data/models/wishlist_item.dart';
import '../../../../overlays/create_account/create_account.dart';
import '../../../../overlays/dropdown/dropdown.dart';
import '../../../../overlays/sign_in/sign_in.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_display.dart';
import '../../../../widgets/common/custom_text.dart';

class HeaderWidget extends StatefulWidget {
  final List<WishlistItemModel> wishlistItems;
  final List<CartItemModel> cartItems;
  const HeaderWidget(
      {super.key, required this.wishlistItems, required this.cartItems});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  final LayerLink _wishlistDropdownLayerLink = LayerLink();
  final LayerLink _userDropdownLayerLink = LayerLink();
  final LayerLink _cartDropdownLayerLink = LayerLink();

  late SignInOverlay _signInOverlay;
  late CreateAccountOverlay _createAccountOverlay;

  late DropdownOverlay _wishlistDropdown;
  late DropdownOverlay _userDropdown;
  late DropdownOverlay _cartDropdown;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppEventsUtil.breadCrumbs.clearBreadCrumbs(
        context,
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
      _userDropdown = _buildActionButtonsDropdown();
      _cartDropdown = _buildActionButtonsDropdown();
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

  //----------------------------------------------------------------------------------------------------//

  Widget _buildLogoButton({double? height}) {
    return CustomDisplay(
      assetPath: AppPaths.vectors.closeIcon,
      isSvg: true,
      height: height ?? r.size(42),
      onTap: () {
        Beamer.of(context).beamToNamed(
          AppPaths.routes.homePageScreen,
        );
      },
      cursor: SystemMouseCursors.click,
    );
  }

  Widget _buildActionButton(
      {double? width,
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
                        ? AppColors.light.primary
                        : AppColors.light.primary,
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

  Widget _buildHeader(BuildContext context, {bool? isCompact}) {
    return CustomField(
      padding: r.symmetric(vertical: 12, horizontal: 30),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        _buildLogoButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildHeader(context),
    );
  }
}
