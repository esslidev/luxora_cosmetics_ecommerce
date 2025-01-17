import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'wishlist_item')
class WishlistItemEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? wishlistId;
  final int? productId;
  final int? quantity;
  final String? createdAt;
  final String? updatedAt;

  const WishlistItemEntity({
    this.id,
    this.wishlistId,
    this.productId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        wishlistId,
        productId,
        quantity,
        createdAt,
        updatedAt,
      ];
}
