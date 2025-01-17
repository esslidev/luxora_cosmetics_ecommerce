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
import '../data_sources/dummy_remote/dummy_category_api_service.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/category_api_service.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AuthApiService _authApiService;
  final CategoryApiService _categoryApiService;
  final DummyCategoryApiService _dummyCategoryApiService;

  CategoryRepositoryImpl(this._authApiService, this._categoryApiService,
      this._dummyCategoryApiService);

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
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyCategoryApiService.createCategory(
          category: category,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        );
        return DataSuccess(data: dummyResponse.data);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
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
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyCategoryApiService.updateCategory(
          category: category,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        );
        return DataSuccess(data: dummyResponse.data);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
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
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyCategoryApiService.deleteCategory(
          id: id,
          categoryNumber: categoryNumber,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        );
        return DataSuccess(data: dummyResponse.data);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
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
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        id: id,
        categoryNumber: categoryNumber,
      );

      if (useDummyData) {
        final dummyResponse = await _dummyCategoryApiService.getCategory(
          apiKey: apiKey,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
          id: id,
          categoryNumber: categoryNumber,
        );
        return DataSuccess(data: dummyResponse.data);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
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
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        level: level,
        isMainCategory: isMainCategory,
      );

      if (useDummyData) {
        final dummyResponse = await _dummyCategoryApiService.getAllCategories(
          apiKey: apiKey,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
          level: level,
          isMainCategory: isMainCategory,
        );
        return DataSuccess(data: dummyResponse.data);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
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
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
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
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ids: ids,
        categoryNumbers: categoryNumbers,
      );

      if (useDummyData) {
        final dummyResponse = await _dummyCategoryApiService.getCategories(
          apiKey: apiKey,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
          ids: ids,
          categoryNumbers: categoryNumbers,
        );
        return DataSuccess(data: dummyResponse.data);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
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
