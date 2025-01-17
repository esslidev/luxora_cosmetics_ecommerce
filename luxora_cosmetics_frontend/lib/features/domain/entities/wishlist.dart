import 'package:equatable/equatable.dart';

import '../../data/models/wishlist_item.dart';

class WishlistEntity extends Equatable {
  final int? id;
  final List<WishlistItemModel>? items;
  final String? createdAt;
  final String? updatedAt;

  const WishlistEntity({
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
