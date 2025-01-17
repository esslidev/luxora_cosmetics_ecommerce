import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/data_response.dart';
import '../../models/system_message.dart';

part 'system_message_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class SystemMessageApiService {
  factory SystemMessageApiService(Dio dio) = _SystemMessageApiService;

  @POST("/api/system_messages/message/create")
  Future<HttpResponse<DataResponse<SystemMessageModel>>> createSystemMessage({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required SystemMessageModel systemMessage,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @PUT("/api/system_messages/message/update")
  Future<HttpResponse<DataResponse<SystemMessageModel>>> updateSystemMessage({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required SystemMessageModel systemMessage,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @DELETE("/api/system_messages/message/delete")
  Future<HttpResponse<DataResponse>> deleteSystemMessage({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Query("id") required int id,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/system_messages/all")
  Future<HttpResponse<DataResponse<List<SystemMessageModel>>>>
      getAllSystemMessages({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Header('Content-Type') String contentType = 'application/json',
  });

  @GET("/api/system_messages/all/shown")
  Future<HttpResponse<DataResponse<List<SystemMessageModel>>>>
      getShownSystemMessages({
    @Header('apiKey') required String apiKey,
    @Header('language') required String language,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
