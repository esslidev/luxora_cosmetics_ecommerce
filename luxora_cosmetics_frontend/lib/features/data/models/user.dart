import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.isAdmin,
    super.isVerified,
    super.email,
    super.phone,
    super.password,
    super.firstName,
    super.lastName,
    super.addressMain,
    super.addressSecond,
    super.city,
    super.state,
    super.zip,
    super.country,
    super.createdAt,
    super.updatedAt,
  });

  // Factory method to deserialize from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Method to serialize to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
