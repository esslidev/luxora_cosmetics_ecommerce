// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryTranslationModel _$CategoryTranslationModelFromJson(
        Map<String, dynamic> json) =>
    CategoryTranslationModel(
      languageCode: json['languageCode'] as String?,
      name: json['name'] as String?,
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$CategoryTranslationModelToJson(
        CategoryTranslationModel instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'name': instance.name,
      'isDefault': instance.isDefault,
    };
