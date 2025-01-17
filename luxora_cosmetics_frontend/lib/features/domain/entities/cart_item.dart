import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'cart_item')
class CartItemEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? cartId;
  final int? productId;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;

  const CartItemEntity({
    this.id,
    this.cartId,
    this.productId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        cartId,
        productId,
        quantity,
        createdAt,
        updatedAt,
      ];
}
