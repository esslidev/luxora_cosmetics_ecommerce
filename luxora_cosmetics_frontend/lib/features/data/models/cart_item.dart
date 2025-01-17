import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemModel extends CartItemEntity {
  const CartItemModel(
      {super.id,
      super.cartId,
      super.productId,
      super.quantity,
      super.createdAt,
      super.updatedAt});

  // Factory method to deserialize from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}
