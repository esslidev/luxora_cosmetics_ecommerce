import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    super.id,
    super.parentId,
    super.categoryNumber,
    super.isPublic,
    super.promoPercent,
    super.subCategories,
  });

  // Factory method to deserialize from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
