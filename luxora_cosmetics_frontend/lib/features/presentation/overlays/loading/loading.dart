import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_constants.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../widgets/common/custom_field.dart';
import '../../widgets/common/custom_text.dart';

class LoadingOverlay {
  ResponsiveSizeAdapter r;
  final BuildContext context;

  LoadingOverlay({
    required this.context,
    required this.r,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  Future<void> show({
    String? loadingTitle,
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
            dismissible: false,
            color: Colors.black.withValues(alpha: 0.4),
          ).animate(target: toggle ? 1 : 0).fade(
                duration: 300.ms,
                curve: Curves.decelerate,
              ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: _buildOverlay(loadingTitle: loadingTitle)
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

  Widget _buildOverlay({String? loadingTitle}) {
    return CustomField(
      padding: EdgeInsets.only(bottom: r.size(10)),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      borderColor: AppColors.light.accent.withValues(alpha: 0.3),
      borderRadius: r.size(5),
      clipBehavior: Clip.hardEdge,
      gap: r.size(2),
      backgroundColor: AppColors.light.secondaryBackgroundColor,
      children: [
        /* Container(
          color: theme.primary.withValues(alpha: 0.6),
          padding: EdgeInsets.all(r.size(30)),
          child: Lottie.asset(
            AppPaths.files.lottie.bookLoading,
            height: r.size(80),
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),*/
        SizedBox(height: r.size(4)),
        CustomText(
          text: appName.toUpperCase(),
          fontSize: r.size(10),
          fontWeight: FontWeight.bold,
          color: AppColors.light.accent,
          letterSpacing: r.size(1),
        ),
        CustomText(
          text: loadingTitle ?? 'Loading',
          fontSize: r.size(10),
          fontWeight: FontWeight.w600,
          color: AppColors.light.accent.withValues(alpha: 0.6),
          letterSpacing: r.size(1),
        ),
      ],
    );
  }
}
