import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';

class TermsLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.termsScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.termsScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.termsScreen)}',
          child: const TermsScreen()),
    ];
    return pages;
  }
}
