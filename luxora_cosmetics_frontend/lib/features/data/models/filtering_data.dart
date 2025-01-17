import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/filtering_data.dart';

part 'filtering_data.g.dart';

@JsonSerializable()
class FilteringDataModel extends FilteringDataEntity {
  const FilteringDataModel({
    required super.inStockCount,
    required super.preorderCount,
    required super.publishedCount,
    required super.publishedPast6MonthsCount,
    required super.publishedWithin3MonthsCount,
    required super.paperbackFormatCount,
    required super.grandFormatCount,
  });

  // Factory method to deserialize from JSON
  factory FilteringDataModel.fromJson(Map<String, dynamic> json) =>
      _$FilteringDataModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$FilteringDataModelToJson(this);
}
