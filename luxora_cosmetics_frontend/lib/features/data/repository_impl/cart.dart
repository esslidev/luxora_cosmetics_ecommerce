/*import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/constants/shared_preference_keys.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/util/api_util.dart';

import '../../../core/util/prefs_util.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repository/cart.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/cart_api_service.dart';
import '../models/cart_item.dart';

class CartRepositoryImpl implements CartRepository {
  final AuthApiService _authApiService;
  final CartApiService _cartApiService;

  CartRepositoryImpl(this._authApiService, this._cartApiService);

   @override
  Future<DataState<CartEntity>> syncCart() async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _cartApiService.syncCart(
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          items: {'items': cartItems},
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
  Future<DataState<CartEntity>> getCart() async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _cartApiService.getCart(
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
      } else {
        
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CartItemModel>> addItemToCart({
    required int productId,
  }) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _cartApiService.addItemToCart(
            accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
            productId: {'productId': productId},
          ),
        );

        if (httpResponse.response.statusCode == HttpStatus.ok) {
          return DataSuccess(
              data: httpResponse.data.data, message: httpResponse.data.message);
        } else {
          return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ));
        }
      } else {
        final localData = await CartLocalDataSource(_cartDao)
            .addItemToCart(productId: productId);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<List<CartItemModel>>> addManyItemsToCart({
    required List<int> productIds,
  }) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _cartApiService.addManyItemsToCart(
            accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
            productIds: {'productIds': productIds},
          ),
        );

        if (httpResponse.response.statusCode == HttpStatus.ok) {
          return DataSuccess(
              data: httpResponse.data.data, message: httpResponse.data.message);
        } else {
          return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ));
        }
      } else {
        final localData = await CartLocalDataSource(_cartDao)
            .addManyItemsToCart(productIds: productIds);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CartItemModel>> updateCartItem(
      {required int productId, required int quantity}) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _cartApiService.updateCartItem(
            accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
            body: {'productId': productId, 'quantity': quantity},
          ),
        );

        if (httpResponse.response.statusCode == HttpStatus.ok) {
          return DataSuccess(
              data: httpResponse.data.data, message: httpResponse.data.message);
        } else {
          return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ));
        }
      } else {
        final localData = await CartLocalDataSource(_cartDao)
            .updateCartItem(productId: productId, quantity: quantity);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CartItemModel>> removeItemFromCart(
      {required int productId, bool allQuantity = false}) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _cartApiService.removeItemFromCart(
            accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
            body: {'productId': productId, 'allQuantity': allQuantity},
          ),
        );

        if (httpResponse.response.statusCode == HttpStatus.ok) {
          return DataSuccess(
              data: httpResponse.data.data, message: httpResponse.data.message);
        } else {
          return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ));
        }
      } else {
        final localData = await CartLocalDataSource(_cartDao)
            .removeItemFromCart(productId: productId, allQuantity: allQuantity);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState> clearCart() async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _cartApiService.clearCart(
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
      } else {
        final localData = await CartLocalDataSource(_cartDao).clearCart();
        return DataSuccess(data: localData);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
*/
