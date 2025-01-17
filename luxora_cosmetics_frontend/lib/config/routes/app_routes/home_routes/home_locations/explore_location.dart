import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/home/explore/explore.dart';

class ExploreLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.exploreScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.exploreScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.exploreScreen)}',
          child: const ExploreScreen()),
    ];
    return pages;
  }
}
