import '../../../core/resources/data_state.dart';
import '../../data/models/user.dart';
import '../entities/credentials.dart';
import '../repository/auth.dart';

class AuthUseCases {
  final AuthRepository authRepository;

  AuthUseCases(this.authRepository);

  Future<DataState<CredentialsEntity>> signUp(UserModel user) async {
    return await authRepository.signUp(user);
  }

  Future<DataState<CredentialsEntity>> signIn(UserModel user) async {
    return await authRepository.signIn(user);
  }

  Future<DataState> requestPasswordReset({required String email}) async {
    return await authRepository.requestPasswordReset(email);
  }

  Future<DataState> resetPassword(
      {required String token, required String newPassword}) async {
    return await authRepository.resetPassword(
        token: token, newPassword: newPassword);
  }

  Future<DataState> signOut() async {
    return await authRepository.signOut();
  }
}
