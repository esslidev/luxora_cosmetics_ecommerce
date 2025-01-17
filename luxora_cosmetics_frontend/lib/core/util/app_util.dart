import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'translation_service.dart';

class AppUtil {
  static Size getSizeByGlobalKey(GlobalKey navigatorKey) {
    final RenderBox renderBox =
        navigatorKey.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  static String formatDateToCustomFormat(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$day/$month/$year';
  }

  static String getDiscountBadge(
      TranslationService ts, double discountPercentage) {
    if (discountPercentage >= 50) {
      return ts.translate('widgets.product.offerBadge.megaSale');
    } else if (discountPercentage >= 30) {
      return ts.translate('widgets.product.offerBadge.bigSale');
    } else if (discountPercentage >= 20) {
      return ts.translate('widgets.product.offerBadge.hotDeal');
    } else if (discountPercentage >= 10) {
      return ts.translate('widgets.product.offerBadge.saveNow');
    } else {
      return ts.translate('widgets.product.offerBadge.discount');
    }
  }

  static double calculateDiscount(double originalPrice, double promoPrice) {
    if (originalPrice <= 0) {
      throw ArgumentError('Original price must be greater than zero.');
    }
    if (promoPrice < 0) {
      throw ArgumentError('Promo price cannot be negative.');
    }
    if (promoPrice >= originalPrice) {
      throw ArgumentError(
          'Promo price should be less than the original price.');
    }
    double discount = ((originalPrice - promoPrice) / originalPrice) * 100;
    return discount;
  }

  static double calculatePricePromo(
      double originalPrice, double promoPricePercentage) {
    if (promoPricePercentage < 0 || promoPricePercentage > 100) {
      throw ArgumentError('Promo percentage must be between 0 and 100');
    }

    double discountAmount = (originalPrice * promoPricePercentage) / 100;

    double promoPrice = originalPrice - discountAmount;

    return promoPrice;
  }

  static String? returnTranslatedSymbol(
      TranslationService ts, String currencyCode) {
    switch (currencyCode) {
      case 'MAD':
        return ts.translate('global.currencies.moroccanDirham.symbol');

      case 'EUR':
        return ts.translate('global.currencies.euro.symbol');

      case 'USD':
        return ts.translate('global.currencies.usDollar.symbol');
      default:
        null;
    }
    return null;
  }

  static void scrollToTop(BuildContext context) {
    final scrollable = Scrollable.of(context); // Get the ScrollableState here
    scrollable.position.animateTo(
      0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeIn,
    );
  }

  static void jumpToTop(BuildContext context) {
    final scrollable = Scrollable.of(context); // Get the ScrollableState here
    scrollable.position.jumpTo(0); // Jump to the top position directly
  }

  static String formatCurrency(double amount, String currencyCode) {
    var format = NumberFormat.simpleCurrency(name: currencyCode);
    return format.format(amount);
  }

  static String formatToTwoDecimalPlaces(double amount) {
    final formatter =
        NumberFormat("#,##0.00", "en_US"); // Adjust locale as needed
    return formatter.format(amount);
  }

  static String capitalizeFirstLetter(String input) {
    return input.isNotEmpty
        ? input[0].toUpperCase() + input.substring(1).toLowerCase()
        : input;
  }

  static String capitalizeWords(String input) {
    if (input.isEmpty) return input;

    return input
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

  static double remap(
      double value, double from1, double to1, double from2, double to2) {
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
  }

  static bool isEmailValid(String email) {
    RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    final RegExp phoneRegExp = RegExp(
      r'^\+?[\d\s\-\(\)]{10,15}$',
    );

    // Check if the phone number matches the regex pattern
    return phoneRegExp.hasMatch(phoneNumber);
  }

  static bool isPasswordValid(String password) {
    // Check for length
    if (password.length < 8) return false;

    // Regular expressions for validation
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);

    return hasUppercase && hasLowercase && hasDigit;
  }

  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
