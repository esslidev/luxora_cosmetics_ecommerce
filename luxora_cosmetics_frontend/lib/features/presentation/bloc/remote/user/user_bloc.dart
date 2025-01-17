import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../../../core/util/prefs_util.dart';
import '../../../../domain/usecases/user.dart';
import 'user_event.dart';
import 'user_state.dart';

class RemoteUserBloc extends Bloc<RemoteUserEvent, RemoteUserState> {
  final UserUseCases _userUseCases;

  RemoteUserBloc(this._userUseCases) : super(const RemoteUserInitial()) {
    on<GetUsers>(onGetUsers);
    on<GetLoggedInUser>(onGetLoggedInUser);
    on<UpdateUser>(onUpdateUser);
    on<UpdateUserPassword>(onUpdateUserPassword);
    on<DeleteUser>(onDeleteUser);
  }

  void _deleteCredentials() {
    PrefsUtil.remove(PrefsKeys.userAccessToken);
    PrefsUtil.remove(PrefsKeys.userRenewToken);
  }

  //-----------------------------------------------//
  /// Fetch All Users with Filters
  void onGetUsers(GetUsers event, Emitter<RemoteUserState> emit) async {
    emit(const RemoteUsersLoading());
    final dataState = await _userUseCases.getUsers(
      limit: event.limit,
      page: event.page,
      search: event.search,
      orderByAlphabets: event.orderByAlphabets,
      includeAdmins: event.includeAdmins,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteUsersLoaded(users: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteUserError(dataState.error!));
    }
  }

  //-----------------------------------------------//
  /// Fetch Logged-In User
  void onGetLoggedInUser(
      GetLoggedInUser event, Emitter<RemoteUserState> emit) async {
    if (event.onEditProfile == true) {
      emit(const RemoteUserLoading(userOnEditProfileLoading: true));
    } else {
      emit(const RemoteUserLoading(userLoading: true));
    }

    final dataState = await _userUseCases.getUser();
    if (dataState is DataSuccess && dataState.data != null) {
      if (event.onEditProfile == true) {
        emit(RemoteUserLoaded(userOnEditProfile: dataState.data!));
      } else {
        emit(RemoteUserLoaded(user: dataState.data!));
      }
    } else if (dataState is DataFailed) {
      _deleteCredentials();
      emit(RemoteUserError(dataState.error!));
    }
  }

  //-----------------------------------------------//
  /// Update User Details
  void onUpdateUser(UpdateUser event, Emitter<RemoteUserState> emit) async {
    emit(const RemoteUserUpdating());
    final dataState = await _userUseCases.updateUser(user: event.user);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteUserUpdated(userOnEditProfile: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteUserError(dataState.error!));
    }
  }

  //-----------------------------------------------//
  /// Update User Password
  void onUpdateUserPassword(
      UpdateUserPassword event, Emitter<RemoteUserState> emit) async {
    emit(const RemoteUserUpdating());
    final dataState = await _userUseCases.updateUserPassword(
      recentPassword: event.recentPassword,
      newPassword: event.newPassword,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteUserUpdated(userOnEditProfile: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteUserError(dataState.error!));
    }
  }

  //-----------------------------------------------//
  /// Delete User
  void onDeleteUser(DeleteUser event, Emitter<RemoteUserState> emit) async {
    emit(const RemoteUserDeleting());
    final dataState = await _userUseCases.deleteUser(id: event.id);
    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteUserDeleted(dataState.message!));
    } else if (dataState is DataFailed) {
      emit(RemoteUserError(dataState.error!));
    }
  }
}
