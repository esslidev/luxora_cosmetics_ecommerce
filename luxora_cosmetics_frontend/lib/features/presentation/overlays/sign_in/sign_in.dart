import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/presentation/overlays/request_reset_password/request_reset_password.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/notification_type.dart';
import '../../../../core/enums/theme_style.dart';
import '../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../core/util/app_events_util.dart';
import '../../../../core/util/app_util.dart';
import '../../../../core/util/remote_events_util.dart';
import '../../../../core/util/translation_service.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../data/models/user.dart';
import '../../bloc/remote/auth/auth_bloc.dart';
import '../../bloc/remote/auth/auth_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_display.dart';
import '../../widgets/common/custom_field.dart';
import '../../widgets/common/custom_text.dart';
import '../../widgets/common/custom_text_field.dart';
import '../create_account/create_account.dart';
import '../loading/loading.dart';

class SignInOverlay {
  final BuildContext context;
  ResponsiveSizeAdapter r;
  final VoidCallback? onDismiss;

  SignInOverlay({
    required this.context,
    required this.r,
    this.onDismiss,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  late final LoadingOverlay _loadingOverlay = LoadingOverlay(
    context: context,
  );

  late final CreateAccountOverlay _createAccountOverlay = CreateAccountOverlay(
    context: context,
    r: r,
  );

  late final RequestResetPasswordOverlay _requestResetPasswordOverlay =
      RequestResetPasswordOverlay(
    context: context,
    r: r,
  );

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final ValueNotifier<String?> _successMessage = ValueNotifier(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);

  Future<void> show(
      {required TranslationService translationService,
      required BaseTheme theme,
      required ThemeStyle themeStyle,
      required bool isRtl,
      String? successMessage}) async {
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
            color: Colors.black.withOpacity(0.6),
            onDismiss: dismiss,
          ).animate(target: toggle ? 1 : 0).fade(
                duration: 300.ms,
                curve: Curves.decelerate,
              ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: BlocListener<RemoteAuthBloc, RemoteAuthState>(
                listener: (context, state) {
                  if (state is RemoteAuthSigningIn) {
                    _loadingOverlay.show(
                      translationService: translationService,
                      r: r,
                      theme: theme,
                    );
                  }
                  if (state is RemoteAuthSignedIn) {
                    _loadingOverlay.dismiss();
                    RemoteEventsUtil.wishlistEvents.syncWishlist(
                      context,
                    );
                    RemoteEventsUtil.cartEvents.syncCart(
                      context,
                    );
                    dismiss();
                    AppEventsUtil.liteNotifications.addLiteNotification(context,
                        notification: LiteNotificationModel(
                          notificationTitle: translationService
                              .translate('global.notifications.SignedIn.title'),
                          notificationMessage: translationService.translate(
                              'global.notifications.SignedIn.message'),
                          notificationType: NotificationType.success,
                        ));
                  }
                  if (state is RemoteAuthError) {
                    _loadingOverlay.dismiss();
                    _successMessage.value = null;
                    _errorMessage.value =
                        state.error?.response?.data["message"];
                  }
                },
                child: _buildOverlay(
                  theme: theme,
                  themeStyle: themeStyle,
                  translationService: translationService,
                  isRtl: isRtl,
                ).animate(target: toggle ? 1 : 0).fade(
                      duration: 250.ms,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
    toggle = true;
    Overlay.of(context).insert(_overlayEntry!);
    _successMessage.value = successMessage;
  }

  void dismiss() {
    if (isShown()) {
      toggle = false;
      _overlayEntry?.markNeedsBuild();
      // Delay the removal to allow the animation to play
      Future.delayed(300.ms, () {
        _emailController.text = '';
        _passwordController.text = '';
        _errorMessage.value = null;
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  bool isShown() {
    return _overlayEntry != null;
  }

  //---------------------------------------//

  //-----------------------------------------------//
  bool _areInputsValid() {
    return _emailController.text.trim().isNotEmpty &&
        AppUtil.isEmailValid(_emailController.text) &&
        AppUtil.isPasswordValid(_passwordController.text);
  }

  //---------------------------------------//

  Widget _buildNotificationMessageField({
    required BaseTheme theme,
    required bool isRtl,
    String? successMessage,
    String? errorMessage,
  }) {
    return CustomField(
        width: double.infinity,
        borderRadius: r.size(1),
        padding: r.all(4),
        isRtl: isRtl,
        backgroundColor: successMessage != null
            ? theme.primary.withOpacity(0.4)
            : AppColors.colors.redRouge.withOpacity(0.4),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: successMessage ?? errorMessage ?? '',
            fontSize: r.size(8),
            textAlign: TextAlign.center,
          ),
        ]);
  }

  Widget _buildTextInput(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required String name,
      required String hint,
      required TextEditingController controller,
      TextInputType? keyboardType,
      bool obscureText = false,
      Color? Function(String)? borderColorCallback,
      void Function(String value, Offset position, Size size)? onChanged}) {
    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (BuildContext context, TextEditingValue value, Widget? child) {
          return CustomField(gap: r.size(2), isRtl: isRtl, children: [
            CustomText(
              text: name,
              fontSize: r.size(10),
              fontWeight: FontWeight.normal,
            ),
            CustomTextField(
              controller: controller,
              fontSize: r.size(10),
              fontWeight: FontWeight.normal,
              borderRadius: BorderRadius.all(Radius.circular(r.size(2))),
              backgroundColor: theme.secondaryBackgroundColor,
              hintText: hint,
              obscureText: obscureText,
              padding: r.symmetric(horizontal: 8, vertical: 4),
              keyboardType: keyboardType,
              borderColor: borderColorCallback != null
                  ? borderColorCallback(value.text)
                  : null,
              onChanged: onChanged,
            ),
          ]);
        });
  }

  _buildForm({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(isRtl: isRtl, gap: r.size(12), children: [
      _buildTextInput(
        theme: theme,
        ts: ts,
        isRtl: isRtl,
        hint: 'John.doe@example.com',
        keyboardType: TextInputType.emailAddress,
        name: ts.translate('global.authentication.email'),
        controller: _emailController,
        borderColorCallback: (value) {
          return value != ''
              ? !AppUtil.isEmailValid(value)
                  ? AppColors.colors.redRouge
                  : theme.primary
              : null;
        },
      ).animate().fadeIn(delay: 200.ms),
      _buildTextInput(
        theme: theme,
        ts: ts,
        isRtl: isRtl,
        name: ts.translate('global.authentication.password'),
        hint: 'Password',
        obscureText: true,
        controller: _passwordController,
        borderColorCallback: (value) {
          return value != ''
              ? !AppUtil.isPasswordValid(value)
                  ? AppColors.colors.redRouge
                  : theme.primary
              : null;
        },
      ).animate().fadeIn(delay: 200.ms),
    ]);
  }

  Widget _buildActionButton(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required String title,
      Color? backgroundColor,
      Color? onHoverbackgroundColor,
      Color? textColor,
      Color? onHoverTextColor,
      bool isEnabled = true,
      required Function() onPressed}) {
    return CustomButton(
      text: title,
      fontWeight: FontWeight.bold,
      fontSize: r.size(10),
      backgroundColor: backgroundColor ?? theme.primary,
      textColor: textColor ?? AppColors.colors.whiteOut,
      padding: r.symmetric(vertical: 4, horizontal: 16),
      enabled: isEnabled,
      borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
          backgroundColor: onHoverbackgroundColor ?? theme.secondary,
          textColor: onHoverTextColor),
      onDisabledStyle: CustomButtonStyle(
          backgroundColor: theme.secondaryBackgroundColor,
          textColor: theme.accent.withOpacity(0.3)),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildActionButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _emailController,
      builder:
          (BuildContext context, TextEditingValue emailValue, Widget? child) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _passwordController,
          builder: (BuildContext context, TextEditingValue passwordValue,
              Widget? child) {
            return CustomField(
              isRtl: isRtl,
              gap: r.size(6),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              arrangement: FieldArrangement.row,
              children: [
                _buildActionButton(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  title: ts.translate('global.authentication.login'),
                  isEnabled: _areInputsValid(),
                  backgroundColor: theme.primary,
                  onHoverbackgroundColor: theme.secondary,
                  textColor: AppColors.colors.whiteSolid,
                  onHoverTextColor: AppColors.colors.whiteSolid,
                  onPressed: () {
                    RemoteEventsUtil.authEvents.signIn(
                        context,
                        UserModel(
                          email: emailValue.text,
                          password: passwordValue.text,
                        ));
                  },
                ),
                _buildActionButton(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  title: ts.translate('global.cancel'),
                  backgroundColor: theme.accent,
                  onHoverbackgroundColor: theme.accent.withOpacity(0.8),
                  textColor: theme.subtle,
                  onPressed: () {
                    dismiss();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOverlay({
    required TranslationService translationService,
    required BaseTheme theme,
    required ThemeStyle themeStyle,
    required bool isRtl,
  }) {
    return IntrinsicHeight(
      child: CustomField(
        width: r.size(300),
        padding: r.symmetric(vertical: 10),
        margin: r.symmetric(horizontal: 6, vertical: 10),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        borderColor: theme.accent.withOpacity(0.3),
        borderRadius: r.size(3),
        clipBehavior: Clip.hardEdge,
        gap: r.size(2),
        backgroundColor: theme.overlayBackgroundColor,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ValueListenableBuilder(
                  valueListenable: _successMessage,
                  builder: (BuildContext context, String? successMessage,
                      Widget? child) {
                    return ValueListenableBuilder(
                        valueListenable: _errorMessage,
                        builder: (BuildContext context, String? errorMessage,
                            Widget? child) {
                          return CustomField(
                            isRtl: isRtl,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            gap: r.size(14),
                            padding: r.symmetric(horizontal: 16, vertical: 22),
                            children: [
                              CustomDisplay(
                                assetPath: themeStyle == ThemeStyle.light
                                    ? AppPaths.vectors.logo
                                    : AppPaths.vectors.logoDark,
                                isSvg: true,
                                width: r.size(100),
                              ).animate().fadeIn(delay: 100.ms),
                              if (errorMessage != null)
                                _buildNotificationMessageField(
                                    theme: theme,
                                    isRtl: isRtl,
                                    successMessage: successMessage,
                                    errorMessage: errorMessage),
                              _buildForm(
                                  theme: theme,
                                  ts: translationService,
                                  isRtl: isRtl),
                              _buildActionButtons(
                                theme: theme,
                                ts: translationService,
                                isRtl: isRtl,
                              ).animate().fadeIn(delay: 300.ms),
                              CustomField(
                                  isRtl: isRtl,
                                  gap: r.size(3),
                                  arrangement: FieldArrangement.row,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text: translationService
                                          .translate('global.or'),
                                      fontSize: r.size(8),
                                    ),
                                    CustomButton(
                                      text: translationService.translate(
                                          'global.authentication.createNewAccount'),
                                      textColor: theme.primary,
                                      onHoverStyle: CustomButtonStyle(
                                        textColor: theme.secondary,
                                      ),
                                      fontSize: r.size(8),
                                      onPressed: (position, size) {
                                        dismiss();
                                        _createAccountOverlay.show(
                                          translationService:
                                              translationService,
                                          theme: theme,
                                          isRtl: isRtl,
                                          themeStyle: themeStyle,
                                        );
                                      },
                                    ),
                                    CustomText(
                                      text: '|',
                                      fontSize: r.size(8),
                                    ),
                                    CustomButton(
                                      text: translationService.translate(
                                          'global.authentication.forgotPassword'),
                                      textColor: theme.primary,
                                      onHoverStyle: CustomButtonStyle(
                                        textColor: theme.secondary,
                                      ),
                                      fontSize: r.size(8),
                                      onPressed: (position, size) {
                                        dismiss();
                                        _requestResetPasswordOverlay.show(
                                          translationService:
                                              translationService,
                                          theme: theme,
                                          isRtl: isRtl,
                                          themeStyle: themeStyle,
                                          emailInput: _emailController.text,
                                        );
                                      },
                                    ),
                                  ]).animate().fadeIn(delay: 300.ms),
                            ],
                          );
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
