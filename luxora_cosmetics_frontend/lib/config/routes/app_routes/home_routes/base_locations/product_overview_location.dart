import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/base/product_overview/product_overview.dart';

class ProductOverviewLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.productOverviewScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final uri = Uri.parse(state.uri.toString());
    final String? productId = uri.queryParameters['productId'];
    final List<BeamPage> pages = [
      BeamPage(
        key: ValueKey('${AppPaths.routes.productOverviewScreen}$productId'),
        title:
            '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.productOverviewScreen)}',
        child: ProductOverviewScreen(productId: productId),
      ),
    ];
    return pages;
  }
}
