import 'package:beamer/beamer.dart';

import '../../../../core/constants/app_paths.dart';
import 'home_locations/checkout_location.dart';
import 'home_locations/edit_profile_location.dart';
import 'home_locations/order_history_location.dart';
import 'home_locations/order_overview_location.dart';
import 'home_locations/product_overview_location.dart';
import 'home_locations/boutique_location.dart';
import 'home_locations/explore_location.dart';
import 'home_locations/reset_password_location.dart';
import 'home_locations/terms_location.dart';

class HomeRoutes {
  static final List<BeamLocation> _beamLocations = [
    ExploreLocation(),
    BoutiqueLocation(),
    ProductOverviewLocation(),
    EditProfileLocation(),
    ResetPasswordLocation(),
    CheckoutLocation(),
    OrderHistoryLocation(),
    OrderOverviewLocation(),
    TermsLocation()
  ];

  static final homeBeamerDelegate = BeamerDelegate(
      initialPath: AppPaths.routes.exploreScreen,
      transitionDelegate: const NoAnimationTransitionDelegate(),
      locationBuilder:
          BeamerLocationBuilder(beamLocations: _beamLocations).call,
      notFoundRedirectNamed: AppPaths.routes.badRoutingScreen);
}
