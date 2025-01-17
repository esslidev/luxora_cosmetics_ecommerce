import '../../../../data/models/user.dart';

abstract class RemoteUserEvent {
  const RemoteUserEvent();
}

//-----------------------------------------------//
// Fetch All Users with Filters
class GetUsers extends RemoteUserEvent {
  final int? limit;
  final int? page;
  final String? search;
  final bool? orderByAlphabets;
  final bool? includeAdmins;

  const GetUsers({
    this.limit,
    this.page,
    this.search,
    this.orderByAlphabets,
    this.includeAdmins,
  });
}

//-----------------------------------------------//
// Fetch Current Logged-In User
class GetLoggedInUser extends RemoteUserEvent {
  final bool onEditProfile;
  const GetLoggedInUser({this.onEditProfile = false});
}

//-----------------------------------------------//
// Update User Details
class UpdateUser extends RemoteUserEvent {
  final UserModel user;

  const UpdateUser({required this.user});
}

//-----------------------------------------------//
// Update User Password
class UpdateUserPassword extends RemoteUserEvent {
  final String recentPassword;
  final String newPassword;

  const UpdateUserPassword({
    required this.recentPassword,
    required this.newPassword,
  });
}

//-----------------------------------------------//
// Delete a User by ID
class DeleteUser extends RemoteUserEvent {
  final int id;

  const DeleteUser({required this.id});
}
