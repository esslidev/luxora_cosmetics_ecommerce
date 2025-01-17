import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../features/presentation/screens/home/home.dart';

class HomeLocation extends BeamLocation {
  @override
  List<Pattern> get pathPatterns => [
        AppPaths.routes.homeScreen,
        AppPaths.routes.exploreScreen,
        AppPaths.routes.boutiqueScreen,
        AppPaths.routes.productOverviewScreen,
        AppPaths.routes.editProfileScreen,
        AppPaths.routes.resetPasswordScreen,
        AppPaths.routes.checkoutScreen,
        AppPaths.routes.orderHistoryScreen,
        AppPaths.routes.orderOverviewScreen,
        AppPaths.routes.termsScreen
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    final List<BeamPage> pages = [
      const BeamPage(
          key: ValueKey('home'), title: appName, child: HomeScreen()),
    ];
    return pages;
  }
}
