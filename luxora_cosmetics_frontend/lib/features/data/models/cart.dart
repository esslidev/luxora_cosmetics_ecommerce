import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart.dart';
import 'cart_item.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class CartModel extends CartEntity {
  const CartModel({super.id, super.items, super.createdAt, super.updatedAt});

  // Factory method to deserialize from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
