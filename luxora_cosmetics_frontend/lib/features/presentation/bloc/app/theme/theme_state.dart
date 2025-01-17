import 'package:equatable/equatable.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/theme_style.dart';

abstract class AppThemeState extends Equatable {
  final BaseTheme theme;
  final ThemeStyle themeStyle;
  const AppThemeState({required this.theme, required this.themeStyle});

  @override
  List<Object?> get props => [theme, themeStyle];
}

class AppThemeInitial extends AppThemeState {
  AppThemeInitial()
      : super(theme: AppColors.light, themeStyle: ThemeStyle.light);
}

class AppThemeChanged extends AppThemeState {
  const AppThemeChanged(BaseTheme theme, ThemeStyle themeStyle)
      : super(theme: theme, themeStyle: themeStyle);
}
