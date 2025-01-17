import 'package:equatable/equatable.dart';

class CategoryTranslationEntity extends Equatable {
  final String? languageCode;
  final String? name;
  final bool? isDefault;

  const CategoryTranslationEntity({
    this.languageCode,
    this.name,
    this.isDefault,
  });

  @override
  List<Object?> get props => [
        languageCode,
        name,
        isDefault,
      ];
}
