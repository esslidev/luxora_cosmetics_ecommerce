import 'package:equatable/equatable.dart';

class CredentialsEntity extends Equatable {
  final String? accessToken;
  final String? renewToken;

  const CredentialsEntity({
    this.accessToken,
    this.renewToken,
  });

  @override
  List<Object?> get props => [accessToken, renewToken];
}
