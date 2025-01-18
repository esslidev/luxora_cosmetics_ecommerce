import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/data_response.dart';
import '../../models/wishlist.dart';
import '../../models/wishlist_item.dart';

part 'wishlist_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class WishlistApiService {
  factory WishlistApiService(Dio dio) = _WishlistApiService;

  @POST("/api/wishlist/wishlist/sync")
  Future<HttpResponse<DataResponse<WishlistModel>>> syncWishlist({
    @Header("Authorization") required String accessToken,
    @Body() required Map<String, List<WishlistItemModel>> items,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/wishlist/wishlist")
  Future<HttpResponse<DataResponse<WishlistModel>>> getWishlist({
    @Header("Authorization") required String accessToken,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/wishlist/item/add")
  Future<HttpResponse<DataResponse<WishlistItemModel>>> addItemToWishlist({
    @Header("Authorization") required String accessToken,
    @Body() required Map<String, int> productId,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/wishlist/item/update")
  Future<HttpResponse<DataResponse<WishlistItemModel>>> updateWishlistItem({
    @Header("Authorization") required String accessToken,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/wishlist/item/remove")
  Future<HttpResponse<DataResponse<WishlistItemModel>>> removeItemFromWishlist({
    @Header("Authorization") required String accessToken,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/wishlist/clear")
  Future<HttpResponse<DataResponse>> clearWishlist({
    @Header("Authorization") required String accessToken,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
