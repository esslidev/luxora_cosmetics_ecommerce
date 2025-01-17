import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../features/presentation/screens/bad_routing/bad_routing.dart';

class BadRoutingLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.badRoutingScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.badRoutingScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.badRoutingScreen)}',
          child: const BadRoutingScreen()),
    ];
    return pages;
  }
}
