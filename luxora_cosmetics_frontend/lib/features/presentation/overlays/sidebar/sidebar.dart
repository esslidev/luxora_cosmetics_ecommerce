import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/util/responsive_screen_adapter.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_field.dart';

class SidebarOverlayRoutes {
  final String name;
  final Function() onPressed;
  final bool isActive;
  SidebarOverlayRoutes({
    required this.name,
    required this.onPressed,
    this.isActive = false,
  });
}

class SidebarOverlay {
  final BuildContext context;
  ResponsiveSizeAdapter r;

  SidebarOverlay({required this.context, required this.r});

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  Future<void> show({required List<SidebarOverlayRoutes> routes}) async {
    if (isShown()) {
      toggle = false;
      await Future.delayed(300.ms);
      return; // Prevents adding multiple overlays.
    }
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              ModalBarrier(
                    dismissible: true,
                    color: Colors.black.withValues(alpha: 0.4),
                    onDismiss: dismiss,
                  )
                  .animate(target: toggle ? 1 : 0)
                  .fade(duration: 300.ms, curve: Curves.decelerate),
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                      color: Colors.transparent,
                      child: ResponsiveScreenAdapter(
                        screenTablet: _buildOverlay(routes: routes),
                        screenMobile: _buildOverlay(
                          routes: routes,
                          width: r.size(220),
                        ),
                      ),
                    )
                    .animate(target: toggle ? 1 : 0)
                    .scaleX(
                      duration: 300.ms,
                      curve: Curves.decelerate,
                      alignment: Alignment.centerRight,
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
    required List<SidebarOverlayRoutes> routes,
    double? width,
  }) {
    return Stack(
      children: [
        CustomField(
          minWidth: width ?? r.size(300),
          height: double.infinity,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: r.size(6),
          backgroundColor: AppColors.light.backgroundPrimary,
          border: Border(
            left: BorderSide(
              color: AppColors.colors.white.withValues(alpha: .1),
              width: r.size(.7),
            ),
          ),
          mainAxisSize: MainAxisSize.min,
          children: [
            ...routes.map((route) {
              return CustomButton(
                text: route.name,
                fontFamily: 'recoleta',
                fontSize: r.size(22),
                textColor:
                    route.isActive == true ? AppColors.light.primary : null,
                backgroundColor:
                    route.isActive == true
                        ? AppColors.colors.white.withValues(alpha: .06)
                        : null,
                animationDuration: 200.ms,
                onHoverStyle: CustomButtonStyle(
                  textColor: AppColors.light.primary,
                  backgroundColor: AppColors.light.primary.withValues(
                    alpha: .06,
                  ),
                ),
                onPressed: (position, size) {
                  dismiss();
                  route.onPressed();
                },
              );
            }),
          ],
        ),
        Positioned(
          top: r.size(6),
          right: r.size(6),
          child: CustomButton(
            svgIconPath: AppPaths.vectors.closeIcon,
            iconWidth: r.size(32),
            iconHeight: r.size(32),
            iconColor: AppColors.light.accent,
            onPressed: (position, size) {
              dismiss();
            },
          ),
        ),
      ],
    );
  }
}
