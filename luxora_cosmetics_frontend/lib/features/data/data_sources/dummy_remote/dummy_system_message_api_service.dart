import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/data_response.dart';
import '../../models/system_message.dart';

class DummySystemMessageApiService {
  Future<DataResponse<SystemMessageModel>> createSystemMessage({
    required String accessToken,
    required SystemMessageModel systemMessage,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/system_message/create_system_message_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    SystemMessageModel createdMessage =
        SystemMessageModel.fromJson(jsonMap['data']);
    return DataResponse<SystemMessageModel>(
      data: createdMessage,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<SystemMessageModel>> updateSystemMessage({
    required String accessToken,
    required SystemMessageModel systemMessage,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/system_message/update_system_message_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    SystemMessageModel updatedMessage =
        SystemMessageModel.fromJson(jsonMap['data']);
    return DataResponse<SystemMessageModel>(
      data: updatedMessage,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse> deleteSystemMessage({
    required String accessToken,
    required int id,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/system_message/message_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return DataResponse(
      message: 'deleted successfully!!',
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<SystemMessageModel>> getSystemMessage({
    required String accessToken,
    required int id,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/system_message/get_system_message_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    SystemMessageModel message = SystemMessageModel.fromJson(jsonMap['data']);
    return DataResponse<SystemMessageModel>(
      data: message,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<List<SystemMessageModel>>> getAllSystemMessages({
    required String accessToken,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/system_message/get_system_messages_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> jsonList = jsonMap['data'];
    List<SystemMessageModel> messages =
        jsonList.map((json) => SystemMessageModel.fromJson(json)).toList();
    return DataResponse<List<SystemMessageModel>>(
      data: messages,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<List<SystemMessageModel>>> getShownSystemMessages({
    required String apiKey,
    required String language,
  }) async {
    final jsonString = await rootBundle.loadString(
        'assets/data/dummy_data/system_message/get_system_messages_shown_response.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> jsonList = jsonMap['data'];
    List<SystemMessageModel> messages =
        jsonList.map((json) => SystemMessageModel.fromJson(json)).toList();
    return DataResponse<List<SystemMessageModel>>(
      data: messages,
      status: jsonMap['status'],
    );
  }
}
