import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/shared_preference_keys.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/util/api_util.dart';
import '../../../core/util/prefs_util.dart';

import '../../domain/entities/author.dart';
import '../../domain/repository/author.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/author_api_service.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final AuthApiService _authApiService;
  final AuthorApiService _authorApiService;

  AuthorRepositoryImpl(this._authApiService, this._authorApiService);

  @override
  Future<DataState<AuthorEntity>> updateAuthor({
    required AuthorEntity author,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _authorApiService.updateAuthor(
          body: {
            'id': author.id,
            'firstName': author.firstName,
            'lastName': author.lastName,
            'coverImageUrl': author.coverImageUrl,
          },
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data.data);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState> deleteAuthorById({
    required int id,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _authorApiService.deleteAuthor(
          id: id,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(message: httpResponse.data.message);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<AuthorEntity>> getAuthorById({
    required int id,
  }) async {
    try {
      final httpResponse = await _authorApiService.getAuthor(
        id: id,
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data.data);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<AuthorEntity>>> getAuthors({
    String? search,
    bool? isAuthorOfMonth,
    bool? isFeaturedAuthor,
    bool? orderByName,
  }) async {
    try {
      final httpResponse = await _authorApiService.getAuthors(
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        search: search,
        isAuthorOfMonth: isAuthorOfMonth,
        isFeaturedAuthor: isFeaturedAuthor,
        orderByName: orderByName,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data.data);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
