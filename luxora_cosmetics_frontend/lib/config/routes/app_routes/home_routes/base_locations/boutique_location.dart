import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/base/boutique/boutique.dart';

class BoutiqueLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.boutiqueScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.boutiqueScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.boutiqueScreen)}',
          child: const BoutiqueScreen()),
    ];
    return pages;
  }
}
