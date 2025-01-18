import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/review.dart';

part 'review.g.dart';

@JsonSerializable()
class ReviewModel extends ReviewEntity {
  const ReviewModel({
    super.id,
    super.productId,
    super.userId,
    super.text,
    super.rating,
    super.isPublic,
    super.user,
    super.product,
    super.createdAt,
    super.updatedAt,
  });

  // Factory method to deserialize from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
