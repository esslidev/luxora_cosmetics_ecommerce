import '../../../../data/models/user.dart';

abstract class RemoteAuthEvent {
  const RemoteAuthEvent();
}

class SignUp extends RemoteAuthEvent {
  final UserModel user;

  const SignUp(this.user);
}

class SignIn extends RemoteAuthEvent {
  final UserModel user;

  const SignIn(this.user);
}

class RequestPasswordReset extends RemoteAuthEvent {
  final String email;

  const RequestPasswordReset({required this.email});
}

class ResetPassword extends RemoteAuthEvent {
  final String token;
  final String newPassword;

  const ResetPassword({required this.token, required this.newPassword});
}

class SignOut extends RemoteAuthEvent {
  const SignOut();
}
