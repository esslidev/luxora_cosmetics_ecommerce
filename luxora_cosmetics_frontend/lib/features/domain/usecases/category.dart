import '../../../core/resources/data_state.dart';
import '../../data/models/category.dart';
import '../entities/category.dart';
import '../repository/category.dart';

class CategoryUseCases {
  final CategoryRepository repository;

  CategoryUseCases(this.repository);

  Future<DataState<CategoryEntity>> createCategory({
    required CategoryModel category,
  }) async {
    return await repository.createCategory(
      category: category,
    );
  }

  Future<DataState<CategoryEntity>> updateCategory({
    required CategoryModel category,
  }) async {
    return await repository.updateCategory(
      category: category,
    );
  }

  Future<DataState> deleteCategory({
    int? id,
    int? categoryNumber,
  }) async {
    return await repository.deleteCategory(
      id: id,
      categoryNumber: categoryNumber,
    );
  }

  Future<DataState<CategoryEntity>> getCategory({
    int? id,
    int? categoryNumber,
  }) async {
    return await repository.getCategory(
      id: id,
      categoryNumber: categoryNumber,
    );
  }

  Future<DataState<List<CategoryEntity>>> getAllCategories({
    int? level,
    bool? isMainCategory,
  }) async {
    return await repository.getAllCategories(
      level: level,
      isMainCategory: isMainCategory,
    );
  }

  Future<DataState<List<CategoryEntity>>> getMainCategories({
    String? ids,
    String? categoryNumbers,
  }) async {
    return await repository.getMainCategories(
      ids: ids,
      categoryNumbers: categoryNumbers,
    );
  }

  Future<DataState<List<CategoryEntity>>> getCategories({
    String? ids,
    String? categoryNumbers,
  }) async {
    return await repository.getCategories(
      ids: ids,
      categoryNumbers: categoryNumbers,
    );
  }
}
