class AppPaths {
  static FilesPaths get files => FilesPaths();

  static IconsPaths get icons => IconsPaths();

  static ImagesPaths get images => ImagesPaths();

  static VectorsPaths get vectors => VectorsPaths();

  static RoutesPaths get routes => RoutesPaths();
}

class FilesPaths {
  LottiePaths get lottie => LottiePaths();
}

class LottiePaths {
  final String badRouting = 'assets/files/lottie/bad-routing.json';
  final String loading = 'assets/files/lottie/book-loading.json';
  final String maintenance = 'assets/files/lottie/maintenance.json';
  final String success = 'assets/files/lottie/success.json';
  final String warning = 'assets/files/lottie/warning.json';
  final String error = 'assets/files/lottie/error.json';
}

class IconsPaths {
  final String favIcon = 'assets/icons/favicon.png';
  final String icon = 'assets/icons/icon.png';
}

class ImagesPaths {
  final String logo = 'assets/images/logo.png';
}

class VectorsPaths {}

class RoutesPaths {
  // Define route paths
  final String homeScreen = '/';
  final String exploreScreen = '/explore';
  final String boutiqueScreen = '/boutique';
  final String productOverviewScreen = '/product-overview';
  final String editProfileScreen = '/edit-profile';
  final String resetPasswordScreen = '/reset-password';
  final String checkoutScreen = '/checkout';
  final String orderHistoryScreen = '/order-history';
  final String orderOverviewScreen = '/order-overview';
  final String termsScreen = '/terms';
  final String maintenanceScreen = '/maintenance';
  final String badRoutingScreen = '/bad-routing';

  // Map for French route names
  final Map<String, String> routeNames = {
    '/': '',
    '/explore': 'Explorer',
    '/boutique': 'Boutique',
    '/product-overview': 'Détail du Produit',
    '/edit-profile': 'Modifier le Profil',
    '/reset-password': 'Réinitialiser le Mot de Passe',
    '/checkout': 'Paiement',
    '/order-history': 'Historique des Commandes',
    '/order-overview': 'Détail de la Commande',
    '/terms': 'Conditions Générales',
    '/maintenance': 'Maintenance',
    '/bad-routing': 'Page Introuvable',
  };

  // Method to get the French route name
  String getRouteName(String route) => routeNames[route] ?? 'Route Inconnue';
}
