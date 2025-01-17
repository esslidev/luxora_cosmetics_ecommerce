import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../../../core/util/prefs_util.dart';
import '../../../../domain/usecases/auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class RemoteAuthBloc extends Bloc<RemoteAuthEvent, RemoteAuthState> {
  final AuthUseCases _authUseCases;

  RemoteAuthBloc(this._authUseCases) : super(const RemoteAuthInitial()) {
    on<SignIn>(onSignIn);
    on<SignUp>(onSignUp);
    on<RequestPasswordReset>(onRequestPasswordReset);
    on<ResetPassword>(onResetPassword);
    on<SignOut>(onSignOut);
  }

  void _saveCredentials(String accessToken, String renewToken) {
    PrefsUtil.setString(PrefsKeys.userAccessToken, accessToken);
    PrefsUtil.setString(PrefsKeys.userRenewToken, renewToken);
  }

  void _deleteCredentials() {
    PrefsUtil.remove(PrefsKeys.userAccessToken);
    PrefsUtil.remove(PrefsKeys.userRenewToken);
  }

  void onSignUp(SignUp event, Emitter<RemoteAuthState> emit) async {
    emit(const RemoteAuthSigningUp());
    final dataState = await _authUseCases.signUp(event.user);
    if (dataState is DataSuccess) {
      _saveCredentials(
          dataState.data!.accessToken!, dataState.data!.renewToken!);
      emit(const RemoteAuthSignedUp());
    }
    if (dataState is DataFailed) {
      emit(RemoteAuthError(dataState.error!));
    }
  }

  void onSignIn(SignIn event, Emitter<RemoteAuthState> emit) async {
    emit(const RemoteAuthSigningIn());
    final dataState = await _authUseCases.signIn(event.user);
    if (dataState is DataSuccess) {
      _saveCredentials(
          dataState.data!.accessToken!, dataState.data!.renewToken!);
      emit(const RemoteAuthSignedIn());
    }
    if (dataState is DataFailed) {
      emit(RemoteAuthError(dataState.error!));
    }
  }

  void onRequestPasswordReset(
      RequestPasswordReset event, Emitter<RemoteAuthState> emit) async {
    emit(const RemoteAuthPasswordResetRequesting());
    final dataState =
        await _authUseCases.requestPasswordReset(email: event.email);
    if (dataState is DataSuccess) {
      emit(
          RemoteAuthPasswordResetRequested(messageResponse: dataState.message));
    }
    if (dataState is DataFailed) {
      emit(RemoteAuthError(dataState.error!));
    }
  }

  void onResetPassword(
      ResetPassword event, Emitter<RemoteAuthState> emit) async {
    emit(const RemoteAuthPasswordResetting());
    final dataState = await _authUseCases.resetPassword(
        token: event.token, newPassword: event.newPassword);
    if (dataState is DataSuccess) {
      emit(RemoteAuthPasswordResetted(messageResponse: dataState.message));
    }
    if (dataState is DataFailed) {
      emit(RemoteAuthError(dataState.error!));
    }
  }

  void onSignOut(SignOut event, Emitter<RemoteAuthState> emit) async {
    emit(const RemoteAuthSigningOut());
    final dataState = await _authUseCases.signOut();
    if (dataState is DataSuccess) {
      _deleteCredentials();
      emit(RemoteAuthSignedOut(messageResponse: dataState.message));
    }
    if (dataState is DataFailed) {
      emit(RemoteAuthError(dataState.error!));
    }
  }
}
