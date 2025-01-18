import 'package:equatable/equatable.dart';
import '../../data/models/category.dart';

class CategoryEntity extends Equatable {
  final int? id;
  final int? parentId;
  final int? categoryNumber;
  final bool? isPublic;
  final int? promoPercent;
  final List<CategoryModel>? subCategories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    this.id,
    this.parentId,
    this.categoryNumber,
    this.isPublic,
    this.promoPercent,
    this.subCategories,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        parentId,
        categoryNumber,
        isPublic,
        promoPercent,
        subCategories,
        createdAt,
        updatedAt,
      ];

  CategoryEntity get emptyCategory => const CategoryEntity();
}
