import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/credentials.dart';
import '../../models/data_response.dart';
import '../../models/user.dart';

class DummyAuthApiService {
  Future<DataResponse<CredentialsModel>> signIn({
    required String apiKey,
    String? language,
    required UserModel user,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/auth/sign_in_response.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    CredentialsModel credentials = CredentialsModel.fromJson(jsonMap['data']);
    return DataResponse<CredentialsModel>(
      data: credentials,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<CredentialsModel>> signUp({
    required String apiKey,
    String? language,
    required UserModel user,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/auth/sign_up_response.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    CredentialsModel credentials = CredentialsModel.fromJson(jsonMap['data']);
    return DataResponse<CredentialsModel>(
      data: credentials,
      status: jsonMap['status'],
    );
  }

  Future<DataResponse<CredentialsModel>> signOut({
    required String accessToken,
    String? language,
  }) async {
    final jsonString = await rootBundle
        .loadString('assets/data/dummy_data/auth/sign_out_response.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    CredentialsModel credentials = CredentialsModel.fromJson(jsonMap['data']);
    return DataResponse<CredentialsModel>(
      data: credentials,
      status: jsonMap['status'],
    );
  }
}
