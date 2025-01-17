import 'package:equatable/equatable.dart';
import 'package:librairie_alfia/features/data/models/author.dart';
import 'package:librairie_alfia/features/data/models/product.dart';

import '../../../core/enums/product.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? isbn;
  final String? primaryFormatIsbn;
  final int? primaryCategoryNumber;
  final String? title;
  final String? imageUrl;
  final AuthorModel? author;
  final String? editor;
  final String? publicationDate;
  final String? description;
  final double? price;
  final double? pricePromo;
  final double? tax;
  final double? primaryCategoryPromoPercent;
  final DateTime? pricePromoStartDate;
  final DateTime? pricePromoEndDate;
  final int? pagesNumber;
  final double? weight;
  final String? width;
  final String? height;
  final String? thickness;
  final bool? isPublic;
  final bool? isPreorder;
  final ProductFormatType? formatType;
  final int? deliveryTime;
  final int? stockCount;
  final List<ProductModel>? formats;
  final bool? isNewArrival;
  final bool? isBestSeller;
  final int? ratingCount;
  final double? ratingAverage;

  const ProductEntity({
    this.id,
    this.isbn,
    this.primaryFormatIsbn,
    this.primaryCategoryNumber,
    this.title,
    this.imageUrl,
    this.author,
    this.editor,
    this.publicationDate,
    this.description,
    this.price,
    this.pricePromo,
    this.tax,
    this.primaryCategoryPromoPercent,
    this.pricePromoStartDate,
    this.pricePromoEndDate,
    this.pagesNumber,
    this.weight,
    this.width,
    this.height,
    this.thickness,
    this.isPublic,
    this.isPreorder,
    this.formatType,
    this.deliveryTime,
    this.stockCount,
    this.formats,
    this.isNewArrival,
    this.isBestSeller,
    this.ratingCount,
    this.ratingAverage,
  });

  @override
  List<Object?> get props => [
        id,
        isbn,
        primaryFormatIsbn,
        primaryCategoryNumber,
        title,
        imageUrl,
        author,
        editor,
        publicationDate,
        description,
        price,
        pricePromo,
        tax,
        primaryCategoryPromoPercent,
        pricePromoStartDate,
        pricePromoEndDate,
        pagesNumber,
        weight,
        width,
        height,
        thickness,
        isPublic,
        isPreorder,
        formatType,
        deliveryTime,
        stockCount,
        formats,
        isNewArrival,
        isBestSeller,
        ratingCount,
        ratingAverage,
      ];
}
