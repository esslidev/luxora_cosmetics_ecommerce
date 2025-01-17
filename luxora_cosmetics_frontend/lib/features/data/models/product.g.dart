// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: (json['id'] as num?)?.toInt(),
      isbn: json['isbn'] as String?,
      primaryFormatIsbn: json['primaryFormatIsbn'] as String?,
      primaryCategoryNumber: (json['primaryCategoryNumber'] as num?)?.toInt(),
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      author: json['author'] == null
          ? null
          : AuthorModel.fromJson(json['author'] as Map<String, dynamic>),
      editor: json['editor'] as String?,
      publicationDate: json['publicationDate'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      pricePromo: (json['pricePromo'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      primaryCategoryPromoPercent:
          (json['primaryCategoryPromoPercent'] as num?)?.toDouble(),
      pricePromoStartDate: json['pricePromoStartDate'] == null
          ? null
          : DateTime.parse(json['pricePromoStartDate'] as String),
      pricePromoEndDate: json['pricePromoEndDate'] == null
          ? null
          : DateTime.parse(json['pricePromoEndDate'] as String),
      pagesNumber: (json['pagesNumber'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      width: json['width'] as String?,
      height: json['height'] as String?,
      thickness: json['thickness'] as String?,
      isPublic: json['isPublic'] as bool?,
      isPreorder: json['isPreorder'] as bool?,
      formatType:
          $enumDecodeNullable(_$ProductFormatTypeEnumMap, json['formatType']),
      deliveryTime: (json['deliveryTime'] as num?)?.toInt(),
      stockCount: (json['stockCount'] as num?)?.toInt(),
      formats: (json['formats'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isNewArrival: json['isNewArrival'] as bool?,
      isBestSeller: json['isBestSeller'] as bool?,
      ratingCount: (json['ratingCount'] as num?)?.toInt(),
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isbn': instance.isbn,
      'primaryFormatIsbn': instance.primaryFormatIsbn,
      'primaryCategoryNumber': instance.primaryCategoryNumber,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'author': instance.author?.toJson(),
      'editor': instance.editor,
      'publicationDate': instance.publicationDate,
      'description': instance.description,
      'price': instance.price,
      'pricePromo': instance.pricePromo,
      'tax': instance.tax,
      'primaryCategoryPromoPercent': instance.primaryCategoryPromoPercent,
      'pricePromoStartDate': instance.pricePromoStartDate?.toIso8601String(),
      'pricePromoEndDate': instance.pricePromoEndDate?.toIso8601String(),
      'pagesNumber': instance.pagesNumber,
      'weight': instance.weight,
      'width': instance.width,
      'height': instance.height,
      'thickness': instance.thickness,
      'isPublic': instance.isPublic,
      'isPreorder': instance.isPreorder,
      'formatType': _$ProductFormatTypeEnumMap[instance.formatType],
      'deliveryTime': instance.deliveryTime,
      'stockCount': instance.stockCount,
      'formats': instance.formats?.map((e) => e.toJson()).toList(),
      'isNewArrival': instance.isNewArrival,
      'isBestSeller': instance.isBestSeller,
      'ratingCount': instance.ratingCount,
      'ratingAverage': instance.ratingAverage,
    };

const _$ProductFormatTypeEnumMap = {
  ProductFormatType.none: 'none',
  ProductFormatType.compact: 'compact',
  ProductFormatType.grand: 'grand',
  ProductFormatType.paperback: 'paperback',
  ProductFormatType.hardcover: 'hardcover',
  ProductFormatType.ebook: 'ebook',
  ProductFormatType.audio: 'audio',
};
