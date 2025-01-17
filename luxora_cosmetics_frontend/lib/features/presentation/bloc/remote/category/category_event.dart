import '../../../../data/models/category.dart';

abstract class RemoteCategoryEvent {
  const RemoteCategoryEvent();
}

//-----------------------------------------------//
// Create Category Event
class CreateCategory extends RemoteCategoryEvent {
  final CategoryModel category;

  CreateCategory(this.category);
}

//-----------------------------------------------//
// Update Category Event
class UpdateCategory extends RemoteCategoryEvent {
  final CategoryModel category;

  UpdateCategory(this.category);
}

//-----------------------------------------------//
// Delete Category Events
class DeleteCategoryById extends RemoteCategoryEvent {
  final int id;
  DeleteCategoryById(this.id);
}

class DeleteCategoryByCategoryNumber extends RemoteCategoryEvent {
  final int categoryNumber;
  DeleteCategoryByCategoryNumber(this.categoryNumber);
}

//-----------------------------------------------//
// Get Single Category Events
class GetCategoryById extends RemoteCategoryEvent {
  final int id;
  final int level;
  GetCategoryById({required this.id, required this.level});
}

class GetCategoryByCategoryNumber extends RemoteCategoryEvent {
  final int categoryNumber;
  final int level;
  GetCategoryByCategoryNumber(
      {required this.categoryNumber, required this.level});
}

//--------------------------------------------------//
class GetBoutiqueMainCategory extends RemoteCategoryEvent {
  final int categoryNumber;
  GetBoutiqueMainCategory({required this.categoryNumber});
}

//-----------------------------------------------//
// Get All Categories Event
class GetNavigatorAllCategories extends RemoteCategoryEvent {
  const GetNavigatorAllCategories();
}

//-----------------------------------------------//
// Get All Categories Event
class GetBoutiqueAllCategories extends RemoteCategoryEvent {
  const GetBoutiqueAllCategories();
}

//-----------------------------------------------//
// Get search main Categories by IDs or Category Numbers
class GetSearchMainCategories extends RemoteCategoryEvent {
  final String? ids;
  final String? categoryNumbers;
  const GetSearchMainCategories({this.ids, this.categoryNumbers});
}

//-----------------------------------------------//
// Get Multiple Categories by IDs or Category Numbers
class GetCategories extends RemoteCategoryEvent {
  final String? ids;
  final String? categoryNumbers;
  const GetCategories({this.ids, this.categoryNumbers});
}
