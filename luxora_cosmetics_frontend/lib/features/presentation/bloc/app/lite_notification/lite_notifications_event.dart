import '../../../../../core/resources/lite_notification_bar_model.dart';

abstract class AppLiteNotificationsEvent {
  const AppLiteNotificationsEvent();
}

class AddLiteNotification extends AppLiteNotificationsEvent {
  final LiteNotificationModel notification;

  const AddLiteNotification({required this.notification});
}

class RemoveLiteNotification extends AppLiteNotificationsEvent {
  final String id;

  const RemoveLiteNotification({required this.id});
}

class ClearLiteNotifications extends AppLiteNotificationsEvent {
  const ClearLiteNotifications();
}
