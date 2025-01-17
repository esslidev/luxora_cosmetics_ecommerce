import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/system_message_translation.dart';

part 'system_message_translation.g.dart';

@JsonSerializable()
class SystemMessageTranslationModel extends SystemMessageTranslationEntity {
  const SystemMessageTranslationModel({
    super.languageCode,
    super.message,
  });

  // Factory method to deserialize from JSON
  factory SystemMessageTranslationModel.fromJson(Map<String, dynamic> json) =>
      _$SystemMessageTranslationModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$SystemMessageTranslationModelToJson(this);
}
