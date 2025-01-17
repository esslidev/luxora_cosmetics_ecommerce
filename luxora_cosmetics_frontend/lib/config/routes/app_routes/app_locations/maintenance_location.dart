import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../features/presentation/screens/maintenance/maintenance.dart';

class MaintenanceLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [AppPaths.routes.maintenanceScreen];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> pages = [
      BeamPage(
          key: ValueKey(AppPaths.routes.maintenanceScreen),
          title:
              '$appName | ${AppPaths.routes.getRouteName(AppPaths.routes.maintenanceScreen)}',
          child: const MaintenanceScreen()),
    ];
    return pages;
  }
}
