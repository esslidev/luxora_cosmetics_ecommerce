import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/pagination.dart';

part 'pagination.g.dart';

@JsonSerializable()
class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.total,
    required super.page,
    required super.pages,
  });

  // Factory method to deserialize from JSON
  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
