// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_message_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemMessageTranslationModel _$SystemMessageTranslationModelFromJson(
        Map<String, dynamic> json) =>
    SystemMessageTranslationModel(
      languageCode: json['languageCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SystemMessageTranslationModelToJson(
        SystemMessageTranslationModel instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'message': instance.message,
    };
