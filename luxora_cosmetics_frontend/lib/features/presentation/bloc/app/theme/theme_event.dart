import '../../../../../core/enums/theme_style.dart';

abstract class AppThemeEvent {
  const AppThemeEvent();
}

class ChangeTheme extends AppThemeEvent {
  final ThemeStyle themeStyle;

  const ChangeTheme(this.themeStyle);
}
