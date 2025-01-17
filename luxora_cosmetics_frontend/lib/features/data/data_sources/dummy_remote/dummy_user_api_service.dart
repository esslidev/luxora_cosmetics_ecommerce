import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/data_response.dart';
import '../../models/user.dart';

class DummyUserApiService {
  Future<DataResponse<UserModel>> getUser({
    required String accessToken,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/user/get_user_response.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    UserModel user = UserModel.fromJson(jsonMap['data']);
    return DataResponse<UserModel>(
      data: user,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<List<UserModel>>> getUsers({
    required String accessToken,
    bool? orderByAlphabets,
    String? search,
    int? limit,
    int? page,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/user/get_users_response.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> jsonList = jsonMap['data'];
    List<UserModel> users =
        jsonList.map((json) => UserModel.fromJson(json)).toList();
    return DataResponse<List<UserModel>>(
      data: users,
      status: jsonMap['status'],
    );
  }
}
