import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/cart_item.dart';
import '../../models/data_response.dart';
import '../../models/cart.dart';

part 'cart_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class CartApiService {
  factory CartApiService(Dio dio) = _CartApiService;

  @POST("/api/cart/cart/sync")
  Future<HttpResponse<DataResponse<CartModel>>> syncCart({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, List<CartItemModel>> items,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/cart/cart")
  Future<HttpResponse<DataResponse<CartModel>>> getCart({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/cart/item/add")
  Future<HttpResponse<DataResponse<CartItemModel>>> addItemToCart({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, int> productId,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/cart/items/add-many")
  Future<HttpResponse<DataResponse<List<CartItemModel>>>> addManyItemsToCart({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, List<int>> productIds,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/cart/item/update")
  Future<HttpResponse<DataResponse<CartItemModel>>> updateCartItem({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/cart/item/remove")
  Future<HttpResponse<DataResponse<CartItemModel>>> removeItemFromCart({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/cart/clear")
  Future<HttpResponse<DataResponse>> clearCart({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
