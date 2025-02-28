import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  static final GlobalColors colors = GlobalColors();
  static final LightTheme light = LightTheme();
}

class GlobalColors {
  // Global colors
  final Color white = const Color(0xFFFFFFFF);
  final Color whitest = const Color(0xFFFAF7F5);
  final Color spearmint = const Color(0xFFE7F0E3);
  final Color snowGreen = const Color(0xFFC7D8C0);
  final Color jetGrey = const Color(0xFF565655);
  final Color lostInSadness = const Color(0xFF19183A);
  final Color pecanBrown = const Color(0xFFCC9562);
  final Color fruitRed = const Color(0xFFF6866A);
  final Color pimentoRed = const Color(0xFFFF6944);
  final Color peachOfMind = const Color(0xFFFFE2B3);
  final Color hotPepperGreen = const Color(0xFF8FB17F);
}

abstract class BaseTheme {
  Color get accent;
  Color get subtle;
  Color get primary;
  Color get secondary;
  Color get backgroundPrimary;
  Color get backgroundSecondary;
  Color get success;
  Color get warning;
  Color get error;
}

class LightTheme extends BaseTheme {
  @override
  final Color accent = AppColors.colors.lostInSadness;
  @override
  final Color subtle = AppColors.colors.white;
  @override
  final Color primary = AppColors.colors.pecanBrown;
  @override
  final Color secondary = AppColors.colors.fruitRed;
  @override
  final Color backgroundPrimary = AppColors.colors.whitest;
  @override
  final Color backgroundSecondary = AppColors.colors.spearmint;
  @override
  final Color success = AppColors.colors.hotPepperGreen;
  @override
  final Color warning = AppColors.colors.peachOfMind;
  @override
  final Color error = AppColors.colors.pimentoRed;
}
