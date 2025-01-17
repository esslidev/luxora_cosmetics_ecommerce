import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/notification_type.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/remote_events_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../bloc/remote/auth/auth_bloc.dart';
import '../../../bloc/remote/auth/auth_state.dart';
import '../../../overlays/loading/loading.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/custom_tooltip.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? token;
  const ResetPasswordScreen({super.key, this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  late LoadingOverlay _loadingOverlay;

  // controllers
  late final TextEditingController _newPasswordController =
      TextEditingController();
  late final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.token == null) {
        Beamer.of(context).beamToNamed(AppPaths.routes.exploreScreen);
      }
      _loadingOverlay = LoadingOverlay(
        context: homeContext!,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordController.dispose();
    _passwordConfirmController.dispose();
  }

  bool _arePasswordInputsValid() {
    // If any password field is not empty, validate all fields
    return _newPasswordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty &&
        _newPasswordController.text == _passwordConfirmController.text &&
        AppUtil.isPasswordValid(_newPasswordController.text);
  }

  //---------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, themeState) {
      return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
        if (translationState.translationService != null &&
            translationState.language != null) {
          return BlocListener<RemoteAuthBloc, RemoteAuthState>(
            listener: (context, state) {
              if (state is RemoteAuthPasswordResetting) {
                _loadingOverlay.show(
                  theme: themeState.theme,
                  translationService: translationState.translationService!,
                  r: r,
                );
              }
              if (state is RemoteAuthPasswordResetted) {
                _loadingOverlay.dismiss();
                if (state.messageResponse != null) {
                  AppEventsUtil.liteNotifications.addLiteNotification(context,
                      notification: LiteNotificationModel(
                        notificationTitle: translationState.translationService!
                            .translate(
                                'global.notifications.passwordReseted.title'),
                        notificationMessage:
                            translationState.translationService!.translate(
                                'global.notifications.passwordReseted.message'),
                        notificationType: NotificationType.success,
                      ));
                  Beamer.of(context).beamToNamed(AppPaths.routes.exploreScreen);
                }
              }
              if (state is RemoteAuthError) {
                _loadingOverlay.dismiss();
                AppEventsUtil.liteNotifications.addLiteNotification(context,
                    notification: LiteNotificationModel(
                      notificationTitle: state.error?.response?.data["error"],
                      notificationMessage:
                          state.error?.response?.data["message"],
                      notificationType: NotificationType.error,
                    ));
              }
            },
            child: ResponsiveScreenAdapter(
              screenLargeDesktop: _buildResetPassword(
                context,
                themeState.theme,
                translationState.translationService!,
                translationState.language!,
              ),
              screenDesktop: _buildResetPassword(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                  isDesktop: true),
              screenTablet: _buildResetPassword(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                  isTablet: true),
              screenMobile: _buildResetPassword(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                  isMobile: true),
            ),
          );
        }
        return const SizedBox();
      });
    });
  }

  Widget _buildHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String title,
    required String subTitle,
  }) {
    return CustomField(
      isRtl: isRtl,
      children: [
        CustomText(
          text: title,
          color: theme.secondary,
          fontSize: r.size(14),
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          text: subTitle,
          fontSize: r.size(10),
        ),
      ],
    );
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

  Widget _buildResetPasswordForm({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    bool isTablet = false,
    bool isMobile = false,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _newPasswordController,
      builder: (context, passwordValue, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _passwordConfirmController,
          builder: (context, passwordConfirmValue, _) {
            return CustomField(
              isRtl: isRtl,
              gap: r.size(12),
              padding: isTablet || isMobile
                  ? r.symmetric(horizontal: 12)
                  : r.symmetric(horizontal: 40),
              children: [
                CustomTooltip(
                    richMessage: const [
                      TextSpan(
                        text: '- At least 8 characters\n',
                      ),
                      TextSpan(text: '- At least 1 uppercase letter\n'),
                      TextSpan(text: '- At least 1 lowercase letter\n'),
                      TextSpan(text: '- At least 1 number'),
                    ],
                    child: _buildTextInput(
                      theme: theme,
                      ts: ts,
                      isRtl: isRtl,
                      name: ts.translate('global.authentication.newPassword'),
                      hint:
                          ts.translate('global.authentication.newPasswordHint'),
                      obscureText: true,
                      controller: _newPasswordController,
                      borderColorCallback: (value) {
                        return value != ''
                            ? !AppUtil.isPasswordValid(value)
                                ? AppColors.colors.redRouge
                                : theme.primary
                            : null;
                      },
                    )),
                _buildTextInput(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  controller: _passwordConfirmController,
                  hint:
                      ts.translate('global.authentication.passwordConfirmHint'),
                  name: ts.translate('global.authentication.passwordConfirm'),
                  obscureText: true,
                  borderColorCallback: (value) {
                    return value != ''
                        ? value != passwordValue.text
                            ? AppColors.colors.redRouge
                            : theme.primary
                        : null;
                  },
                ),
                _buildSaveButton(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    isTablet: isTablet,
                    isMobile: isMobile),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSaveButton(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      bool isTablet = false,
      bool isMobile = false}) {
    return CustomButton(
      text: ts.translate('screens.resetPassword.saveButton'),
      useIntrinsicWidth: !isMobile,
      fontWeight: FontWeight.bold,
      fontSize: r.size(10),
      backgroundColor: theme.primary,
      textColor: AppColors.colors.whiteOut,
      padding: r.symmetric(vertical: 4, horizontal: 16),
      enabled: widget.token != null && _arePasswordInputsValid(),
      borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
        backgroundColor: theme.secondary,
      ),
      onDisabledStyle: CustomButtonStyle(
          backgroundColor: theme.secondaryBackgroundColor,
          textColor: theme.accent.withOpacity(0.3)),
      onPressed: (position, size) {
        RemoteEventsUtil.authEvents.resetPassword(context,
            token: widget.token!, newPassword: _newPasswordController.text);
      },
    );
  }

  Widget _buildResetPassword(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language,
      {bool isDesktop = false, bool isTablet = false, bool isMobile = false}) {
    return CustomField(
      isRtl: language.isRtl,
      padding: r.symmetric(
          horizontal: isDesktop
              ? 30
              : isTablet
                  ? 20
                  : isMobile
                      ? 10
                      : 140,
          vertical: 20),
      gap: r.size(20),
      children: [
        CustomField(isRtl: language.isRtl, gap: r.size(12), children: [
          _buildHeader(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
              title: ts.translate('screens.resetPassword.resetPasswordTitle'),
              subTitle:
                  ts.translate('screens.resetPassword.resetPasswordSubTitle')),
          _buildResetPasswordForm(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            isTablet: isTablet,
            isMobile: isMobile,
          )
        ]),
      ],
    );
  }
}
