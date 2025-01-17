import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_stock.dart';

part 'product_stock.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductStockModel extends ProductStockEntity {
  const ProductStockModel({
    super.id,
    super.magasinId,
    super.stock,
    super.deliveryTime,
  });

  // Factory method to deserialize from JSON
  factory ProductStockModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStockModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$ProductStockModelToJson(this);
}
