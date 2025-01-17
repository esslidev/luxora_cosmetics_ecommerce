import 'dart:io';

import 'package:dio/dio.dart';

import '../../features/data/data_sources/remote/auth_api_service.dart';
import '../../features/data/models/credentials.dart';
import '../../features/domain/entities/credentials.dart';
import '../constants/api_constants.dart';
import '../constants/shared_preference_keys.dart';
import '../resources/data_state.dart';
import 'prefs_util.dart';

class ApiUtil {
  static Future<T> autoAccessRenewal<T>(
      AuthApiService authApiService, Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final errorData = e.response?.data;
      if (errorData != null) {
        if (errorData['expiredAccessToken'] == true) {
          final newAccessTokenResult = await _renewAccessToken(
              authApiService, PrefsUtil.getString(PrefsKeys.userRenewToken)!);
          if (newAccessTokenResult is DataSuccess<CredentialsEntity>) {
            final newAccessToken = newAccessTokenResult.data?.accessToken;
            if (newAccessToken != null) {
              PrefsUtil.setString(PrefsKeys.userAccessToken, newAccessToken);

              return await request();
            }
          }
        } else if (errorData['accessUnauthorized'] == true) {
          PrefsUtil.remove(PrefsKeys.userAccessToken);
          PrefsUtil.remove(PrefsKeys.userRenewToken);
        }
      }
      rethrow;
    }
  }

  static Future<DataState<CredentialsEntity>> _renewAccessToken(
      AuthApiService authApiService, String renewToken) async {
    try {
      final httpResponse = await authApiService.renewAccessToken(
          apiKey: apiKey,
          credentials: CredentialsModel(renewToken: renewToken));

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data.data);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException {
      PrefsUtil.remove(PrefsKeys.userAccessToken);
      PrefsUtil.remove(PrefsKeys.userRenewToken);
      rethrow;
    }
  }
}
