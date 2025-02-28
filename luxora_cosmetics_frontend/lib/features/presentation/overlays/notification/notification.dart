import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/notification_type.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_field.dart';
import '../../widgets/common/custom_text.dart';

class NotificationOverlay {
  final BuildContext context;
  final VoidCallback? onDismiss;

  NotificationOverlay({
    required this.context,
    this.onDismiss,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  Future<void> show({
    NotificationType? notificationType = NotificationType.success,
    String? statusTitle,
    String? statusMessage,
  }) async {
    if (isShown()) {
      toggle = false;
      await Future.delayed(300.ms);
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: true,
            color: Colors.black.withValues(alpha: 0.6),
            onDismiss: dismiss,
          ).animate(target: toggle ? 1 : 0).fade(
                duration: 300.ms,
                curve: Curves.decelerate,
              ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: _buildOverlay(
                      notificationType: notificationType,
                      statusTitle: statusTitle,
                      statusMessage: statusMessage)
                  .animate(target: toggle ? 1 : 0)
                  .fade(
                    duration: 250.ms,
                  ),
            ),
          ),
        ],
      ),
    );
    toggle = true;
    Overlay.of(context).insert(_overlayEntry!);
  }

  void dismiss() {
    if (isShown()) {
      toggle = false;
      _overlayEntry?.markNeedsBuild();
      // Delay the removal to allow the animation to play
      Future.delayed(300.ms, () {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  bool isShown() {
    return _overlayEntry != null;
  }

  Widget _buildOverlay({
    NotificationType? notificationType,
    String? statusTitle,
    String? statusMessage,
  }) {
    ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);
    return CustomField(
      width: r.size(240),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      borderColor: AppColors.light.accent.withValues(alpha: 0.3),
      borderRadius: r.size(3),
      margin: r.symmetric(horizontal: 6),
      clipBehavior: Clip.hardEdge,
      gap: r.size(2),
      backgroundColor: AppColors.light.backgroundSecondary,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: notificationType == NotificationType.success ||
                  notificationType == NotificationType.info
              ? AppColors.light.primary.withValues(alpha: 0.8)
              : notificationType == NotificationType.warning
                  ? AppColors.light.warning.withValues(alpha: 0.8)
                  : AppColors.light.error.withValues(alpha: 0.8),
          padding: EdgeInsets.all(r.size(10)),
          child: Lottie.asset(
            notificationType == NotificationType.success
                ? AppPaths.files.lottie.success
                : AppPaths.files.lottie.warning,
            height: r.size(100),
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: r.size(8),
        ),
        CustomField(
            padding: EdgeInsets.symmetric(
                vertical: r.size(12), horizontal: r.size(14)),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: r.size(4),
            children: [
              CustomText(
                text: statusTitle ??
                    (notificationType == NotificationType.success
                        ? 'default success title'
                        : notificationType == NotificationType.warning
                            ? 'default warning title'
                            : 'default error title'),
                fontSize: r.size(16),
                fontWeight: FontWeight.bold,
                color: AppColors.light.accent,
                letterSpacing: r.size(1),
                textAlign: TextAlign.center,
              ),
              CustomText(
                text: statusMessage ??
                    (notificationType == NotificationType.success
                        ? 'default success message'
                        : notificationType == NotificationType.warning
                            ? 'default warning message'
                            : 'default error message'),
                fontSize: r.size(12),
                fontWeight: FontWeight.normal,
                color: AppColors.light.accent.withValues(alpha: 0.8),
                textAlign: TextAlign.center,
              ),
            ]),
        SizedBox(height: r.size(8)),
        CustomButton(
          width: r.size(300),
          text: 'Continue',
          fontSize: r.size(14),
          textColor: AppColors.light.subtle,
          padding: EdgeInsets.symmetric(vertical: r.size(4)),
          fontWeight: FontWeight.bold,
          letterSpacing: r.size(2),
          backgroundColor: notificationType == NotificationType.success
              ? AppColors.light.primary.withValues(alpha: 0.8)
              : notificationType == NotificationType.warning
                  ? AppColors.light.warning.withValues(alpha: 0.8)
                  : AppColors.light.error.withValues(alpha: 0.8),
          onHoverStyle: CustomButtonStyle(
            backgroundColor: notificationType == NotificationType.success
                ? AppColors.light.primary
                : notificationType == NotificationType.warning
                    ? AppColors.light.warning
                    : AppColors.light.error,
          ),
          animationDuration: const Duration(milliseconds: 100),
          onPressed: (position, size) {
            dismiss();
          },
        )
      ],
    );
  }
}
