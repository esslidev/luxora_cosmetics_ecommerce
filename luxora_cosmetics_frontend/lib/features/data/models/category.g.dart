// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: (json['id'] as num?)?.toInt(),
      parentId: (json['parentId'] as num?)?.toInt(),
      categoryNumber: (json['categoryNumber'] as num?)?.toInt(),
      isPublic: json['isPublic'] as bool?,
      promoPercent: (json['promoPercent'] as num?)?.toInt(),
      subCategories: (json['subCategories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'categoryNumber': instance.categoryNumber,
      'isPublic': instance.isPublic,
      'promoPercent': instance.promoPercent,
      'subCategories': instance.subCategories?.map((e) => e.toJson()).toList(),
    };
