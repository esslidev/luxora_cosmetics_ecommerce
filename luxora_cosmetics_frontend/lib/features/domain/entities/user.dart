import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final bool? isAdmin;
  final bool? isVerified;
  final String? email;
  final String? phone;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? addressMain;
  final String? addressSecond;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    this.id,
    this.isAdmin,
    this.isVerified,
    this.email,
    this.phone,
    this.password,
    this.firstName,
    this.lastName,
    this.addressMain,
    this.addressSecond,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        isAdmin,
        isVerified,
        email,
        phone,
        password,
        firstName,
        lastName,
        addressMain,
        addressSecond,
        city,
        state,
        zip,
        country,
        createdAt,
        updatedAt,
      ];
}
