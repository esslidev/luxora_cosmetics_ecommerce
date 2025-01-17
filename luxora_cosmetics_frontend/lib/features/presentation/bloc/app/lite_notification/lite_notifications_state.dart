import 'package:equatable/equatable.dart';

import '../../../../../core/resources/lite_notification_bar_model.dart';

abstract class AppLiteNotificationsState extends Equatable {
  final List<LiteNotificationModel>? liteNotifications;
  const AppLiteNotificationsState({this.liteNotifications});

  @override
  List<Object?> get props => [liteNotifications];
}

class AppLiteNotificationsInitial extends AppLiteNotificationsState {
  const AppLiteNotificationsInitial({super.liteNotifications});
}

class AppLiteNotificationAdded extends AppLiteNotificationsState {
  const AppLiteNotificationAdded({required super.liteNotifications});
}

class AppLiteNotificationRemoved extends AppLiteNotificationsState {
  const AppLiteNotificationRemoved({required super.liteNotifications});
}

class AppLiteNotificationsCleared extends AppLiteNotificationsState {
  const AppLiteNotificationsCleared() : super(liteNotifications: const []);
}
