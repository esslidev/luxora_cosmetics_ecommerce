import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/base/home_page/home_page.dart';

class HomePageLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.homePageScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.homePageScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.homePageScreen)}',
          child: const HomePageScreen()),
    ];
    return pages;
  }
}
