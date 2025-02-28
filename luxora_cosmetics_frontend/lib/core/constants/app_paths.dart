class AppPaths {
  static FilesPaths get files => FilesPaths();

  static IconsPaths get icons => IconsPaths();

  static ImagesPaths get images => ImagesPaths();

  static AnimatedImagesPaths get animatedImages => AnimatedImagesPaths();

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
  final String logoDark = 'assets/images/logo-dark.png';
  final String joinUsImage1 = 'assets/images/join-us-image1.webp';
  final String joinUsImage2 = 'assets/images/join-us-image2.webp';
  final String joinUsImage3 = 'assets/images/join-us-image3.jpg';
  final String rediscoverBannerImage =
      'assets/images/rediscover-banner-image.webp';
  final String rediscoverBannerTitleImage =
      'assets/images/rediscover-banner-title-image.webp';
  final String missionVisionBannerImage =
      'assets/images/mission-vision-banner-image.webp';
  final String product1Image = 'assets/images/product1-image.webp';
  final String product2Image = 'assets/images/product2-image.webp';
  final String product3Image = 'assets/images/product3-image.webp';
  final String product4Image = 'assets/images/product4-image.webp';
  final String product5Image = 'assets/images/product5-image.webp';
  final String calvinKleinBrandImage =
      'assets/images/calvin-klein-brand-image.png';
  final String aloeVeraBrandImage = 'assets/images/aloe-vera-brand-image.png';
  final String barioneBrandImage = 'assets/images/barione-brand-image.png';
  final String farmesiBrandImage = 'assets/images/farmesi-brand-image.png';
  final String vaoodaBrandImage = 'assets/images/vaooda-brand-image.png';
  final String testimonialCustomerImage =
      'assets/images/testimonial-customer-image.png';
  final String milestonesImage = 'assets/images/milestones-image.webp';
}

class AnimatedImagesPaths {
  final String promoVideosShortVideo =
      'assets/animated_images/promo-videos-short-video.webp';
}

class VectorsPaths {
  final String logo = 'assets/vectors/logo.svg';
  final String wishlistIcon = 'assets/vectors/wishlist-icon.svg';
  final String profileIcon = 'assets/vectors/profile-icon.svg';
  final String cartIcon = 'assets/vectors/cart-icon.svg';
  final String facebookIcon = 'assets/vectors/facebook-icon.svg';
  final String instagramIcon = 'assets/vectors/instagram-icon.svg';
  final String twitterIcon = 'assets/vectors/twitter-icon.svg';
  final String linkdinIcon = 'assets/vectors/linkdin-icon.svg';
  final String arrowToRightIcon = 'assets/vectors/arrow-to-right-icon.svg';
  final String arrowToBottomIconStyle2 =
      'assets/vectors/arrow-to-bottom-icon-style2.svg';
  final String branchDecoration1 = 'assets/vectors/branch-decoration1.svg';
  final String branchDecoration2 = 'assets/vectors/branch-decoration2.svg';
  final String missionVisionBannerRoundedText =
      'assets/vectors/mission-vision-banner-rounded-text.svg';
  final String promoVideosPlayButtonIcon =
      'assets/vectors/promo-videos-play-button-icon.svg';
  final String quoteIcon = 'assets/vectors/quote-icon.svg';
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
