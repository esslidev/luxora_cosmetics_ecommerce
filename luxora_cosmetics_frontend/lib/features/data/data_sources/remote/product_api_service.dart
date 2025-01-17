import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/enums/product.dart';
import '../../models/data_response.dart';
import '../../models/product.dart';

part 'product_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class ProductApiService {
  factory ProductApiService(Dio dio) = _ProductApiService;

  @POST("/api/products/product/create")
  Future<HttpResponse<DataResponse<ProductModel>>> createProduct({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required ProductModel product,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/products/product/update")
  Future<HttpResponse<DataResponse<ProductModel>>> updateProduct({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required ProductModel product,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/products/product/delete")
  Future<HttpResponse<DataResponse>> deleteProduct({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Query("id") int? id,
    @Query("isbn") String? isbn,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/products/product")
  Future<HttpResponse<DataResponse<ProductModel>>> getProduct({
    @Header('apiKey') required String apiKey,
    @Header('language') required String language,
    @Query("id") int? id,
    @Query("isbn") String? isbn,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/products/products")
  Future<HttpResponse<DataResponse<List<ProductModel>>>> getProducts({
    @Header('apiKey') required String apiKey,
    @Header('language') required String language,
    @Query("limit") int? limit,
    @Query("page") int? page,
    @Query("productIds") String? productIds,
    @Query("search") String? search,
    @Query("isbn") String? isbn,
    @Query("title") String? title,
    @Query("authorName") String? authorName,
    @Query("editor") String? editor,
    @Query("categoryNumber") int? categoryNumber,
    @Query("categoryName") String? categoryName,
    @Query("formatType") ProductFormatType? formatType,
    @Query("priceRange") String? priceRange,
    @Query("publicationDate") String? publicationDate,
    @Query("isPublished") bool? isPublished,
    @Query("publishedIn") String? publishedIn,
    @Query("publishedWithin") String? publishedWithin,
    @Query("isNewArrivals") bool? isNewArrivals,
    @Query("isBestSellers") bool? isBestSellers,
    @Query("isPreorder") bool? isPreorder,
    @Query("isInStock") bool? isInStock,
    @Query("isOutStock") bool? isOutStock,
    @Query("orderByCreateDate") bool? orderByCreateDate,
    @Query("orderBySales") bool? orderBySales,
    @Query("orderByProductIds") String? orderByProductIds,
    @Query("orderByTitle") bool? orderByTitle,
    @Query("orderByAuthor") bool? orderByAuthor,
    @Query("orderByPrice") bool? orderByPrice,
    @Query("orderByPublicationDate") bool? orderByPublicationDate,
    @Query("orderByStock") bool? orderByStock,
    @Query("orderByPreorder") bool? orderByPreorder,
    @Query("sortOrder") SortOrder? sortOrder,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/products/products/ids")
  Future<HttpResponse<DataResponse<List<ProductModel>>>>
      getProductsByProductIds({
    @Header('apiKey') required String apiKey,
    @Header('language') required String language,
    @Query("productIds") String? productIds,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
