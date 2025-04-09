import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../features/presentation/screens/base/policies/policies.dart';

class PoliciesLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.policiesScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
        key: ValueKey(AppPaths.routes.policiesScreen),
        title:
            '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.policiesScreen)}',
        child: const PoliciesScreen(),
      ),
    ];
    return pages;
  }
}
