//import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/prefs_util.dart';
import '../../../../../core/util/translation_service.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class AppTranslationBloc
    extends Bloc<AppTranslationEvent, AppTranslationState> {
  AppTranslationBloc() : super(const AppTranslationInitial()) {
    on<LoadLanguage>(onLoadLanguage);
    // Trigger loading the language when the Bloc is first initialized.
    _initializeTranslationService();
  }

  /// Initialize the translation service by loading the saved language code
  /// or falling back to the system's default locale.
  void _initializeTranslationService() {
    /*final savedLanguageCode = PrefsUtil.getString(PrefsKeys.languageCode);
    final languageCode = savedLanguageCode ??
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;*/

    // Add an event to load the language
    add(LoadLanguage(LanguageModel.fromCode('fr')));
  }

  /// Event handler for loading a new language
  void onLoadLanguage(
      LoadLanguage event, Emitter<AppTranslationState> emit) async {
    emit(const AppTranslationInitial());

    try {
      // Load the translations asynchronously
      final translationService =
          await TranslationService.load(event.language.languageCode);
      PrefsUtil.setString(PrefsKeys.languageCode, event.language.languageCode);
      // Emit the loaded state
      emit(AppTranslationLoaded(
        translationService,
        event.language,
      ));
    } catch (e) {
      // Handle any errors during the loading process
      emit(const AppTranslationError('Failed to load language.'));
    }
  }
}
