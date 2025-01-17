import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/credentials.dart';
import '../../models/data_response.dart';
import '../../models/user.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @POST("/api/auth/sign_in")
  Future<HttpResponse<DataResponse<CredentialsModel>>> signIn({
    @Header("apiKey") required String apiKey,
    @Header('language') String? language,
    @Body() required UserModel user,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/auth/sign_up")
  Future<HttpResponse<DataResponse<CredentialsModel>>> signUp({
    @Header("apiKey") required String apiKey,
    @Header('language') String? language,
    @Body() required UserModel user,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/auth/password/reset/request")
  Future<HttpResponse<DataResponse>> requestPasswordReset({
    @Header("apiKey") required String apiKey,
    @Header('language') String? language,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/auth/password/reset")
  Future<HttpResponse<DataResponse>> resetPassword({
    @Header("apiKey") required String apiKey,
    @Header('language') String? language,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/auth/sign_out")
  Future<HttpResponse<DataResponse>> signOut({
    @Header("Authorization") required String accessToken,
    @Header('language') String? language,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @POST("/api/auth/access/renew")
  Future<HttpResponse<DataResponse<CredentialsModel>>> renewAccessToken({
    @Header("apiKey") required String apiKey,
    @Header('language') String? language,
    @Body() required CredentialsModel credentials,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
