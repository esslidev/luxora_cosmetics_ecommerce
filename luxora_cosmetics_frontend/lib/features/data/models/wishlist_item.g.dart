// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItemModel _$WishlistItemModelFromJson(Map<String, dynamic> json) =>
    WishlistItemModel(
      id: (json['id'] as num?)?.toInt(),
      wishlistId: (json['wishlistId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$WishlistItemModelToJson(WishlistItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wishlistId': instance.wishlistId,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
