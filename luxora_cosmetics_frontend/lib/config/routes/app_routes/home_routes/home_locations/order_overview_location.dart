import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/home/order_overview/order_overview.dart';

class OrderOverviewLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.orderOverviewScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.orderOverviewScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.orderOverviewScreen)}',
          child: const OrderOverviewScreen()),
    ];
    return pages;
  }
}
