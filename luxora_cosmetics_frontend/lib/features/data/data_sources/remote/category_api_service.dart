import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/category.dart';
import '../../models/data_response.dart';

part 'category_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class CategoryApiService {
  factory CategoryApiService(Dio dio) = _CategoryApiService;

  @POST("/api/categories/category/create")
  Future<HttpResponse<DataResponse<CategoryModel>>> createCategory({
    @Header("Authorization") required String accessToken,
    @Body() required CategoryModel category,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/categories/category/update")
  Future<HttpResponse<DataResponse<CategoryModel>>> updateCategory({
    @Header("Authorization") required String accessToken,
    @Body() required CategoryModel category,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/categories/category/delete")
  Future<HttpResponse<DataResponse>> deleteCategory({
    @Header("Authorization") required String accessToken,
    @Query("id") int? id,
    @Query("categoryNumber") int? categoryNumber,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/categories/all")
  Future<HttpResponse<DataResponse<List<CategoryModel>>>> getAllCategories({
    @Header('apiKey') required String apiKey,
    @Query("level") int? level,
    @Query("isMainCategory") bool? isMainCategory,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/categories/main-categories")
  Future<HttpResponse<DataResponse<List<CategoryModel>>>> getMainCategories({
    @Header('apiKey') required String apiKey,
    @Query("ids") String? ids,
    @Query("categoryNumbers") String? categoryNumbers,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/categories/categories")
  Future<HttpResponse<DataResponse<List<CategoryModel>>>> getCategories({
    @Header('apiKey') required String apiKey,
    @Query("ids") String? ids,
    @Query("categoryNumbers") String? categoryNumbers,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/categories/category")
  Future<HttpResponse<DataResponse<CategoryModel>>> getCategory({
    @Header('apiKey') required String apiKey,
    @Query("id") int? id,
    @Query("level") int? level,
    @Query("categoryNumber") int? categoryNumber,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
