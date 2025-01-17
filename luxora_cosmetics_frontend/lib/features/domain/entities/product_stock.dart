import 'package:equatable/equatable.dart';

class ProductStockEntity extends Equatable {
  final int? id;
  final int? magasinId;
  final int? stock;
  final int? deliveryTime;

  const ProductStockEntity({
    this.id,
    this.magasinId,
    this.stock,
    this.deliveryTime,
  });

  @override
  List<Object?> get props => [
        id,
        magasinId,
        stock,
        deliveryTime,
      ];
}
