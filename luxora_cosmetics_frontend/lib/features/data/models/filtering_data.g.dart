// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtering_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilteringDataModel _$FilteringDataModelFromJson(Map<String, dynamic> json) =>
    FilteringDataModel(
      inStockCount: (json['inStockCount'] as num?)?.toInt(),
      preorderCount: (json['preorderCount'] as num?)?.toInt(),
      publishedCount: (json['publishedCount'] as num?)?.toInt(),
      publishedPast6MonthsCount:
          (json['publishedPast6MonthsCount'] as num?)?.toInt(),
      publishedWithin3MonthsCount:
          (json['publishedWithin3MonthsCount'] as num?)?.toInt(),
      paperbackFormatCount: (json['paperbackFormatCount'] as num?)?.toInt(),
      grandFormatCount: (json['grandFormatCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FilteringDataModelToJson(FilteringDataModel instance) =>
    <String, dynamic>{
      'inStockCount': instance.inStockCount,
      'preorderCount': instance.preorderCount,
      'publishedCount': instance.publishedCount,
      'publishedPast6MonthsCount': instance.publishedPast6MonthsCount,
      'publishedWithin3MonthsCount': instance.publishedWithin3MonthsCount,
      'paperbackFormatCount': instance.paperbackFormatCount,
      'grandFormatCount': instance.grandFormatCount,
    };
