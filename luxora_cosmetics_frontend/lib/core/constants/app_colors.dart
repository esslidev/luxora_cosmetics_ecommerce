import 'package:flutter/material.dart';

class AppColors {
  static GlobalColors get colors => GlobalColors();
  static LightTheme get light => LightTheme();
}

class GlobalColors {
  // Global colors
  final Color white = const Color(0xFFFFFFFF);
  final Color whiteWhitest = const Color(0xFFFAF7F5);
  final Color greenSpearmintStick = const Color(0xFFE7F0E3);
  final Color blackLostInSadness = const Color(0xFF19183A);
  final Color brownGlazedPecan = const Color(0xFFCC9562);
  final Color redFruit = const Color(0xFFF6866A);
  final Color redSweetPimento = const Color(0xFFFF6944);
  final Color yellowVanillaPudding = const Color(0xFFF6E66A);
  final Color greenSageSensation = const Color(0xFFB0E997);
}

abstract class BaseTheme {
  Color get accent;
  Color get subtle;
  Color get primary;
  Color get secondary;
  Color get primaryBackgroundColor;
  Color get secondaryBackgroundColor;
  Color get successColor;
  Color get warningColor;
  Color get errorColor;
}

class LightTheme extends BaseTheme {
  @override
  final Color accent = AppColors.colors.blackLostInSadness;
  @override
  final Color subtle = AppColors.colors.white;
  @override
  final Color primary = AppColors.colors.brownGlazedPecan;
  @override
  final Color secondary = AppColors.colors.redFruit;
  @override
  final Color primaryBackgroundColor = AppColors.colors.whiteWhitest;
  @override
  final Color secondaryBackgroundColor = AppColors.colors.greenSpearmintStick;
  @override
  final Color successColor = AppColors.colors.greenSageSensation;
  @override
  final Color warningColor = AppColors.colors.yellowVanillaPudding;
  @override
  final Color errorColor = AppColors.colors.redSweetPimento;
}
