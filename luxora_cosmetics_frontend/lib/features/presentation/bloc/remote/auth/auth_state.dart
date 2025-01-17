import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class RemoteAuthState extends Equatable {
  final String? messageResponse;
  final DioException? error;

  const RemoteAuthState({this.messageResponse, this.error});

  @override
  List<Object?> get props => [messageResponse, error];
}

// ------------- init user --------------//
class RemoteAuthInitial extends RemoteAuthState {
  const RemoteAuthInitial();
}

// ------------- signup with user --------------//
class RemoteAuthSigningUp extends RemoteAuthState {
  const RemoteAuthSigningUp();
}

class RemoteAuthSignedUp extends RemoteAuthState {
  const RemoteAuthSignedUp();
}

// ------------- signin with user --------------//
class RemoteAuthSigningIn extends RemoteAuthState {
  const RemoteAuthSigningIn();
}

class RemoteAuthSignedIn extends RemoteAuthState {
  const RemoteAuthSignedIn();
}

// ------------- request password reset --------------//
class RemoteAuthPasswordResetRequesting extends RemoteAuthState {
  const RemoteAuthPasswordResetRequesting();
}

class RemoteAuthPasswordResetRequested extends RemoteAuthState {
  const RemoteAuthPasswordResetRequested({super.messageResponse});
}

// ------------- request password reset --------------//
class RemoteAuthPasswordResetting extends RemoteAuthState {
  const RemoteAuthPasswordResetting();
}

class RemoteAuthPasswordResetted extends RemoteAuthState {
  const RemoteAuthPasswordResetted({super.messageResponse});
}

// ------------- signout with user --------------//
class RemoteAuthSigningOut extends RemoteAuthState {
  const RemoteAuthSigningOut();
}

class RemoteAuthSignedOut extends RemoteAuthState {
  const RemoteAuthSignedOut({super.messageResponse});
}

// ------------- error user --------------//
class RemoteAuthError extends RemoteAuthState {
  const RemoteAuthError(DioException? error) : super(error: error);
}
