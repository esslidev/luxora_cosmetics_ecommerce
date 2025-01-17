import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_translation.dart';

part 'category_translation.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryTranslationModel extends CategoryTranslationEntity {
  const CategoryTranslationModel({
    super.languageCode,
    super.name,
    super.isDefault,
  });

  // Factory method to deserialize from JSON
  factory CategoryTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryTranslationModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$CategoryTranslationModelToJson(this);
}
