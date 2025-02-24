import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/util/app_util.dart';
import '../../../../core/util/remote_events_util.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../bloc/remote/auth/auth_bloc.dart';
import '../../bloc/remote/auth/auth_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_display.dart';
import '../../widgets/common/custom_field.dart';
import '../../widgets/common/custom_text.dart';
import '../../widgets/common/custom_text_field.dart';
import '../create_account/create_account.dart';
import '../loading/loading.dart';
import '../sign_in/sign_in.dart';

class RequestResetPasswordOverlay {
  final BuildContext context;
  ResponsiveSizeAdapter r;
  final VoidCallback? onDismiss;

  RequestResetPasswordOverlay({
    required this.context,
    required this.r,
    this.onDismiss,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  late final LoadingOverlay _loadingOverlay = LoadingOverlay(
    context: context,
    r: r,
  );

  late final SignInOverlay _signInOverlay = SignInOverlay(
    context: context,
    r: r,
  );

  late final CreateAccountOverlay _createAccountOverlay = CreateAccountOverlay(
    context: context,
    r: r,
  );

  late final TextEditingController _emailController = TextEditingController();

  final ValueNotifier<String?> _successMessage = ValueNotifier(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);

  Future<void> show({
    String? emailInput,
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
            color: Colors.black.withValues(alpha: 0.6),
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
                  if (state is RemoteAuthPasswordResetRequesting) {
                    _loadingOverlay.show();
                  }
                  if (state is RemoteAuthPasswordResetRequested) {
                    _loadingOverlay.dismiss();
                    _errorMessage.value = null;
                    _successMessage.value = state.messageResponse;
                  }
                  if (state is RemoteAuthError) {
                    _loadingOverlay.dismiss();
                    _successMessage.value = null;
                    _errorMessage.value =
                        state.error?.response?.data["message"];
                  }
                },
                child: _buildOverlay().animate(target: toggle ? 1 : 0).fade(
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
    if (emailInput != null) {
      _emailController.text = emailInput;
    }
  }

  void dismiss() {
    if (isShown()) {
      toggle = false;
      _overlayEntry?.markNeedsBuild();
      // Delay the removal to allow the animation to play
      Future.delayed(300.ms, () {
        _emailController.text = '';
        _errorMessage.value = null;
        _successMessage.value = null;
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
        AppUtil.isEmailValid(_emailController.text);
  }

  //---------------------------------------//

  Widget _buildHeader() {
    return CustomDisplay(
      assetPath: AppPaths.vectors.logoIcon,
      isSvg: true,
      width: r.size(100),
    );
  }

  Widget _buildNotificationMessageField({
    String? successMessage,
    String? errorMessage,
  }) {
    return CustomField(
        width: double.infinity,
        borderRadius: r.size(1),
        padding: r.all(4),
        backgroundColor: successMessage != null
            ? AppColors.light.primary.withValues(alpha: 0.4)
            : AppColors.light.errorColor.withValues(alpha: 0.4),
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
      {required String name,
      required String hint,
      required TextEditingController controller,
      TextInputType? keyboardType,
      bool obscureText = false,
      Color? Function(String)? borderColorCallback,
      void Function(String value, Offset position, Size size)? onChanged}) {
    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (BuildContext context, TextEditingValue value, Widget? child) {
          return CustomField(gap: r.size(2), children: [
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
              backgroundColor: AppColors.light.secondaryBackgroundColor,
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

  _buildForm() {
    return CustomField(gap: r.size(12), children: [
      _buildTextInput(
        hint: 'John.doe@example.com',
        keyboardType: TextInputType.emailAddress,
        name: 'Email',
        controller: _emailController,
        borderColorCallback: (value) {
          return value != ''
              ? !AppUtil.isEmailValid(value)
                  ? AppColors.light.errorColor
                  : AppColors.light.primary
              : null;
        },
      ).animate().fadeIn(delay: 200.ms),
    ]);
  }

  Widget _buildActionButton(
      {required String title,
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
      backgroundColor: backgroundColor ?? AppColors.light.primary,
      textColor: textColor ?? AppColors.colors.whiteWhitest,
      padding: r.symmetric(vertical: 4, horizontal: 16),
      enabled: isEnabled,
      borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
          backgroundColor: onHoverbackgroundColor ?? AppColors.light.secondary,
          textColor: onHoverTextColor),
      onDisabledStyle: CustomButtonStyle(
          backgroundColor: AppColors.light.secondaryBackgroundColor,
          textColor: AppColors.light.accent.withValues(alpha: 0.3)),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildActionButtons() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _emailController,
      builder:
          (BuildContext context, TextEditingValue emailValue, Widget? child) {
        return CustomField(
          gap: r.size(6),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          arrangement: FieldArrangement.row,
          children: [
            _buildActionButton(
              title:
                  _errorMessage.value != null || _successMessage.value != null
                      ? 'Renvoyer la demande'
                      : 'Réinitialiser le mot de passe',
              isEnabled: _areInputsValid(),
              backgroundColor: AppColors.light.primary,
              onHoverbackgroundColor: AppColors.light.secondary,
              textColor: AppColors.colors.whiteWhitest,
              onHoverTextColor: AppColors.colors.whiteWhitest,
              onPressed: () {
                RemoteEventsUtil.authEvents
                    .requestPasswordReset(context, email: emailValue.text);
              },
            ),
            _buildActionButton(
              title: 'cancel',
              backgroundColor: AppColors.light.accent,
              onHoverbackgroundColor:
                  AppColors.light.accent.withValues(alpha: 0.8),
              textColor: AppColors.light.subtle,
              onPressed: () {
                dismiss();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverlay() {
    return IntrinsicHeight(
      child: CustomField(
        width: r.size(300),
        padding: r.symmetric(vertical: 10),
        margin: r.symmetric(horizontal: 6, vertical: 10),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        borderColor: AppColors.light.accent.withValues(alpha: 0.3),
        borderRadius: r.size(3),
        clipBehavior: Clip.hardEdge,
        gap: r.size(2),
        backgroundColor: AppColors.light.secondaryBackgroundColor,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            gap: r.size(14),
                            padding: r.symmetric(horizontal: 16, vertical: 22),
                            children: [
                              _buildHeader().animate().fadeIn(delay: 100.ms),
                              if (successMessage != null ||
                                  errorMessage != null)
                                _buildNotificationMessageField(
                                    successMessage: successMessage,
                                    errorMessage: errorMessage),
                              _buildForm(),
                              _buildActionButtons()
                                  .animate()
                                  .fadeIn(delay: 300.ms),
                              CustomField(
                                  gap: r.size(3),
                                  arrangement: FieldArrangement.row,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      text: 'or',
                                      fontSize: r.size(8),
                                    ),
                                    CustomButton(
                                      text: 'Se connecter à mon compte',
                                      textColor: AppColors.light.primary,
                                      onHoverStyle: CustomButtonStyle(
                                        textColor: AppColors.light.secondary,
                                      ),
                                      onPressed: (position, size) {
                                        dismiss();
                                        _signInOverlay.show();
                                      },
                                      fontSize: r.size(8),
                                    ),
                                    CustomText(
                                      text: '|',
                                      fontSize: r.size(8),
                                    ),
                                    CustomButton(
                                      text: 'Créer un nouveau compte',
                                      textColor: AppColors.light.primary,
                                      onHoverStyle: CustomButtonStyle(
                                        textColor: AppColors.light.secondary,
                                      ),
                                      fontSize: r.size(8),
                                      onPressed: (position, size) {
                                        dismiss();
                                        _createAccountOverlay.show();
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
