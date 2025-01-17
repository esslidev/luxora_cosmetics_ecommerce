import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/data_response.dart';
import '../../models/category.dart';

class DummyCategoryApiService {
  Future<DataResponse<CategoryModel>> createCategory({
    required String accessToken,
    required String language,
    required CategoryModel category,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/category/create_category_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    CategoryModel createdCategory = CategoryModel.fromJson(jsonMap['data']);
    return DataResponse<CategoryModel>(
      data: createdCategory,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<CategoryModel>> updateCategory({
    required String accessToken,
    required String language,
    required CategoryModel category,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/category/update_category_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    CategoryModel updatedCategory = CategoryModel.fromJson(jsonMap['data']);
    return DataResponse<CategoryModel>(
      data: updatedCategory,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse> deleteCategory({
    required String accessToken,
    required String language,
    int? id,
    int? categoryNumber,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/category/message_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return DataResponse(
      message: 'successfully done',
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<CategoryModel>> getCategory({
    required String apiKey,
    required String language,
    int? id,
    int? categoryNumber,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/category/get_category_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    CategoryModel category = CategoryModel.fromJson(jsonMap['data']);
    return DataResponse<CategoryModel>(
      data: category,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<List<CategoryModel>>> getCategories({
    required String apiKey,
    required String language,
    String? ids,
    String? categoryNumbers,
  }) async {
    final jsonContent = await rootBundle.loadString(
        'assets/data/dummy_data/category/get_categories_response.json');

    // Decode the JSON content as a map
    final Map<String, dynamic> jsonMap = json.decode(jsonContent);

    // Access the "data" field, which contains the list of categories
    final List<dynamic> jsonList = jsonMap['data'];

    // Convert each item in the list to a CategoryModel
    List<CategoryModel> categories =
        jsonList.map((jsonItem) => CategoryModel.fromJson(jsonItem)).toList();

    return DataResponse<List<CategoryModel>>(
      data: categories,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<CategoryModel>> getCategoryTree({
    required String apiKey,
    required String language,
    int? id,
    int? categoryNumber,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/category/get_category_tree_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    CategoryModel categoryTree = CategoryModel.fromJson(jsonMap['data']);
    return DataResponse<CategoryModel>(
      data: categoryTree,
      status: jsonMap['status'],
    );
  }
}
