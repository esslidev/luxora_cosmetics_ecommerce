/*import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/constants/shared_preference_keys.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/util/api_util.dart';

import '../../../core/util/prefs_util.dart';
import '../../domain/entities/wishlist.dart';
import '../../domain/repository/wishlist.dart';
import '../data_sources/local/daos/wishlist_dao.dart';
import '../data_sources/local/wishlist_local_data_source.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/wishlist_api_service.dart';
import '../models/wishlist_item.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final AuthApiService _authApiService;
  final WishlistApiService _wishlistApiService;
  final WishlistDao _wishlistDao;

  WishlistRepositoryImpl(
    this._authApiService,
    this._wishlistApiService,
    this._wishlistDao,
  );

  @override
  Future<DataState<WishlistEntity>> syncWishlist() async {
    try {
      final localData =
          await WishlistLocalDataSource(_wishlistDao).getWishlist();
      List<WishlistItemModel> wishlistItems = localData.data?.items ?? [];
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _wishlistApiService.syncWishlist(
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          items: {'items': wishlistItems},
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
  Future<DataState<WishlistEntity>> getWishlist() async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _wishlistApiService.getWishlist(
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
        final localData =
            await WishlistLocalDataSource(_wishlistDao).getWishlist();
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<WishlistItemModel>> addItemToWishlist({
    required int productId,
  }) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _wishlistApiService.addItemToWishlist(
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
        final localData = await WishlistLocalDataSource(_wishlistDao)
            .addItemToWishlist(productId: productId);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<WishlistItemModel>> updateWishlistItem(
      {required int productId, required int quantity}) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _wishlistApiService.updateWishlistItem(
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
        final localData = await WishlistLocalDataSource(_wishlistDao)
            .updateWishlistItem(productId: productId, quantity: quantity);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<WishlistItemModel>> removeItemFromWishlist(
      {required int productId, bool allQuantity = false}) async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _wishlistApiService.removeItemFromWishlist(
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
        final localData = await WishlistLocalDataSource(_wishlistDao)
            .removeItemFromWishlist(
                productId: productId, allQuantity: allQuantity);
        return DataSuccess(data: localData.data);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState> clearWishlist() async {
    try {
      if (PrefsUtil.getString(PrefsKeys.userAccessToken) != null) {
        final httpResponse = await ApiUtil.autoAccessRenewal(
          _authApiService,
          () => _wishlistApiService.clearWishlist(
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
        final localData =
            await WishlistLocalDataSource(_wishlistDao).clearWishlist();
        return DataSuccess(data: localData);
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
*/
