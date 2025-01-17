import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/shared_preference_keys.dart';
import '../../../core/enums/product.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/util/api_util.dart';
import '../../../core/util/prefs_util.dart';

import '../../domain/entities/product.dart';
import '../../domain/repository/product.dart';
import '../data_sources/dummy_remote/dummy_product_api_service.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/product_api_service.dart';
import '../models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final AuthApiService _authApiService;
  final ProductApiService _productApiService;
  final DummyProductApiService _dummyProductApiService;

  ProductRepositoryImpl(this._authApiService, this._productApiService,
      this._dummyProductApiService);

  @override
  Future<DataState<ProductEntity>> createProduct({
    required ProductModel product,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _productApiService.createProduct(
          product: product,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.createProduct(
          product: product,
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
  Future<DataState<ProductEntity>> updateProduct({
    required ProductModel product,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _productApiService.updateProduct(
          product: product,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.updateProduct(
          product: product,
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
  Future<DataState> deleteProductById({
    required int id,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _productApiService.deleteProduct(
          id: id,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.deleteProduct(
          id: id,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        );
        return DataSuccess(message: dummyResponse.message);
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
  Future<DataState> deleteProductByIsbn({
    required String isbn,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _productApiService.deleteProduct(
          isbn: isbn,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.deleteProduct(
          isbn: isbn,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        );
        return DataSuccess(message: dummyResponse.message);
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
  Future<DataState<ProductEntity>> getProductById({
    required int id,
  }) async {
    try {
      final httpResponse = await _productApiService.getProduct(
        id: id,
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.getProduct(
          id: id,
          apiKey: apiKey,
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
  Future<DataState<ProductEntity>> getProductByIsbn({
    required String isbn,
  }) async {
    try {
      final httpResponse = await _productApiService.getProduct(
        isbn: isbn,
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.getProduct(
          isbn: isbn,
          apiKey: apiKey,
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
  Future<DataState<List<ProductEntity>>> getProducts({
    int? limit,
    int? page,
    String? productIds,
    String? search,
    String? isbn,
    String? title,
    String? authorName,
    String? editor,
    int? categoryNumber,
    String? categoryName,
    ProductFormatType? formatType,
    String? priceRange,
    String? publicationDate,
    bool? isPublished,
    String? publishedIn,
    String? publishedWithin,
    bool? isPreorder,
    bool? isNewArrivals,
    bool? isBestSellers,
    bool? isInStock,
    bool? isOutStock,
    bool? orderByCreateDate,
    bool? orderBySales,
    String? orderByProductIds,
    bool? orderByTitle,
    bool? orderByAuthor,
    bool? orderByPrice,
    bool? orderByPublicationDate,
    bool? orderByStock,
    bool? orderByPreorder,
    SortOrder? sortOrder,
  }) async {
    try {
      final httpResponse = await _productApiService.getProducts(
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        limit: limit,
        page: page,
        productIds: productIds,
        search: search,
        isbn: isbn,
        title: title,
        authorName: authorName,
        editor: editor,
        categoryNumber: categoryNumber,
        categoryName: categoryName,
        formatType: formatType,
        priceRange: priceRange,
        publicationDate: publicationDate,
        isPublished: isPublished,
        publishedIn: publishedIn,
        publishedWithin: publishedWithin,
        isNewArrivals: isNewArrivals,
        isBestSellers: isBestSellers,
        isPreorder: isPreorder,
        isInStock: isInStock,
        isOutStock: isOutStock,
        orderByCreateDate: orderByCreateDate,
        orderBySales: orderBySales,
        orderByProductIds: orderByProductIds,
        orderByTitle: orderByTitle,
        orderByAuthor: orderByAuthor,
        orderByPrice: orderByPrice,
        orderByPublicationDate: orderByPublicationDate,
        orderByStock: orderByStock,
        orderByPreorder: orderByPreorder,
        sortOrder: sortOrder,
      );

      if (useDummyData) {
        final dummyResponse = await _dummyProductApiService.getProducts(
          apiKey: apiKey,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
          limit: limit,
          page: page,
          search: search,
          categoryNumber: categoryNumber,
          orderByCreateDate: orderByCreateDate,
          orderBySales: orderBySales,
          orderByTitle: orderByTitle,
          orderByPrice: orderByPrice,
          sortOrder: sortOrder,
        );
        return DataSuccess(
            data: dummyResponse.data, pagination: httpResponse.data.pagination);
      } else if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(
          data: httpResponse.data.data,
          filteringData: httpResponse.data.filteringData,
          pagination: httpResponse.data.pagination,
        );
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
  Future<DataState<List<ProductEntity>>> getProductsByProductIds({
    String? productIds,
  }) async {
    try {
      final httpResponse = await _productApiService.getProductsByProductIds(
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        productIds: productIds,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(
            data: httpResponse.data.data,
            pagination: httpResponse.data.pagination);
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
