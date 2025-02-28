import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/notification_type.dart';

import '../../../../core/enums/widgets.dart';
import '../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../core/resources/moroccan_cities_list.dart';
import '../../../../core/util/app_events_util.dart';
import '../../../../core/util/app_util.dart';
import '../../../../core/util/custom_timer.dart';
import '../../../../core/util/remote_events_util.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../data/models/user.dart';
import '../../bloc/remote/auth/auth_bloc.dart';
import '../../bloc/remote/auth/auth_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_display.dart';
import '../../widgets/common/custom_field.dart';
import '../../widgets/common/custom_text.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_tooltip.dart';
import '../dropdown/dropdown.dart';
import '../loading/loading.dart';
import '../request_reset_password/request_reset_password.dart';
import '../sign_in/sign_in.dart';

class CreateAccountOverlay {
  final BuildContext context;
  final ResponsiveSizeAdapter r;
  final VoidCallback? onDismiss;

  CreateAccountOverlay({
    required this.context,
    required this.r,
    this.onDismiss,
  });

  OverlayEntry? _overlayEntry;
  bool toggle = false;

  final ScrollController _scrollController = ScrollController();

  late final LoadingOverlay _loadingOverlay = LoadingOverlay(
    context: context,
    r: r,
  );

  late final SignInOverlay _signInOverlay = SignInOverlay(
    context: context,
    r: r,
  );

  late final RequestResetPasswordOverlay _requestResetPasswordOverlay =
      RequestResetPasswordOverlay(
    context: context,
    r: r,
  );

  late final DropdownOverlay _moroccanCitiesDropdown = DropdownOverlay(
    context: context,
    borderRadius: Radius.circular(r.size(2)),
    borderWidth: r.size(1),
    margin: EdgeInsets.only(top: r.size(8)),
    shadowOffset: Offset(r.size(2), r.size(2)),
    shadowBlurRadius: 4,
  );

  final LayerLink _moroccanCitiesDropdownLayerLink = LayerLink();

  // controllers
  late final TextEditingController _firstNameController =
      TextEditingController();
  late final TextEditingController _lastNameController =
      TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _addressController = TextEditingController();
  late final TextEditingController _addressOptionalController =
      TextEditingController();
  late final TextEditingController _zipCodeController = TextEditingController();
  late final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _passwordConfirmController =
      TextEditingController();

  final Map<String, String> _cities = MoroccanCities.cities;
  CustomTimer? _cityInputDelayTimer;

  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);

  Future<void> show({
    Function()? onLoginPressed,
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
                  if (state is RemoteAuthSigningUp) {
                    _loadingOverlay.show();
                  }
                  if (state is RemoteAuthSignedUp) {
                    _loadingOverlay.dismiss();
                    RemoteEventsUtil.userEvents.getLoggedInUser(context);
                    RemoteEventsUtil.wishlistEvents.syncWishlist(
                      context,
                    );
                    RemoteEventsUtil.cartEvents.syncCart(
                      context,
                    );
                    dismiss();
                    AppEventsUtil.liteNotifications.addLiteNotification(context,
                        notification: LiteNotificationModel(
                          notificationTitle: "Compte Créé avec Succès",
                          notificationMessage:
                              "Votre compte a été créé avec succès. Bienvenue !",
                          notificationType: NotificationType.success,
                        ));
                  }
                  if (state is RemoteAuthError) {
                    _loadingOverlay.dismiss();
                    _scrollController.animateTo(
                      0,
                      duration: 400.ms,
                      curve: Curves.easeIn,
                    );
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
  }

  void dismiss() {
    if (isShown()) {
      toggle = false;
      _overlayEntry?.markNeedsBuild();
      // Delay the removal to allow the animation to play
      Future.delayed(300.ms, () {
        _firstNameController.text = '';
        _lastNameController.text = '';
        _emailController.text = '';
        _phoneController.text = '';
        _addressController.text = '';
        _addressOptionalController.text = '';
        _zipCodeController.text = '';
        _cityController.text = '';
        _passwordController.text = '';
        _passwordConfirmController.text = '';
        _errorMessage.value = null;
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  bool isShown() {
    return _overlayEntry != null;
  }

  //-----------------------------------------------//
  bool _areInputsValid() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        AppUtil.isEmailValid(_emailController.text) &&
        _phoneController.text.trim().isNotEmpty &&
        AppUtil.isPhoneNumberValid(_phoneController.text) &&
        _addressController.text.trim().isNotEmpty &&
        _cities.containsValue(_cityController.text) &&
        _zipCodeController.text.trim().isNotEmpty &&
        _passwordController.text == _passwordConfirmController.text &&
        AppUtil.isPasswordValid(_passwordController.text) &&
        AppUtil.isPasswordValid(_passwordConfirmController.text);
  }

  List<String> filteredCities(String value) {
    return _cities.values
        .where((city) => city.toLowerCase().startsWith(value.toLowerCase()))
        .toList();
  }

  //--------------------------------------------//

  Widget _buildCitiesDropdownChild({required String value}) {
    final ScrollController scrollController = ScrollController();

    List<Widget> cityButtons = filteredCities(value)
        .map((city) => CustomButton(
              text: city,
              fontSize: r.size(9),
              useIntrinsicWidth: false,
              mainAxisAlignment: MainAxisAlignment.start,
              onPressed: (position, size) {
                _cityController.text = city;
                _moroccanCitiesDropdown.dismiss();
              },
            ))
        .toList();

    return IntrinsicHeight(
      child: CustomField(
        maxHeight: r.size(100),
        children: [
          Expanded(
            child: RawScrollbar(
              thumbColor: AppColors.light.primary.withValues(alpha: 0.4),
              radius: Radius.circular(r.size(10)),
              thickness: r.size(5),
              thumbVisibility: true,
              controller: scrollController,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: CustomField(
                      padding: r.symmetric(vertical: 4, horizontal: 8),
                      children: cityButtons),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------//

  Widget _buildErrorMessageField({
    String? errorMessage,
  }) {
    return CustomField(
        width: double.infinity,
        borderRadius: r.size(1),
        padding: r.all(4),
        backgroundColor: AppColors.light.error.withValues(alpha: 0.4),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: errorMessage ?? '',
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
              backgroundColor: AppColors.light.backgroundSecondary,
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

  Widget _buildPasswordForm() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _passwordController,
      builder: (context, passwordValue, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _passwordConfirmController,
          builder: (context, passwordConfirmValue, _) {
            return CustomField(
              gap: r.size(12),
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
                    name: "Mot de passe",
                    hint: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    borderColorCallback: (value) {
                      return value != ''
                          ? !AppUtil.isPasswordValid(value)
                              ? AppColors.light.error
                              : AppColors.light.primary
                          : null;
                    },
                  ).animate().fadeIn(delay: 500.ms),
                ),
                _buildTextInput(
                  controller: _passwordConfirmController,
                  name: "Confirmez le mot de passe",
                  hint: 'Confirm Password',
                  obscureText: true,
                  borderColorCallback: (value) {
                    return value != ''
                        ? value != passwordValue.text
                            ? AppColors.light.error
                            : AppColors.light.primary
                        : null;
                  },
                ).animate().fadeIn(delay: 500.ms),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildForm() {
    return CustomField(
      gap: r.size(12),
      children: [
        _buildTextInput(
          hint: 'John',
          name: "Prénom",
          keyboardType: TextInputType.name,
          controller: _firstNameController,
          borderColorCallback: (value) {
            return value.trim().isNotEmpty ? AppColors.light.primary : null;
          },
        ).animate().fadeIn(delay: 200.ms),
        _buildTextInput(
          hint: 'Doe',
          name: "Nom",
          keyboardType: TextInputType.name,
          controller: _lastNameController,
          borderColorCallback: (value) {
            return value.trim().isNotEmpty ? AppColors.light.primary : null;
          },
        ).animate().fadeIn(delay: 200.ms),
        _buildTextInput(
          hint: '+212 00 00 00',
          keyboardType: TextInputType.phone,
          name: "Numéro de téléphone",
          controller: _phoneController,
          borderColorCallback: (value) {
            return value != ''
                ? !AppUtil.isPhoneNumberValid(value)
                    ? AppColors.light.error
                    : AppColors.light.primary
                : null;
          },
        ).animate().fadeIn(delay: 300.ms),
        _buildTextInput(
          hint: "Adresse",
          name: "Adresse",
          keyboardType: TextInputType.streetAddress,
          controller: _addressController,
          borderColorCallback: (value) {
            return value.trim().isNotEmpty ? AppColors.light.primary : null;
          },
        ).animate().fadeIn(delay: 300.ms),
        _buildTextInput(
                hint: "Adresse (optionnel)",
                name: "Adresse (optionnel)",
                keyboardType: TextInputType.streetAddress,
                controller: _addressOptionalController)
            .animate()
            .fadeIn(delay: 400.ms),
        CustomField(
            gap: r.size(8),
            arrangement: FieldArrangement.row,
            children: [
              Expanded(
                child: CompositedTransformTarget(
                  link: _moroccanCitiesDropdownLayerLink,
                  child: _buildTextInput(
                    hint: "Ville",
                    name: "Ville",
                    controller: _cityController,
                    borderColorCallback: (value) {
                      return value != ''
                          ? !_cities.containsValue(value)
                              ? AppColors.light.error
                              : AppColors.light.primary
                          : null;
                    },
                    onChanged: (value, position, size) {
                      if (filteredCities(value).isNotEmpty) {
                        _cityInputDelayTimer?.stop();
                        _cityInputDelayTimer = CustomTimer(
                          onTick: (_) {},
                          onTimerStop: () {
                            _moroccanCitiesDropdown.show(
                                layerLink: _moroccanCitiesDropdownLayerLink,
                                backgroundColor:
                                    AppColors.light.backgroundSecondary,
                                borderColor: AppColors.light.accent
                                    .withValues(alpha: 0.4),
                                shadowColor: AppColors.light.accent
                                    .withValues(alpha: .2),
                                forceRefresh: true,
                                targetWidgetSize: r.scaledSize(height: 34),
                                width: size.width,
                                dropdownAlignment: DropdownAlignment.start,
                                child: _buildCitiesDropdownChild(
                                  value: value,
                                ));
                          },
                        );
                        _cityInputDelayTimer!.start(duration: 1000.ms);
                      } else {
                        _moroccanCitiesDropdown.dismiss();
                        _cityInputDelayTimer?.stop();
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: _buildTextInput(
                  hint: "Code Postal",
                  name: "Code Postal",
                  controller: _zipCodeController,
                  borderColorCallback: (value) {
                    return value.trim().isNotEmpty
                        ? AppColors.light.primary
                        : null;
                  },
                ),
              ),
            ]).animate().fadeIn(delay: 400.ms),
        _buildTextInput(
          hint: 'John.doe@example.com',
          keyboardType: TextInputType.emailAddress,
          name: "Email",
          controller: _emailController,
          borderColorCallback: (value) {
            return value != ''
                ? !AppUtil.isEmailValid(value)
                    ? AppColors.light.error
                    : AppColors.light.primary
                : null;
          },
        ).animate().fadeIn(delay: 500.ms),
        _buildPasswordForm()
      ],
    );
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
      textColor: textColor ?? AppColors.colors.white,
      padding: r.symmetric(vertical: 4, horizontal: 16),
      enabled: isEnabled,
      borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
          backgroundColor: onHoverbackgroundColor ?? AppColors.light.secondary,
          textColor: onHoverTextColor),
      onDisabledStyle: CustomButtonStyle(
          backgroundColor: AppColors.light.backgroundSecondary,
          textColor: AppColors.light.accent.withValues(alpha: 0.3)),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildActionButtons() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _firstNameController,
      builder: (BuildContext context, TextEditingValue firstNameValue,
          Widget? child) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _lastNameController,
          builder: (BuildContext context, TextEditingValue lastNameValue,
              Widget? child) {
            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: _emailController,
              builder: (BuildContext context, TextEditingValue emailValue,
                  Widget? child) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _phoneController,
                  builder: (BuildContext context, TextEditingValue phoneValue,
                      Widget? child) {
                    return ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _addressController,
                      builder: (BuildContext context,
                          TextEditingValue addressValue, Widget? child) {
                        return ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _addressOptionalController,
                          builder: (BuildContext context,
                              TextEditingValue addressOptionalValue,
                              Widget? child) {
                            return ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _zipCodeController,
                              builder: (BuildContext context,
                                  TextEditingValue zipCodeValue,
                                  Widget? child) {
                                return ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _cityController,
                                  builder: (BuildContext context,
                                      TextEditingValue cityValue,
                                      Widget? child) {
                                    return ValueListenableBuilder<
                                        TextEditingValue>(
                                      valueListenable: _passwordController,
                                      builder: (BuildContext context,
                                          TextEditingValue passwordValue,
                                          Widget? child) {
                                        return ValueListenableBuilder<
                                            TextEditingValue>(
                                          valueListenable:
                                              _passwordConfirmController,
                                          builder: (BuildContext context,
                                              TextEditingValue
                                                  passwordConfirmValue,
                                              Widget? child) {
                                            return CustomField(
                                              gap: r.size(6),
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              arrangement: FieldArrangement.row,
                                              children: [
                                                _buildActionButton(
                                                  title: "Créer",
                                                  isEnabled: _areInputsValid(),
                                                  backgroundColor:
                                                      AppColors.light.primary,
                                                  onHoverbackgroundColor:
                                                      AppColors.light.secondary,
                                                  textColor:
                                                      AppColors.colors.white,
                                                  onHoverTextColor:
                                                      AppColors.colors.white,
                                                  onPressed: () {
                                                    RemoteEventsUtil.authEvents
                                                        .signUp(
                                                            context,
                                                            UserModel(
                                                              firstName:
                                                                  firstNameValue
                                                                      .text,
                                                              lastName:
                                                                  lastNameValue
                                                                      .text,
                                                              phone: phoneValue
                                                                  .text,
                                                              addressMain:
                                                                  addressValue
                                                                      .text,
                                                              addressSecond:
                                                                  addressOptionalValue
                                                                      .text,
                                                              email: emailValue
                                                                  .text,
                                                              password:
                                                                  passwordValue
                                                                      .text,
                                                              city: cityValue
                                                                  .text,
                                                              zip: zipCodeValue
                                                                  .text,
                                                            ));
                                                  },
                                                ),
                                                _buildActionButton(
                                                  title: "Annuler",
                                                  backgroundColor:
                                                      AppColors.light.accent,
                                                  onHoverbackgroundColor:
                                                      AppColors.light.accent
                                                          .withValues(
                                                              alpha: 0.8),
                                                  textColor:
                                                      AppColors.light.subtle,
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
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOverlay() {
    return IntrinsicHeight(
      child: CustomField(
        width: r.size(300),
        padding: r.symmetric(vertical: 10),
        margin: r.symmetric(horizontal: 6, vertical: 20),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        borderColor: AppColors.light.accent.withValues(alpha: 0.3),
        borderRadius: r.size(3),
        clipBehavior: Clip.hardEdge,
        gap: r.size(2),
        backgroundColor: AppColors.light.backgroundSecondary,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: RawScrollbar(
              thumbColor: AppColors.light.primary.withValues(alpha: 0.4),
              radius: Radius.circular(r.size(10)),
              thickness: r.size(5),
              thumbVisibility: true,
              controller: _scrollController,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: ValueListenableBuilder(
                      valueListenable: _errorMessage,
                      builder: (BuildContext context, String? errorMessage,
                          Widget? child) {
                        return CustomField(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          gap: r.size(14),
                          padding: r.all(16),
                          children: [
                            CustomDisplay(
                              assetPath: AppPaths.vectors.logo,
                              isSvg: true,
                              width: r.size(100),
                            ).animate().fadeIn(delay: 100.ms),
                            if (errorMessage != null)
                              _buildErrorMessageField(
                                  errorMessage: errorMessage),
                            _buildForm(),
                            CustomField(
                              width: r.size(250),
                              arrangement: FieldArrangement.row,
                              children: [
                                Flexible(
                                  child: CustomText(
                                    text:
                                        "En créant un compte, vous acceptez la Politique de confidentialité et les Conditions générales de vente de Librairie Alfia.",
                                    fontSize: r.size(10),
                                  ),
                                )
                              ],
                            ).animate().fadeIn(delay: 600.ms),
                            _buildActionButtons()
                                .animate()
                                .fadeIn(delay: 600.ms),
                            CustomField(
                                gap: r.size(3),
                                arrangement: FieldArrangement.row,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    text: "Ou",
                                    fontSize: r.size(8),
                                  ),
                                  CustomButton(
                                    text: "Se connecter à mon compte",
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
                                    text: 'Mot de passe oublié ?',
                                    textColor: AppColors.light.primary,
                                    onHoverStyle: CustomButtonStyle(
                                      textColor: AppColors.light.secondary,
                                    ),
                                    fontSize: r.size(8),
                                    onPressed: (position, size) {
                                      dismiss();
                                      _requestResetPasswordOverlay.show();
                                    },
                                  ),
                                ]).animate().fadeIn(delay: 600.ms),
                          ],
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
