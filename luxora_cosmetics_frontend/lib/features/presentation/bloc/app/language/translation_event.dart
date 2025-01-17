import '../../../../../core/resources/language_model.dart';

abstract class AppTranslationEvent {
  const AppTranslationEvent();
}

class LoadLanguage extends AppTranslationEvent {
  final LanguageModel language;

  const LoadLanguage(this.language);
}
