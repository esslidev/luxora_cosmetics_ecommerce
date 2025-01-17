import 'package:uuid/uuid.dart';
import '../enums/notification_type.dart';
import '../util/custom_timer.dart';

class LiteNotificationModel {
  static const Uuid _uuid = Uuid();

  final String id;
  final String? notificationTitle;
  final String? notificationMessage;
  final NotificationType? notificationType;
  late CustomTimer closeTimer;
  Function(int)? onTick;
  Function()? onTimerStop;

  LiteNotificationModel({
    this.notificationTitle,
    this.notificationMessage,
    this.notificationType = NotificationType.success,
    this.onTick,
    this.onTimerStop,
  }) : id = _uuid.v4() {
    closeTimer = CustomTimer(
      onTick: (value) {
        if (onTick != null) {
          onTick!(value);
        }
      },
      onTimerStop: () {
        if (onTimerStop != null) {
          onTimerStop!();
        }
      },
    );
    closeTimer.start(duration: const Duration(seconds: 15));
  }

  void stopTimer() => closeTimer.stop();
}
