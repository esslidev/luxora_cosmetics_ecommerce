// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      authorOfMonth: json['authorOfMonth'] as bool?,
      featuredAuthor: json['featuredAuthor'] as bool?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'coverImageUrl': instance.coverImageUrl,
      'authorOfMonth': instance.authorOfMonth,
      'featuredAuthor': instance.featuredAuthor,
      'products': instance.products?.map((e) => e.toJson()).toList(),
    };
