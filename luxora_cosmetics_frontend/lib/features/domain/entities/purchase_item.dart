import 'package:equatable/equatable.dart';

import 'product.dart';

class PurchaseItemEntity extends Equatable {
  final ProductEntity product;
  final int? quantity;

  const PurchaseItemEntity({
    required this.product,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
        product,
        quantity,
      ];
}
