// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductStockModel _$ProductStockModelFromJson(Map<String, dynamic> json) =>
    ProductStockModel(
      id: (json['id'] as num?)?.toInt(),
      magasinId: (json['magasinId'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt(),
      deliveryTime: (json['deliveryTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductStockModelToJson(ProductStockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'magasinId': instance.magasinId,
      'stock': instance.stock,
      'deliveryTime': instance.deliveryTime,
    };
