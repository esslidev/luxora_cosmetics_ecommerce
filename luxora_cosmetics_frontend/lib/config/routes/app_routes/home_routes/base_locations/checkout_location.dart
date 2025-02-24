import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/base/checkout/checkout.dart';

class CheckoutLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.checkoutScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final uri = Uri.parse(state.uri.toString());
    final String? productIds = uri.queryParameters['productIds'];
    final bool isDelivered = uri.queryParameters['isDelivered'] == 'true';
    final bool isCart = uri.queryParameters['isCart'] == 'true';
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(
              '${AppPaths.routes.checkoutScreen}$productIds$isDelivered$isCart'),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.checkoutScreen)}',
          child: CheckoutScreen()),
    ];
    return pages;
  }
}
