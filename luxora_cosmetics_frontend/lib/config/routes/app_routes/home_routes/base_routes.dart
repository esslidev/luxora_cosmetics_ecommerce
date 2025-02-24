import 'package:beamer/beamer.dart';

import '../../../../core/constants/app_paths.dart';
import 'base_locations/checkout_location.dart';
import 'base_locations/edit_profile_location.dart';
import 'base_locations/order_history_location.dart';
import 'base_locations/product_overview_location.dart';
import 'base_locations/boutique_location.dart';
import 'base_locations/home_page_location.dart';
import 'base_locations/reset_password_location.dart';
import 'base_locations/terms_and_conditions_location.dart';

class BaseRoutes {
  static final List<BeamLocation> _beamLocations = [
    HomePageLocation(),
    BoutiqueLocation(),
    ProductOverviewLocation(),
    EditProfileLocation(),
    ResetPasswordLocation(),
    CheckoutLocation(),
    OrderHistoryLocation(),
    TermsLocation()
  ];

  static final baseBeamerDelegate = BeamerDelegate(
      initialPath: AppPaths.routes.homePageScreen,
      transitionDelegate: const NoAnimationTransitionDelegate(),
      locationBuilder:
          BeamerLocationBuilder(beamLocations: _beamLocations).call,
      notFoundRedirectNamed: AppPaths.routes.badRoutingScreen);
}
