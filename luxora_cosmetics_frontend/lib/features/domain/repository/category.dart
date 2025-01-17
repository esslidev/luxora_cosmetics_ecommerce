import 'package:librairie_alfia/features/data/models/category.dart';

import '../../../core/resources/data_state.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<DataState<CategoryEntity>> createCategory({
    required CategoryModel category,
  });

  Future<DataState<CategoryEntity>> updateCategory({
    required CategoryModel category,
  });

  Future<DataState> deleteCategory({
    required int? id,
    required int? categoryNumber,
  });

  Future<DataState<CategoryEntity>> getCategory({
    int? id,
    int? categoryNumber,
  });

  Future<DataState<List<CategoryEntity>>> getAllCategories({
    int? level,
    bool? isMainCategory,
  });

  Future<DataState<List<CategoryEntity>>> getMainCategories({
    String? ids,
    String? categoryNumbers,
  });

  Future<DataState<List<CategoryEntity>>> getCategories({
    String? ids,
    String? categoryNumbers,
  });
}
