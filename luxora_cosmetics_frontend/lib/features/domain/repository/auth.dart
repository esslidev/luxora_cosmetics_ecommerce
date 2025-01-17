import '../../../core/resources/data_state.dart';
import '../../data/models/user.dart';
import '../entities/credentials.dart';

abstract class AuthRepository {
  Future<DataState<CredentialsEntity>> signUp(UserModel user);
  Future<DataState<CredentialsEntity>> signIn(UserModel user);
  Future<DataState> requestPasswordReset(String email);
  Future<DataState> resetPassword(
      {required String token, required String newPassword});
  Future<DataState> signOut();
}
