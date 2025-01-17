import 'package:equatable/equatable.dart';

import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/translation_service.dart';

abstract class AppTranslationState extends Equatable {
  final TranslationService? translationService;
  final LanguageModel? language;
  final String? error;
  const AppTranslationState(
      {this.translationService, this.language, this.error});

  @override
  List<Object?> get props => [translationService, language, error];
}

class AppTranslationInitial extends AppTranslationState {
  // Pass a default value or handle as needed.
  const AppTranslationInitial();
}

class AppTranslationLoaded extends AppTranslationState {
  const AppTranslationLoaded(
      TranslationService translationService, LanguageModel language)
      : super(translationService: translationService, language: language);
}

class AppTranslationError extends AppTranslationState {
  const AppTranslationError(String? error) : super(error: error);
}
