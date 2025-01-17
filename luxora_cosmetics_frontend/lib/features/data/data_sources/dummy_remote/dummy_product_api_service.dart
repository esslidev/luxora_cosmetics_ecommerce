import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/enums/product.dart';
import '../../models/data_response.dart';
import '../../models/product.dart';

class DummyProductApiService {
  Future<DataResponse<ProductModel>> createProduct({
    required String accessToken,
    required String language,
    required ProductModel product,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/product/create_product_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    ProductModel createdProduct = ProductModel.fromJson(jsonMap['data']);
    return DataResponse<ProductModel>(
      data: createdProduct,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<ProductModel>> updateProduct({
    required String accessToken,
    required String language,
    required ProductModel product,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/product/update_product_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    ProductModel updatedProduct = ProductModel.fromJson(jsonMap['data']);
    return DataResponse<ProductModel>(
      data: updatedProduct,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse> deleteProduct({
    required String accessToken,
    required String language,
    int? id,
    String? isbn,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/product/message_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return DataResponse(
      message: 'successfully done',
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<ProductModel>> getProduct({
    required String apiKey,
    required String language,
    int? id,
    String? isbn,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/product/get_product_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    ProductModel product = ProductModel.fromJson(jsonMap['data']);
    return DataResponse<ProductModel>(
      data: product,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<List<ProductModel>>> getProducts({
    required String apiKey,
    required String language,
    int? limit,
    int? page,
    String? search,
    int? categoryNumber,
    bool? orderByCreateDate,
    bool? orderBySales,
    bool? orderByTitle,
    bool? orderByPrice,
    SortOrder? sortOrder,
  }) async {
    final jsonContent = await rootBundle.loadString(
        'assets/data/dummy_data/product/get_products_response.json');

    // Decode the JSON content as a map
    final Map<String, dynamic> jsonMap = json.decode(jsonContent);

    // Access the "data" field, which contains the list of products
    final List<dynamic> jsonList = jsonMap['data'];

    // Convert each item in the list to a ProductModel
    List<ProductModel> products =
        jsonList.map((jsonItem) => ProductModel.fromJson(jsonItem)).toList();

    return DataResponse<List<ProductModel>>(
      data: products,
      status: jsonMap['status'],
    );
  }
}
