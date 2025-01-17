import 'package:equatable/equatable.dart';

import '../../data/models/cart_item.dart';

class CartEntity extends Equatable {
  final int? id;
  final List<CartItemModel>? items;
  final String? createdAt;
  final String? updatedAt;

  const CartEntity({
    this.id,
    this.items,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        createdAt,
        updatedAt,
      ];
}
