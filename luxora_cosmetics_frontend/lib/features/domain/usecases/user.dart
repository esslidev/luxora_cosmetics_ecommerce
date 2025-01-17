import '../../../core/resources/data_state.dart';

import '../../data/models/user.dart';
import '../entities/user.dart';
import '../repository/user.dart';

class UserUseCases {
  final UserRepository repository;

  UserUseCases(this.repository);

  /// Fetch the details of the currently logged-in user
  Future<DataState<UserEntity>> getUser() async {
    return await repository.getUser();
  }

  /// Fetch all users with optional filters
  Future<DataState<List<UserEntity>>> getUsers({
    int? limit,
    int? page,
    String? search,
    bool? orderByAlphabets,
    bool? includeAdmins,
  }) async {
    return await repository.getUsers(
      limit: limit,
      page: page,
      search: search,
      orderByAlphabets: orderByAlphabets,
      includeAdmins: includeAdmins,
    );
  }

  /// Update user details
  Future<DataState<UserEntity>> updateUser({
    required UserModel user,
  }) async {
    return await repository.updateUser(user: user);
  }

  /// Update the password of a user
  Future<DataState<UserEntity>> updateUserPassword({
    required String recentPassword,
    required String newPassword,
  }) async {
    return await repository.updateUserPassword(
      recentPassword: recentPassword,
      newPassword: newPassword,
    );
  }

  /// Delete a user by ID
  Future<DataState> deleteUser({required int id}) async {
    return await repository.deleteUser(id: id);
  }
}
