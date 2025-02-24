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

class VectorsPaths {
  final String logoIcon = 'assets/vectors/logo-icon.svg';
  final String informationIcon = 'assets/vectors/information-icon.svg';
  final String closeIcon = 'assets/vectors/close-icon.svg';
}

class RoutesPaths {
  // Define route paths
  final String baseScreen = '/';
  final String homePageScreen = '/page-accueil';
  final String boutiqueScreen = '/boutique';
  final String productOverviewScreen = '/aperçu-produit';
  final String editProfileScreen = '/modifier-profil';
  final String resetPasswordScreen = '/reinitialiser-mot-de-passe';
  final String checkoutScreen = '/paiement';
  final String orderHistoryScreen = '/historique-commandes';
  final String termsAndConditionsScreen = '/conditions-generales';
  final String maintenanceScreen = '/maintenance';
  final String badRoutingScreen = '/mauvaise-route';

  // Map for French route names
  final Map<String, String> routeNames = {
    '/': '',
    '/page-accueil': 'Page d\'Accueil',
    '/boutique': 'Boutique',
    '/aperçu-produit': 'Détail du Produit',
    '/modifier-profil': 'Modifier le Profil',
    '/reinitialiser-mot-de-passe': 'Réinitialiser le Mot de Passe',
    '/paiement': 'Paiement',
    '/historique-commandes': 'Historique des Commandes',
    '/aperçu-commande': 'Détail de la Commande',
    '/conditions-generales': 'Conditions Générales',
    '/maintenance': 'Maintenance',
    '/mauvaise-route': 'Page Introuvable',
  };

  // Method to get the French route name
  String getRouteName(String route) => routeNames[route] ?? 'Route Inconnue';
}
