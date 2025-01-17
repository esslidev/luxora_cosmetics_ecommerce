import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../core/enums/theme_style.dart';
import '../../../../../core/util/prefs_util.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(AppThemeInitial()) {
    on<ChangeTheme>(onChangeTheme);
    _initializeTheme();
  }

  void _initializeTheme() {
    final savedTheme = PrefsUtil.getString(PrefsKeys.themeStyle);
    final theme = savedTheme == ThemeStyle.dark.toString().split('.').last
        ? ThemeStyle.dark
        : ThemeStyle.light;
    add(ChangeTheme(theme));
  }

  void onChangeTheme(ChangeTheme event, Emitter<AppThemeState> emit) async {
    emit(AppThemeInitial());
    if (event.themeStyle == ThemeStyle.light) {
      emit(AppThemeChanged(AppColors.light, ThemeStyle.light));
    } else {
      emit(AppThemeChanged(AppColors.dark, ThemeStyle.dark));
    }
  }
}
