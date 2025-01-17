import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppTheme {
  // Add more text styles as needed...
  static ThemeData themeData = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'recoleta',
      scaffoldBackgroundColor: AppColors.light.primaryBackgroundColor,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.light.primary.withValues(alpha: 0.4),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
            AppColors.light.primary.withValues(alpha: 0.6)),
      ));

  static TextStyle headline = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColors.light.accent,
  );

  static TextStyle bodyText = TextStyle(
    color: AppColors.light.accent,
    fontWeight: FontWeight.w400,
  );
}
