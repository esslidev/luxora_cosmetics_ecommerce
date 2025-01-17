import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/core/resources/moroccan_cities_list.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/notification_type.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/custom_timer.dart';
import '../../../../../core/util/remote_events_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../../data/models/user.dart';
import '../../../../domain/entities/user.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../bloc/remote/user/user_bloc.dart';
import '../../../bloc/remote/user/user_state.dart';
import '../../../overlays/dropdown/dropdown.dart';
import '../../../overlays/loading/loading.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/custom_tooltip.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  late LoadingOverlay _loadingOverlay;

  late final DropdownOverlay _moroccanCitiesDropdown;
  final LayerLink _moroccanCitiesDropdownLayerLink = LayerLink();

  // defauls values
  late String _defaultFirstNameValue = '';
  late String _defaultLastNameValue = '';
  late String _defaultEmailValue = '';
  late String _defaultPhoneValue = '';
  late String _defaultAddressValue = '';
  late String _defaultAddressOptionalValue = '';
  late String _defaultCityValue = '';
  late String _defaultZipCodeValue = '';

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
  late final TextEditingController _recentPasswordController =
      TextEditingController();
  late final TextEditingController _newPasswordController =
      TextEditingController();
  late final TextEditingController _passwordConfirmController =
      TextEditingController();

  final Map<String, String> _cities = MoroccanCities.cities;
  CustomTimer? _cityInputDelayTimer;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadingOverlay = LoadingOverlay(
        context: homeContext!,
      );
      _moroccanCitiesDropdown = DropdownOverlay(
        context: homeContext!,
        borderRadius: Radius.circular(r.size(2)),
        borderWidth: r.size(1),
        margin: EdgeInsets.only(top: r.size(8)),
        shadowOffset: Offset(r.size(2), r.size(2)),
        shadowBlurRadius: 4,
      );
      AppEventsUtil.breadCrumbs.clearBreadCrumbs(
        context,
      );
      RemoteEventsUtil.userEvents.getLoggedInUser(context, onEditProfile: true);
    });
  }

  @override
  void dispose() {
    super.dispose();

    _defaultFirstNameValue = '';
    _defaultLastNameValue = '';
    _defaultEmailValue = '';
    _defaultPhoneValue = '';
    _defaultAddressValue = '';
    _defaultAddressOptionalValue = '';
    _defaultCityValue = '';
    _defaultZipCodeValue = '';

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _addressOptionalController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    _recentPasswordController.dispose();
    _newPasswordController.dispose();
    _passwordConfirmController.dispose();
  }

  void _initGeneralInputs({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? addressOptional,
    String? zipCode,
    String? city,
  }) {
    if (firstName != null) {
      _firstNameController.text = firstName;
      _defaultFirstNameValue = firstName;
    }
    if (lastName != null) {
      _lastNameController.text = lastName;
      _defaultLastNameValue = lastName;
    }
    if (email != null) {
      _emailController.text = email;
      _defaultEmailValue = email;
    }
    if (phone != null) {
      _phoneController.text = phone;
      _defaultPhoneValue = phone;
    }
    if (address != null) {
      _addressController.text = address;
      _defaultAddressValue = address;
    }
    if (addressOptional != null) {
      _addressOptionalController.text = addressOptional;
      _defaultAddressOptionalValue = addressOptional;
    } else {
      _addressOptionalController.text = '';
      _defaultAddressOptionalValue = '';
    }
    if (zipCode != null) {
      _zipCodeController.text = zipCode;
      _defaultZipCodeValue = zipCode;
    }
    if (city != null) {
      _cityController.text = city;
      _defaultCityValue = city;
    }
  }

  void _initPasswordInputs() {
    _recentPasswordController.text = '';
    _newPasswordController.text = '';
    _passwordConfirmController.text = '';
  }

  void _setDefaultInputValues() {
    _firstNameController.text = _defaultFirstNameValue;
    _lastNameController.text = _defaultLastNameValue;
    _emailController.text = _defaultEmailValue;
    _phoneController.text = _defaultPhoneValue;
    _addressController.text = _defaultAddressValue;
    _addressOptionalController.text = _defaultAddressOptionalValue;
    _zipCodeController.text = _defaultZipCodeValue;
    _cityController.text = _defaultCityValue;
    _recentPasswordController.text = '';
    _newPasswordController.text = '';
    _passwordConfirmController.text = '';
  }

  bool _areGeneralInputsAsDefault() {
    return _firstNameController.text == _defaultFirstNameValue &&
        _lastNameController.text == _defaultLastNameValue &&
        _emailController.text == _defaultEmailValue &&
        _phoneController.text == _defaultPhoneValue &&
        _addressController.text == _defaultAddressValue &&
        _addressOptionalController.text == _defaultAddressOptionalValue &&
        _zipCodeController.text == _defaultZipCodeValue &&
        _cityController.text == _defaultCityValue;
  }

  bool _arePasswordInputsAsDefault() {
    return _recentPasswordController.text.isEmpty &&
        _newPasswordController.text.isEmpty &&
        _passwordConfirmController.text.isEmpty;
  }

  bool _areGeneralInputsValid() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        AppUtil.isEmailValid(_emailController.text) &&
        _phoneController.text.trim().isNotEmpty &&
        AppUtil.isPhoneNumberValid(_phoneController.text) &&
        _addressController.text.trim().isNotEmpty &&
        _cities.containsValue(_cityController.text) &&
        _zipCodeController.text.trim().isNotEmpty;
  }

  bool _arePasswordInputsValid() {
    // If all password fields are empty, they are valid
    if (_recentPasswordController.text.isEmpty &&
        _newPasswordController.text.isEmpty &&
        _passwordConfirmController.text.isEmpty) {
      return true;
    }

    // If any password field is not empty, validate all fields
    return _recentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty &&
        _newPasswordController.text == _passwordConfirmController.text &&
        AppUtil.isPasswordValid(_recentPasswordController.text) &&
        AppUtil.isPasswordValid(_newPasswordController.text);
  }

  List<String> filteredCities(String value) {
    return _cities.values
        .where((city) => city.toLowerCase().startsWith(value.toLowerCase()))
        .toList();
  }

  //---------------------------------------------------------------//

  Widget _buildCitiesDropdownChild(
      {required BaseTheme theme, required bool isRtl, required String value}) {
    final ScrollController scrollController = ScrollController();

    List<Widget> cityButtons = filteredCities(value)
        .map((city) => CustomButton(
              text: city,
              fontSize: r.size(9),
              useIntrinsicWidth: false,
              mainAxisAlignment: MainAxisAlignment.start,
              onPressed: (position, size) {
                setState(() {
                  _cityController.text = city;
                  _moroccanCitiesDropdown.dismiss();
                });
              },
            ))
        .toList();

    return IntrinsicHeight(
      child: CustomField(
        maxHeight: r.size(100),
        children: [
          Expanded(
            child: RawScrollbar(
              thumbColor: theme.primary.withOpacity(0.4),
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
                      isRtl: isRtl,
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

  //---------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, themeState) {
      return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
        if (translationState.translationService != null &&
            translationState.language != null) {
          return BlocListener<RemoteUserBloc, RemoteUserState>(
            listener: (context, state) {
              if (state is RemoteUserLoading) {
                if (state.userOnEditProfileLoading == true) {
                  _loadingOverlay.show(
                    translationService: translationState.translationService!,
                    r: r,
                    theme: themeState.theme,
                  );
                }
              }
              if (state is RemoteUserLoaded) {
                _loadingOverlay.dismiss();
                if (state.userOnEditProfile != null) {
                  setState(() {
                    UserEntity? userResponse = state.userOnEditProfile;
                    _initGeneralInputs(
                      firstName: userResponse?.firstName,
                      lastName: userResponse?.lastName,
                      email: userResponse?.email,
                      phone: userResponse?.phone,
                      address: userResponse?.addressMain,
                      addressOptional: userResponse?.addressSecond,
                      zipCode: userResponse?.zip,
                      city: userResponse?.city,
                    );
                    _initPasswordInputs();
                  });
                }
              }
              if (state is RemoteUserUpdating) {
                _loadingOverlay.show(
                  translationService: translationState.translationService!,
                  r: r,
                  theme: themeState.theme,
                );
              }
              if (state is RemoteUserUpdated) {
                _loadingOverlay.dismiss();
                if (state.userOnEditProfile != null) {
                  setState(() {
                    UserEntity? userResponse = state.userOnEditProfile;
                    _initGeneralInputs(
                      firstName: userResponse?.firstName,
                      lastName: userResponse?.lastName,
                      email: userResponse?.email,
                      phone: userResponse?.phone,
                      address: userResponse?.addressMain,
                      addressOptional: userResponse?.addressSecond,
                      zipCode: userResponse?.zip,
                      city: userResponse?.city,
                    );
                  });
                  AppEventsUtil.liteNotifications.addLiteNotification(context,
                      notification: LiteNotificationModel(
                        notificationTitle: translationState.translationService!
                            .translate(
                                'global.notifications.userDataUpdated.title'),
                        notificationMessage:
                            translationState.translationService!.translate(
                                'global.notifications.userDataUpdated.message'),
                        notificationType: NotificationType.success,
                      ));
                }
              }
              if (state is RemoteUserPasswordUpdated) {
                _loadingOverlay.dismiss();
                if (state.userOnEditProfile != null) {
                  setState(() {
                    _initPasswordInputs();
                  });
                  AppEventsUtil.liteNotifications.addLiteNotification(context,
                      notification: LiteNotificationModel(
                        notificationTitle: translationState.translationService!
                            .translate(
                                'global.notifications.userPasswordUpdated.title'),
                        notificationMessage:
                            translationState.translationService!.translate(
                                'global.notifications.userPasswordUpdated.message'),
                        notificationType: NotificationType.success,
                      ));
                }
              }
              if (state is RemoteUserError) {
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
              screenLargeDesktop: _buildEditProfile(
                context,
                themeState.theme,
                translationState.translationService!,
                translationState.language!,
              ),
              screenDesktop: _buildEditProfile(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                  isDesktop: true),
              screenTablet: _buildEditProfile(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!,
                  isTablet: true),
              screenMobile: _buildEditProfile(
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

  Widget _buildEditProfileForm({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    bool isTablet = false,
  }) {
    return CustomField(
      gap: r.size(12),
      isRtl: isRtl,
      padding: r.symmetric(horizontal: isTablet ? 12 : 40),
      children: [
        CustomField(
            isRtl: isRtl,
            gap: isTablet ? r.size(8) : r.size(12),
            arrangement: FieldArrangement.row,
            children: [
              Expanded(
                child: _buildTextInput(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  hint: 'John',
                  name: ts.translate('global.authentication.firstName'),
                  keyboardType: TextInputType.name,
                  controller: _firstNameController,
                  borderColorCallback: (value) {
                    return value.trim().isEmpty
                        ? AppColors.colors.redRouge
                        : value != _defaultFirstNameValue
                            ? theme.primary
                            : null;
                  },
                ),
              ),
              Expanded(
                child: _buildTextInput(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  hint: 'Doe',
                  name: ts.translate('global.authentication.lastName'),
                  keyboardType: TextInputType.name,
                  controller: _lastNameController,
                  borderColorCallback: (value) {
                    return value.trim().isEmpty
                        ? AppColors.colors.redRouge
                        : value != _defaultLastNameValue
                            ? theme.primary
                            : null;
                  },
                ),
              ),
            ]),
        CustomField(
            isRtl: isRtl,
            gap: isTablet ? r.size(8) : r.size(12),
            arrangement: FieldArrangement.row,
            children: [
              Expanded(
                child: _buildTextInput(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  hint: 'John.doe@example.com',
                  keyboardType: TextInputType.emailAddress,
                  name: ts.translate('global.authentication.email'),
                  controller: _emailController,
                  borderColorCallback: (value) {
                    return !AppUtil.isEmailValid(value)
                        ? AppColors.colors.redRouge
                        : value != _defaultEmailValue
                            ? theme.primary
                            : null;
                  },
                ),
              ),
              Expanded(
                child: _buildTextInput(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  hint: '+212 00 00 00',
                  keyboardType: TextInputType.phone,
                  name: ts.translate('global.authentication.phone'),
                  controller: _phoneController,
                  borderColorCallback: (value) {
                    return !AppUtil.isPhoneNumberValid(value)
                        ? AppColors.colors.redRouge
                        : value != _defaultPhoneValue
                            ? theme.primary
                            : null;
                  },
                ),
              ),
            ]),
      ],
    );
  }

  Widget _buildMobileEditProfileForm({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      isRtl: isRtl,
      gap: r.size(12),
      padding: r.symmetric(horizontal: 12),
      children: [
        CustomField(
            isRtl: isRtl,
            gap: r.size(8),
            arrangement: FieldArrangement.column,
            children: [
              _buildTextInput(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                hint: 'John',
                name: ts.translate('global.authentication.firstName'),
                keyboardType: TextInputType.name,
                controller: _firstNameController,
                borderColorCallback: (value) {
                  return value.isEmpty
                      ? AppColors.colors.redRouge
                      : value != _defaultFirstNameValue
                          ? theme.primary
                          : null;
                },
              ),
              _buildTextInput(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                hint: 'Doe',
                name: ts.translate('global.authentication.lastName'),
                keyboardType: TextInputType.name,
                controller: _lastNameController,
                borderColorCallback: (value) {
                  return value.isEmpty
                      ? AppColors.colors.redRouge
                      : value != _defaultLastNameValue
                          ? theme.primary
                          : null;
                },
              ),
              _buildTextInput(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                hint: 'John.doe@example.com',
                keyboardType: TextInputType.emailAddress,
                name: ts.translate('global.authentication.email'),
                controller: _emailController,
                borderColorCallback: (value) {
                  return !AppUtil.isEmailValid(value)
                      ? AppColors.colors.redRouge
                      : value != _defaultEmailValue
                          ? theme.primary
                          : null;
                },
              ),
              _buildTextInput(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                hint: '+212 00 00 00',
                keyboardType: TextInputType.phone,
                name: ts.translate('global.authentication.phone'),
                controller: _phoneController,
                borderColorCallback: (value) {
                  return !AppUtil.isPhoneNumberValid(value)
                      ? AppColors.colors.redRouge
                      : value != _defaultPhoneValue
                          ? theme.primary
                          : null;
                },
              ),
            ]),
      ],
    );
  }

  Widget _buildShippingForm(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      bool isTablet = false,
      bool isMobile = false}) {
    return CustomField(
      isRtl: isRtl,
      gap: r.size(12),
      padding: r.symmetric(horizontal: isTablet || isMobile ? 12 : 40),
      children: [
        CustomField(isRtl: isRtl, gap: r.size(12), children: [
          _buildTextInput(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            hint: ts.translate('global.authentication.address'),
            name: ts.translate('global.authentication.address'),
            keyboardType: TextInputType.streetAddress,
            controller: _addressController,
            borderColorCallback: (value) {
              return value.trim().isEmpty
                  ? AppColors.colors.redRouge
                  : value != _defaultAddressValue
                      ? theme.primary
                      : null;
            },
          ),
          _buildTextInput(
              theme: theme,
              ts: ts,
              isRtl: isRtl,
              hint: ts.translate('global.authentication.addressOptional'),
              name: ts.translate('global.authentication.addressOptional'),
              keyboardType: TextInputType.streetAddress,
              controller: _addressOptionalController),
        ]),
        CustomField(
            isRtl: isRtl,
            gap: isTablet || isMobile ? r.size(8) : r.size(12),
            arrangement: FieldArrangement.row,
            children: [
              Expanded(
                child: CompositedTransformTarget(
                  link: _moroccanCitiesDropdownLayerLink,
                  child: _buildTextInput(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    hint: ts.translate('global.authentication.city'),
                    name: ts.translate('global.authentication.city'),
                    controller: _cityController,
                    borderColorCallback: (value) {
                      return !_cities.containsValue(value)
                          ? AppColors.colors.redRouge
                          : value != _defaultCityValue
                              ? theme.primary
                              : null;
                    },
                    onChanged: (value, position, size) {
                      if (value != _defaultCityValue &&
                          filteredCities(value).isNotEmpty) {
                        _cityInputDelayTimer?.stop();
                        _cityInputDelayTimer = CustomTimer(
                          onTick: (_) {},
                          onTimerStop: () {
                            _moroccanCitiesDropdown.show(
                                layerLink: _moroccanCitiesDropdownLayerLink,
                                backgroundColor: theme.overlayBackgroundColor,
                                borderColor: theme.accent.withOpacity(0.4),
                                shadowColor: theme.shadowColor,
                                forceRefresh: true,
                                targetWidgetSize: r.scaledSize(height: 34),
                                width: size.width,
                                dropdownAlignment: DropdownAlignment.start,
                                child: _buildCitiesDropdownChild(
                                    theme: theme, value: value, isRtl: isRtl));
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
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  hint: ts.translate('global.authentication.zipCode'),
                  name: ts.translate('global.authentication.zipCode'),
                  controller: _zipCodeController,
                  borderColorCallback: (value) {
                    return value.trim().isEmpty
                        ? AppColors.colors.redRouge
                        : value != _defaultZipCodeValue
                            ? theme.primary
                            : null;
                  },
                ),
              ),
            ]),
      ],
    );
  }

  Widget _buildPasswordInput({
    required TextEditingController controller,
    required String hint,
    required String name,
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required bool isPasswordConfirm,
    TextEditingValue? recentPasswordValue,
    TextEditingValue? newPasswordValue,
    TextEditingValue? passwordConfirmValue,
  }) {
    return _buildTextInput(
      theme: theme,
      ts: ts,
      isRtl: isRtl,
      hint: hint,
      name: name,
      obscureText: true,
      controller: controller,
      borderColorCallback: (value) {
        if (isPasswordConfirm) {
          // Directly use _newPasswordController
          return (!AppUtil.isPasswordValid(value) ||
                      value != _newPasswordController.text) &&
                  (recentPasswordValue?.text.isNotEmpty == true ||
                      newPasswordValue?.text.isNotEmpty == true ||
                      passwordConfirmValue?.text.isNotEmpty == true)
              ? AppColors.colors.redRouge
              : null;
        }
        return !AppUtil.isPasswordValid(value) &&
                (recentPasswordValue?.text.isNotEmpty == true ||
                    newPasswordValue?.text.isNotEmpty == true ||
                    passwordConfirmValue?.text.isNotEmpty == true)
            ? AppColors.colors.redRouge
            : null;
      },
    );
  }

  Widget _buildChangePasswordForm({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _recentPasswordController,
      builder: (context, recentPasswordValue, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _newPasswordController,
          builder: (context, newPasswordValue, _) {
            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: _passwordConfirmController,
              builder: (context, passwordConfirmValue, _) {
                return CustomField(
                  isRtl: isRtl,
                  gap: r.size(12),
                  padding: r.symmetric(horizontal: 40),
                  children: [
                    _buildPasswordInput(
                      controller: _recentPasswordController,
                      hint: ts.translate(
                          'global.authentication.recentPasswordHint'),
                      name:
                          ts.translate('global.authentication.recentPassword'),
                      theme: theme,
                      ts: ts,
                      isRtl: isRtl,
                      isPasswordConfirm: false,
                      recentPasswordValue: recentPasswordValue,
                      newPasswordValue: newPasswordValue,
                      passwordConfirmValue: passwordConfirmValue,
                    ),
                    CustomField(
                      isRtl: isRtl,
                      gap: r.size(12),
                      arrangement: FieldArrangement.row,
                      children: [
                        Expanded(
                          child: CustomTooltip(
                            richMessage: const [
                              TextSpan(text: '- At least 8 characters\n'),
                              TextSpan(text: '- At least 1 uppercase letter\n'),
                              TextSpan(text: '- At least 1 lowercase letter\n'),
                              TextSpan(text: '- At least 1 number'),
                            ],
                            child: _buildPasswordInput(
                              controller: _newPasswordController,
                              hint: ts.translate(
                                  'global.authentication.newPasswordHint'),
                              name: ts.translate(
                                  'global.authentication.newPassword'),
                              theme: theme,
                              ts: ts,
                              isRtl: isRtl,
                              isPasswordConfirm: false,
                              recentPasswordValue: recentPasswordValue,
                              newPasswordValue: newPasswordValue,
                              passwordConfirmValue: passwordConfirmValue,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildPasswordInput(
                            controller: _passwordConfirmController,
                            hint: ts.translate(
                                'global.authentication.passwordConfirmHint'),
                            name: ts.translate(
                                'global.authentication.passwordConfirm'),
                            theme: theme,
                            ts: ts,
                            isRtl: isRtl,
                            isPasswordConfirm: true,
                            recentPasswordValue: recentPasswordValue,
                            newPasswordValue: newPasswordValue,
                            passwordConfirmValue: passwordConfirmValue,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTabletMobileChangePasswordForm({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _recentPasswordController,
      builder: (context, recentPasswordValue, _) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: _newPasswordController,
          builder: (context, newPasswordValue, _) {
            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: _passwordConfirmController,
              builder: (context, passwordConfirmValue, _) {
                return CustomField(
                  isRtl: isRtl,
                  gap: r.size(12),
                  padding: r.symmetric(horizontal: 12),
                  children: [
                    _buildPasswordInput(
                      controller: _recentPasswordController,
                      hint: ts.translate(
                          'global.authentication.recentPasswordHint'),
                      name:
                          ts.translate('global.authentication.recentPassword'),
                      theme: theme,
                      ts: ts,
                      isRtl: isRtl,
                      isPasswordConfirm: false,
                      recentPasswordValue: recentPasswordValue,
                      newPasswordValue: newPasswordValue,
                      passwordConfirmValue: passwordConfirmValue,
                    ),
                    CustomTooltip(
                      richMessage: const [
                        TextSpan(text: '- At least 8 characters\n'),
                        TextSpan(text: '- At least 1 uppercase letter\n'),
                        TextSpan(text: '- At least 1 lowercase letter\n'),
                        TextSpan(text: '- At least 1 number'),
                      ],
                      child: _buildPasswordInput(
                        controller: _newPasswordController,
                        hint: ts
                            .translate('global.authentication.newPasswordHint'),
                        name: ts.translate('global.authentication.newPassword'),
                        theme: theme,
                        ts: ts,
                        isRtl: isRtl,
                        isPasswordConfirm: false,
                        recentPasswordValue: recentPasswordValue,
                        newPasswordValue: newPasswordValue,
                        passwordConfirmValue: passwordConfirmValue,
                      ),
                    ),
                    _buildPasswordInput(
                      controller: _passwordConfirmController,
                      hint: ts.translate(
                          'global.authentication.passwordConfirmHint'),
                      name:
                          ts.translate('global.authentication.passwordConfirm'),
                      theme: theme,
                      ts: ts,
                      isRtl: isRtl,
                      isPasswordConfirm: true,
                      recentPasswordValue: recentPasswordValue,
                      newPasswordValue: newPasswordValue,
                      passwordConfirmValue: passwordConfirmValue,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
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
      bool useIntrinsicWidth = true,
      required Function() onPressed}) {
    return CustomButton(
      text: title,
      useIntrinsicWidth: useIntrinsicWidth,
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
    bool isTablet = false,
    bool isMobile = false,
  }) {
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
                                      valueListenable:
                                          _recentPasswordController,
                                      builder: (BuildContext context,
                                          TextEditingValue recentPasswordValue,
                                          Widget? child) {
                                        return ValueListenableBuilder<
                                            TextEditingValue>(
                                          valueListenable:
                                              _newPasswordController,
                                          builder: (BuildContext context,
                                              TextEditingValue newPasswordValue,
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
                                                  isRtl: isRtl,
                                                  gap: r.size(4),
                                                  padding: r.symmetric(
                                                      horizontal:
                                                          isTablet || isMobile
                                                              ? 12
                                                              : 40),
                                                  arrangement: !isMobile
                                                      ? FieldArrangement.row
                                                      : FieldArrangement.column,
                                                  children: [
                                                    _buildActionButton(
                                                      theme: theme,
                                                      ts: ts,
                                                      isRtl: isRtl,
                                                      title: ts.translate(
                                                          'global.saveChanges'),
                                                      useIntrinsicWidth:
                                                          !isMobile,
                                                      isEnabled: _areGeneralInputsValid() &&
                                                          _arePasswordInputsValid() &&
                                                          (!_areGeneralInputsAsDefault() ||
                                                              !_arePasswordInputsAsDefault()),
                                                      onPressed: () {
                                                        if (!_areGeneralInputsAsDefault()) {
                                                          RemoteEventsUtil.userEvents.updateUser(
                                                              context,
                                                              user: UserModel(
                                                                  firstName: AppUtil.capitalizeWords(
                                                                      firstNameValue
                                                                          .text),
                                                                  lastName: AppUtil.capitalizeWords(
                                                                      lastNameValue
                                                                          .text),
                                                                  email: AppUtil.capitalizeFirstLetter(
                                                                      emailValue
                                                                          .text),
                                                                  phone:
                                                                      phoneValue
                                                                          .text,
                                                                  addressMain:
                                                                      AppUtil.capitalizeFirstLetter(
                                                                          addressValue.text),
                                                                  addressSecond: AppUtil.capitalizeFirstLetter(addressOptionalValue.text),
                                                                  zip: zipCodeValue.text,
                                                                  city: cityValue.text));
                                                        }
                                                        if (!_arePasswordInputsAsDefault()) {
                                                          RemoteEventsUtil
                                                              .userEvents
                                                              .updateUserPassword(
                                                                  context,
                                                                  recentPassword:
                                                                      recentPasswordValue
                                                                          .text,
                                                                  newPassword:
                                                                      passwordConfirmValue
                                                                          .text);
                                                        }
                                                      },
                                                    ),
                                                    _buildActionButton(
                                                      theme: theme,
                                                      ts: ts,
                                                      isRtl: isRtl,
                                                      useIntrinsicWidth:
                                                          !isMobile,
                                                      title: ts.translate(
                                                          'global.cancelChanges'),
                                                      backgroundColor: theme
                                                          .thirdBackgroundColor,
                                                      onHoverbackgroundColor: theme
                                                          .thirdBackgroundColor,
                                                      textColor: theme.accent,
                                                      onHoverTextColor: theme
                                                          .accent
                                                          .withOpacity(0.8),
                                                      isEnabled:
                                                          !_areGeneralInputsAsDefault() ||
                                                              !_arePasswordInputsAsDefault(),
                                                      onPressed: () {
                                                        _setDefaultInputValues();
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
      },
    );
  }

  Widget _buildEditProfile(BuildContext context, BaseTheme theme,
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
              title: ts.translate('screens.editProfile.editProfileTitle'),
              subTitle:
                  ts.translate('screens.editProfile.editProfileSubTitle')),
          if (!isMobile)
            _buildEditProfileForm(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
              isTablet: isTablet,
            )
          else
            _buildMobileEditProfileForm(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
            )
        ]),
        CustomField(isRtl: language.isRtl, gap: r.size(12), children: [
          _buildHeader(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
              title: ts.translate('screens.editProfile.shippingTitle'),
              subTitle: ts.translate('screens.editProfile.shippingSubTitle')),
          _buildShippingForm(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
              isTablet: isTablet,
              isMobile: isMobile),
        ]),
        CustomField(isRtl: language.isRtl, gap: r.size(12), children: [
          _buildHeader(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
              title: ts.translate('screens.editProfile.changePasswordTitle'),
              subTitle:
                  ts.translate('screens.editProfile.changePasswordSubTitle')),
          if (!isTablet && !isMobile)
            _buildChangePasswordForm(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
            )
          else
            _buildTabletMobileChangePasswordForm(
              theme: theme,
              ts: ts,
              isRtl: language.isRtl,
            )
        ]),
        _buildActionButtons(
            theme: theme,
            ts: ts,
            isRtl: language.isRtl,
            isTablet: isTablet,
            isMobile: isMobile),
      ],
    );
  }
}
