// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsModel _$CredentialsModelFromJson(Map<String, dynamic> json) =>
    CredentialsModel(
      accessToken: json['accessToken'] as String?,
      renewToken: json['renewToken'] as String?,
    );

Map<String, dynamic> _$CredentialsModelToJson(CredentialsModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'renewToken': instance.renewToken,
    };
