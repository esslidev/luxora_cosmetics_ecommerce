import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/wishlist_item.dart';

part 'wishlist_item.g.dart';

@JsonSerializable(explicitToJson: true)
class WishlistItemModel extends WishlistItemEntity {
  const WishlistItemModel(
      {super.id,
      super.wishlistId,
      super.productId,
      super.quantity,
      super.createdAt,
      super.updatedAt});

  // Factory method to deserialize from JSON
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$WishlistItemModelToJson(this);
}
