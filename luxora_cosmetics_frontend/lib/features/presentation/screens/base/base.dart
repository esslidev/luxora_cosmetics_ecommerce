import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';

import '../../../../../core/util/app_events_util.dart';
import '../../../../config/routes/app_routes/home_routes/base_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/resources/global_contexts.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../../locator.dart';
import '../../../data/models/cart_item.dart';
import '../../../data/models/wishlist_item.dart';
import '../../overlays/loading/loading.dart';
import 'widgets/footer/footer.dart';
import 'widgets/header/header.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late ResponsiveSizeAdapter r;

  List<WishlistItemModel> _wishlistItemsResponse = [];
  List<CartItemModel> _cartItemsResponse = [];

  late LoadingOverlay _loadingOverlay;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    locator<GlobalContexts>().setHomeContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadingOverlay = LoadingOverlay(context: context, r: r);
      AppEventsUtil.breadCrumbs.clearBreadCrumbs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light.backgroundPrimary,
      body: _buildHome(context),
    );
  }

  Widget _buildHome(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: CustomField(
        minHeight: screenSize.height,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomField(
            children: [
              HeaderWidget(
                wishlistItems: _wishlistItemsResponse,
                cartItems: _cartItemsResponse,
              ),
              Beamer(
                routerDelegate: BaseRoutes.baseBeamerDelegate,
                backButtonDispatcher: BeamerBackButtonDispatcher(
                  delegate: BaseRoutes.baseBeamerDelegate,
                ),
              ),
            ],
          ),
          FooterWidget(),
        ],
      ),
    );
  }
}
