import 'package:equatable/equatable.dart';

class SystemMessageTranslationEntity extends Equatable {
  final String? languageCode;
  final String? message;

  const SystemMessageTranslationEntity({
    this.languageCode,
    this.message,
  });

  @override
  List<Object?> get props => [languageCode, message];
}
