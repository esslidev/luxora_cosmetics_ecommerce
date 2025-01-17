import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/author.dart';
import '../../models/data_response.dart';

part 'author_api_service.g.dart';

@RestApi(baseUrl: apiBaseUrl)
abstract class AuthorApiService {
  factory AuthorApiService(Dio dio) = _AuthorApiService;

  // Fetch all authors
  @GET("/api/authors/authors")
  Future<HttpResponse<DataResponse<List<AuthorModel>>>> getAuthors({
    @Header('apiKey') required String apiKey,
    @Header('language') required String language,
    @Query("search") String? search,
    @Query("isAuthorOfMonth") bool? isAuthorOfMonth,
    @Query("isFeaturedAuthor") bool? isFeaturedAuthor,
    @Query("orderByName") bool? orderByName,
    @Header('Content-Type') String contentType = 'application/json',
  });

  // Fetch a single author by ID
  @GET("/api/authors/author")
  Future<HttpResponse<DataResponse<AuthorModel>>> getAuthor({
    @Header('apiKey') required String apiKey,
    @Header('language') required String language,
    @Query('id') required int id,
    @Header('Content-Type') String contentType = 'application/json',
  });

  // Update an existing author
  @PUT("/api/authors/author/update")
  Future<HttpResponse<DataResponse<AuthorModel>>> updateAuthor({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Body() required Map<String, dynamic> body,
    @Header('Content-Type') String contentType = 'application/json',
  });

  // Delete an author
  @DELETE("/api/authors/author/delete")
  Future<HttpResponse<DataResponse>> deleteAuthor({
    @Header("Authorization") required String accessToken,
    @Header('language') required String language,
    @Query('id') required int id,
    @Header('Content-Type') String contentType = 'application/json',
  });
}
