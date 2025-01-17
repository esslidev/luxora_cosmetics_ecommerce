import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/pagination.dart';
import '../../../../domain/entities/user.dart';

abstract class RemoteUserState extends Equatable {
  final UserEntity? user;
  final UserEntity? userOnEditProfile;
  final List<UserEntity>? users;
  final List<UserEntity>? searchedUsers;
  final bool? userLoading;
  final bool? userOnEditProfileLoading;
  final bool? usersLoading;
  final bool? searchedUsersLoading;
  final PaginationEntity? pagination;
  final String? messageResponse;
  final DioException? error;

  const RemoteUserState({
    this.user,
    this.userOnEditProfile,
    this.users,
    this.searchedUsers,
    this.userLoading,
    this.userOnEditProfileLoading,
    this.usersLoading,
    this.searchedUsersLoading,
    this.pagination,
    this.messageResponse,
    this.error,
  });

  @override
  List<Object?> get props => [
        user,
        userOnEditProfile,
        users,
        searchedUsers,
        userLoading,
        userOnEditProfileLoading,
        usersLoading,
        searchedUsersLoading,
        pagination,
        messageResponse,
        error,
      ];
}

// ------------- Initial state -------------- //
class RemoteUserInitial extends RemoteUserState {
  const RemoteUserInitial();
}

// ------------- Loading users -------------- //
class RemoteUsersLoading extends RemoteUserState {
  const RemoteUsersLoading({
    super.usersLoading,
    super.searchedUsersLoading,
  });
}

class RemoteUsersLoaded extends RemoteUserState {
  const RemoteUsersLoaded({
    super.users,
    super.searchedUsers,
    super.pagination,
  });
}

// ------------- Loading user -------------- //
class RemoteUserLoading extends RemoteUserState {
  const RemoteUserLoading({super.userLoading, super.userOnEditProfileLoading});
}

class RemoteUserLoaded extends RemoteUserState {
  const RemoteUserLoaded({super.user, super.userOnEditProfile});
}

// ------------- Updating user -------------- //
class RemoteUserUpdating extends RemoteUserState {
  const RemoteUserUpdating();
}

class RemoteUserUpdated extends RemoteUserState {
  const RemoteUserUpdated({super.userOnEditProfile});
}

// ------------- Updating user -------------- //
class RemoteUserPasswordUpdating extends RemoteUserState {
  const RemoteUserPasswordUpdating();
}

class RemoteUserPasswordUpdated extends RemoteUserState {
  const RemoteUserPasswordUpdated({super.userOnEditProfile});
}

// ------------- Deleting user -------------- //
class RemoteUserDeleting extends RemoteUserState {
  const RemoteUserDeleting();
}

class RemoteUserDeleted extends RemoteUserState {
  const RemoteUserDeleted(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- Error state -------------- //
class RemoteUserError extends RemoteUserState {
  const RemoteUserError(DioException? error) : super(error: error);
}
