import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_paths.dart';
import '../../../../../../../core/enums/notification_type.dart';
import '../../../../../../../core/enums/widgets.dart';
import '../../../../../../../core/resources/global_contexts.dart';
import '../../../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../../../core/util/app_events_util.dart';
import '../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../../core/util/translation_service.dart';
import '../../../../../../../locator.dart';
import '../../../../../overlays/notification/notification.dart';
import '../../../../../widgets/common/custom_button.dart';
import '../../../../../widgets/common/custom_display.dart';
import '../../../../../widgets/common/custom_field.dart';
import '../../../../../widgets/common/custom_text.dart';

class NotificationBar extends StatefulWidget {
  final LiteNotificationModel liteNotification;
  final BaseTheme theme;
  final TranslationService ts;
  final bool isRtl;

  const NotificationBar({
    super.key,
    required this.liteNotification,
    required this.theme,
    required this.ts,
    required this.isRtl,
  });

  @override
  State<NotificationBar> createState() => _NotificationBarState();
}

class _NotificationBarState extends State<NotificationBar> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  late NotificationOverlay _notificationOverlay;

  late ValueNotifier<double> closeTimerValue = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = locator<GlobalContexts>().homeContext;
      _notificationOverlay = NotificationOverlay(
        context: context,
        r: r,
      );

      // Set the onTick callback directly when the notification starts
      widget.liteNotification.onTick = (int value) {
        closeTimerValue.value = value / 15;
      };

      widget.liteNotification.onTimerStop = () {
        AppEventsUtil.liteNotifications
            .removeLiteNotification(context, id: widget.liteNotification.id);
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _notificationOverlay.show(
            theme: widget.theme,
            translationService: widget.ts,
            statusTitle: widget.liteNotification.notificationTitle,
            statusMessage: widget.liteNotification.notificationMessage,
            notificationType: widget.liteNotification.notificationType,
          );
          AppEventsUtil.liteNotifications
              .removeLiteNotification(context, id: widget.liteNotification.id);
        },
        child: CustomField(
          isRtl: widget.isRtl,
          borderRadius: r.size(2),
          padding: r.symmetric(vertical: 4, horizontal: 8),
          backgroundColor: widget.liteNotification.notificationType ==
                      NotificationType.success ||
                  widget.liteNotification.notificationType ==
                      NotificationType.info
              ? widget.theme.primary.withOpacity(0.1)
              : widget.liteNotification.notificationType ==
                      NotificationType.warning
                  ? widget.theme.warningColor.withOpacity(0.1)
                  : widget.theme.errorColor.withOpacity(0.1),
          gap: r.size(4),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          arrangement: FieldArrangement.row,
          children: [
            Stack(
              children: [
                Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: CustomDisplay(
                    assetPath: AppPaths.vectors.informationIcon,
                    svgColor: widget.liteNotification.notificationType ==
                                NotificationType.success ||
                            widget.liteNotification.notificationType ==
                                NotificationType.info
                        ? widget.theme.primary
                        : widget.liteNotification.notificationType ==
                                NotificationType.warning
                            ? widget.theme.warningColor
                            : widget.theme.errorColor,
                    isSvg: true,
                    width: r.size(12),
                    height: r.size(12),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: closeTimerValue,
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return SizedBox(
                        width: r.size(14),
                        height: r.size(14),
                        child: CircularProgressIndicator(
                          value: value,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.liteNotification.notificationType ==
                                        NotificationType.success ||
                                    widget.liteNotification.notificationType ==
                                        NotificationType.info
                                ? widget.theme.primary
                                : widget.liteNotification.notificationType ==
                                        NotificationType.warning
                                    ? widget.theme.warningColor
                                    : widget.theme.errorColor,
                          ),
                          strokeWidth: r.size(1.5),
                        ),
                      );
                    }),
              ],
            ),
            Expanded(
              child: CustomText(
                text: widget.liteNotification.notificationTitle ??
                    (widget.liteNotification.notificationType ==
                            NotificationType.success
                        ? widget.ts.translate(
                            'global.notifications.default.successTitle')
                        : widget.liteNotification.notificationType ==
                                NotificationType.warning
                            ? widget.ts.translate(
                                'global.notifications.default.warningTitle')
                            : widget.ts.translate(
                                'global.notifications.default.errorTitle')),
                fontSize: r.size(9),
                fontWeight: FontWeight.bold,
                color: widget.liteNotification.notificationType ==
                            NotificationType.success ||
                        widget.liteNotification.notificationType ==
                            NotificationType.info
                    ? widget.theme.primary
                    : widget.liteNotification.notificationType ==
                            NotificationType.warning
                        ? widget.theme.warningColor
                        : widget.theme.errorColor,
              ),
            ),
            CustomButton(
              svgIconPath: AppPaths.vectors.closeIcon,
              iconColor: widget.theme.accent.withOpacity(0.7),
              width: r.size(12),
              height: r.size(12),
              onPressed: (position, size) {
                AppEventsUtil.liteNotifications.removeLiteNotification(context,
                    id: widget.liteNotification.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
