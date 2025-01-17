import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/data_response.dart';
import '../../models/user.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class UserApiService {
  factory UserApiService(Dio dio) = _UserApiService;

  @GET("/api/users/user")
  Future<HttpResponse<DataResponse<UserModel>>> getUser({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/users/all")
  Future<HttpResponse<DataResponse<List<UserModel>>>> getAllUsers({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Query("limit") int? limit,
    @Query("page") int? page,
    @Query("search") String? search,
    @Query('orderByAlphabets') bool? orderByAlphabets,
    @Query('includeAdmins') bool? includeAdmins,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/users/user/update")
  Future<HttpResponse<DataResponse<UserModel>>> updateUser({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required UserModel user,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/users/user/update/password")
  Future<HttpResponse<DataResponse<UserModel>>> updateUserPassword({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/users/user/delete")
  Future<HttpResponse<DataResponse>> deleteUser({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Path("userId") required int id,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
