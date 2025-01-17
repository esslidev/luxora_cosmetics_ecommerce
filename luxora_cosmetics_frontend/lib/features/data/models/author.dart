import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/author.dart';
import 'product.dart';

part 'author.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthorModel extends AuthorEntity {
  const AuthorModel(
      {super.id,
      super.firstName,
      super.lastName,
      super.coverImageUrl,
      super.authorOfMonth,
      super.featuredAuthor,
      super.products});

  // Factory method to deserialize from JSON
  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}
