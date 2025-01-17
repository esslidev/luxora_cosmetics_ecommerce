import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/lite_notification_bar_model.dart';
import 'lite_notifications_event.dart';
import 'lite_notifications_state.dart';

class AppLiteNotificationsBloc
    extends Bloc<AppLiteNotificationsEvent, AppLiteNotificationsState> {
  AppLiteNotificationsBloc()
      : super(const AppLiteNotificationsInitial(liteNotifications: [])) {
    on<AddLiteNotification>(_onAddLiteNotification);
    on<RemoveLiteNotification>(_onRemoveLiteNotification);
    on<ClearLiteNotifications>(_onClearLiteNotifications);
  }

  void _onAddLiteNotification(
      AddLiteNotification event, Emitter<AppLiteNotificationsState> emit) {
    final List<LiteNotificationModel> updatedList =
        List.of(state.liteNotifications ?? []);
    updatedList.add(event.notification);
    emit(AppLiteNotificationAdded(liteNotifications: updatedList));
  }

  void _onRemoveLiteNotification(
      RemoveLiteNotification event, Emitter<AppLiteNotificationsState> emit) {
    final List<LiteNotificationModel> updatedList =
        List.of(state.liteNotifications ?? []);

    // Find the notification with the given id
    updatedList.removeWhere((notification) => notification.id == event.id);

    emit(AppLiteNotificationRemoved(liteNotifications: updatedList));
  }

  void _onClearLiteNotifications(
      ClearLiteNotifications event, Emitter<AppLiteNotificationsState> emit) {
    emit(const AppLiteNotificationsCleared());
  }
}
