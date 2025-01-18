import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/shared_preference_keys.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/util/api_util.dart';
import '../../../core/util/prefs_util.dart';
import '../../data/models/category.dart';
import '../../domain/entities/category.dart';
import '../../domain/repository/category.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/category_api_service.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AuthApiService _authApiService;
  final CategoryApiService _categoryApiService;

  CategoryRepositoryImpl(this._authApiService, this._categoryApiService);

  @override
  Future<DataState<CategoryEntity>> createCategory({
    required CategoryModel category,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _categoryApiService.createCategory(
          category: category,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState<CategoryEntity>> updateCategory({
    required CategoryModel category,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _categoryApiService.updateCategory(
          category: category,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState> deleteCategory({
    int? id,
    int? categoryNumber,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _categoryApiService.deleteCategory(
          id: id,
          categoryNumber: categoryNumber,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState<CategoryEntity>> getCategory({
    int? id,
    int? categoryNumber,
  }) async {
    try {
      final httpResponse = await _categoryApiService.getCategory(
        apiKey: apiKey,
        id: id,
        categoryNumber: categoryNumber,
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
  Future<DataState<List<CategoryEntity>>> getAllCategories({
    int? level,
    bool? isMainCategory,
  }) async {
    try {
      final httpResponse = await _categoryApiService.getAllCategories(
        apiKey: apiKey,
        level: level,
        isMainCategory: isMainCategory,
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
  Future<DataState<List<CategoryEntity>>> getMainCategories({
    String? ids,
    String? categoryNumbers,
  }) async {
    try {
      final httpResponse = await _categoryApiService.getMainCategories(
        apiKey: apiKey,
        ids: ids,
        categoryNumbers: categoryNumbers,
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
  Future<DataState<List<CategoryEntity>>> getCategories({
    String? ids,
    String? categoryNumbers,
  }) async {
    try {
      final httpResponse = await _categoryApiService.getCategories(
        apiKey: apiKey,
        ids: ids,
        categoryNumbers: categoryNumbers,
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
