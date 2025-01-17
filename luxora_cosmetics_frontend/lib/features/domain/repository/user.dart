import '../../../core/resources/data_state.dart';
import '../../data/models/user.dart';
import '../entities/user.dart';

abstract class UserRepository {
  // Get user by ID
  Future<DataState<UserEntity>> getUser();

  // Get users with specific search criteria
  Future<DataState<List<UserEntity>>> getUsers({
    int? limit,
    int? page,
    String? search,
    bool? orderByAlphabets,
    bool? includeAdmins,
  });

  // Update user information
  Future<DataState<UserEntity>> updateUser({
    required UserModel user,
  });

  // Update user's password
  Future<DataState<UserEntity>> updateUserPassword({
    required String recentPassword,
    required String newPassword,
  });

  // Delete a user by ID
  Future<DataState> deleteUser({
    required int id,
  });
}
