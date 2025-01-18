import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel extends ProductEntity {
  const ProductModel({
    super.id,
    super.isbn,
    super.primaryFormatIsbn,
    super.primaryCategoryNumber,
    super.title,
    super.imageUrl,
    super.editor,
    super.publicationDate,
    super.description,
    super.price,
    super.pricePromo,
    super.tax,
    super.primaryCategoryPromoPercent,
    super.pricePromoStartDate,
    super.pricePromoEndDate,
    super.pagesNumber,
    super.weight,
    super.width,
    super.height,
    super.thickness,
    super.isPublic,
    super.isPreorder,
    super.deliveryTime,
    super.stockCount,
    super.isNewArrival,
    super.isBestSeller,
    super.ratingCount,
    super.ratingAverage,
  });

  // Factory method to deserialize from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
