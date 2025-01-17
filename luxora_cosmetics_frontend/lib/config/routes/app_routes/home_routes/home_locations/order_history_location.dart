import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/home/order_history/order_history.dart';

class OrderHistoryLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.orderHistoryScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.orderHistoryScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.orderHistoryScreen)}',
          child: const OrderHistoryScreen()),
    ];
    return pages;
  }
}
