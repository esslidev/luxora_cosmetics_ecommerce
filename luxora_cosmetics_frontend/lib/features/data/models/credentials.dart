import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/credentials.dart';

// Adjust the path as per your project structure

part 'credentials.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialsModel extends CredentialsEntity {
  const CredentialsModel({
    super.accessToken,
    super.renewToken,
  });

  // Factory method to deserialize from JSON
  factory CredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$CredentialsModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$CredentialsModelToJson(this);
}
