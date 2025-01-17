import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/constants/shared_preference_keys.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/util/api_util.dart';
import '../../../../core/util/prefs_util.dart';
import '../../../core/constants/api_constants.dart';
import '../../domain/entities/system_message.dart';
import '../../domain/repository/system_message.dart';
import '../data_sources/dummy_remote/dummy_system_message_api_service.dart';
import '../data_sources/remote/auth_api_service.dart';
import '../data_sources/remote/system_message_api_service.dart';
import '../models/system_message.dart';

class SystemMessageRepositoryImpl implements SystemMessageRepository {
  final AuthApiService _authApiService;
  final SystemMessageApiService _systemMessageApiService;
  final DummySystemMessageApiService _dummySystemMessageApiService;

  SystemMessageRepositoryImpl(this._authApiService,
      this._systemMessageApiService, this._dummySystemMessageApiService);

  @override
  Future<DataState<SystemMessageEntity>> createSystemMessage({
    required SystemMessageModel systemMessage,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _systemMessageApiService.createSystemMessage(
          systemMessage: systemMessage,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse =
            await _dummySystemMessageApiService.createSystemMessage(
          systemMessage: systemMessage,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState<SystemMessageEntity>> updateSystemMessage({
    required SystemMessageModel systemMessage,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _systemMessageApiService.updateSystemMessage(
          systemMessage: systemMessage,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse =
            await _dummySystemMessageApiService.updateSystemMessage(
          systemMessage: systemMessage,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState> deleteSystemMessage({
    required int id,
  }) async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _systemMessageApiService.deleteSystemMessage(
          id: id,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse =
            await _dummySystemMessageApiService.deleteSystemMessage(
          id: id,
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState<List<SystemMessageEntity>>> getAllSystemMessages() async {
    try {
      final httpResponse = await ApiUtil.autoAccessRenewal(
        _authApiService,
        () => _systemMessageApiService.getAllSystemMessages(
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
          language: PrefsUtil.getString(PrefsKeys.languageCode)!,
        ),
      );

      if (useDummyData) {
        final dummyResponse =
            await _dummySystemMessageApiService.getAllSystemMessages(
          accessToken: PrefsUtil.getString(PrefsKeys.userAccessToken)!,
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
  Future<DataState<List<SystemMessageEntity>>> getShownSystemMessages() async {
    try {
      final httpResponse =
          await _systemMessageApiService.getShownSystemMessages(
        apiKey: apiKey,
        language: PrefsUtil.getString(PrefsKeys.languageCode)!,
      );

      if (useDummyData) {
        final dummyResponse =
            await _dummySystemMessageApiService.getShownSystemMessages(
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
}
