import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/wishlist.dart';
import 'wishlist_item.dart';

part 'wishlist.g.dart';

@JsonSerializable(explicitToJson: true)
class WishlistModel extends WishlistEntity {
  const WishlistModel(
      {super.id, super.items, super.createdAt, super.updatedAt});

  // Factory method to deserialize from JSON
  factory WishlistModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$WishlistModelToJson(this);
}
