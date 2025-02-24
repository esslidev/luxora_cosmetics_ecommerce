import 'package:beamer/beamer.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_paths.dart';
import '../../../core/constants/shared_preference_keys.dart';
import '../../../core/util/prefs_util.dart';
import 'app_locations/bad_routing_location.dart';
import 'app_locations/base_location.dart';
import 'app_locations/maintenance_location.dart';

class AppRoutes {
  static final List<BeamLocation> _beamLocations = [
    HomeLocation(),
    BadRoutingLocation(),
    MaintenanceLocation()
  ];

  static final appBeamerDelegate = BeamerDelegate(
    initialPath: AppPaths.routes.homePageScreen,
    transitionDelegate: const NoAnimationTransitionDelegate(),
    guards: [
      BeamGuard(
        pathPatterns: ['/*'],
        check: (context, location) => onMaintenance == false,
        beamToNamed: (_, __) => AppPaths.routes.maintenanceScreen,
      ),
      BeamGuard(
        pathPatterns: [AppPaths.routes.editProfileScreen],
        check: (context, location) =>
            PrefsUtil.containsKey(PrefsKeys.userAccessToken) == true,
        beamToNamed: (_, __) => AppPaths.routes.homePageScreen,
      ),
      BeamGuard(
        pathPatterns: [AppPaths.routes.orderHistoryScreen],
        check: (context, location) =>
            PrefsUtil.containsKey(PrefsKeys.userAccessToken) == true,
        beamToNamed: (_, __) => AppPaths.routes.homePageScreen,
      ),
      BeamGuard(
        pathPatterns: [AppPaths.routes.checkoutScreen],
        check: (context, location) =>
            PrefsUtil.containsKey(PrefsKeys.userAccessToken) == true,
        beamToNamed: (_, __) => AppPaths.routes.homePageScreen,
      ),
    ],
    locationBuilder: BeamerLocationBuilder(beamLocations: _beamLocations).call,
    notFoundRedirectNamed: AppPaths.routes.badRoutingScreen,
  );
}
