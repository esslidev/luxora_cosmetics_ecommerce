import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/translation_service.dart';
import '../../../../core/util/responsive_screen_adapter.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../widgets/common/custom_field.dart';
import '../../widgets/common/custom_text.dart';

class SideNavigatorOverlay {
  final BuildContext context;
  final VoidCallback? onDismiss;

  SideNavigatorOverlay({
    required this.context,
    this.onDismiss,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  Future<void> show({
    required TranslationService translationService,
    required ResponsiveSizeAdapter r,
    required BaseTheme theme,
    required bool isRtl,
  }) async {
    if (isShown()) {
      toggle = false;
      await Future.delayed(300.ms);
      return; // Prevents adding multiple overlays.
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: true,
            color: Colors.black.withOpacity(0.4),
            onDismiss: dismiss,
          ).animate(target: toggle ? 1 : 0).fade(
                duration: 300.ms,
                curve: Curves.decelerate,
              ),
          Align(
            alignment: !isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: ResponsiveScreenAdapter(
                screenTablet: _buildOverlay(
                    r: r,
                    theme: theme,
                    translationService: translationService,
                    isRtl: isRtl),
                screenMobile: _buildOverlay(
                    r: r,
                    theme: theme,
                    translationService: translationService,
                    isRtl: isRtl,
                    width: r.size(220)),
              ),
            ).animate(target: toggle ? 1 : 0).scaleX(
                  duration: 300.ms,
                  curve: Curves.decelerate,
                  alignment:
                      !isRtl ? Alignment.centerRight : Alignment.centerLeft,
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
    required TranslationService translationService,
    required ResponsiveSizeAdapter r,
    required BaseTheme theme,
    required bool isRtl,
    double? width,
  }) {
    return CustomField(
      width: width ?? r.size(300),
      height: double.infinity,
      isRtl: isRtl,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(2),
      backgroundColor: theme.overlayBackgroundColor,
      mainAxisSize: MainAxisSize.min,
      children: [CustomText(text: 'side nav')],
    );
  }
}
