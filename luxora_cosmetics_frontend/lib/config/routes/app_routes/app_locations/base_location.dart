import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../features/presentation/screens/base/base.dart';

class HomeLocation extends BeamLocation {
  @override
  List<Pattern> get pathPatterns => [
    AppPaths.routes.baseScreen,
    AppPaths.routes.homePageScreen,
    AppPaths.routes.boutiqueScreen,
    AppPaths.routes.contactScreen,
    AppPaths.routes.productOverviewScreen,
    AppPaths.routes.editProfileScreen,
    AppPaths.routes.resetPasswordScreen,
    AppPaths.routes.checkoutScreen,
    AppPaths.routes.orderHistoryScreen,
    AppPaths.routes.policiesScreen,
  ];

  @override
  List<BeamPage> buildPages(
    BuildContext context,
    RouteInformationSerializable state,
  ) {
    final List<BeamPage> pages = [
      const BeamPage(
        key: ValueKey('base'),
        title: appName,
        child: BaseScreen(),
      ),
    ];
    return pages;
  }
}
