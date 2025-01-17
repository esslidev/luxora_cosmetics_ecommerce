import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/system_message.dart';
import 'system_message_translation.dart';

part 'system_message.g.dart';

@JsonSerializable(explicitToJson: true)
class SystemMessageModel extends SystemMessageEntity {
  const SystemMessageModel({
    super.id,
    super.isPublic,
    super.startDate,
    super.endDate,
    super.translations,
    super.createdAt,
    super.updatedAt,
  });

  // Factory method to deserialize from JSON
  factory SystemMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SystemMessageModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$SystemMessageModelToJson(this);
}
