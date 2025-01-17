import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/notification_type.dart';
import 'package:librairie_alfia/core/util/custom_timer.dart';

import 'package:librairie_alfia/features/domain/entities/system_message.dart';
import 'package:librairie_alfia/features/presentation/bloc/remote/system_messages/system_message_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../core/enums/theme_style.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/currency_model.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/prefs_util.dart';
import '../../../../../core/util/remote_events_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../../data/models/system_message_translation.dart';
import '../../../bloc/app/currency/currency_bloc.dart';
import '../../../bloc/app/currency/currency_state.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';
import '../../../bloc/remote/system_messages/system_message_state.dart';
import '../../../overlays/dropdown/dropdown.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_text.dart';

class HeaderTapeWidget extends StatefulWidget {
  const HeaderTapeWidget({super.key});

  @override
  State<HeaderTapeWidget> createState() => _HeaderTapeState();
}

class _HeaderTapeState extends State<HeaderTapeWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;
  final LayerLink _languageDropdownLayerLink = LayerLink();
  final LayerLink _currencyDropdownLayerLink = LayerLink();

  late CustomTimer _systemMessagesTimer;
  final ValueNotifier<int> _systemMessagesIndexNotifier = ValueNotifier<int>(0);

  List<SystemMessageEntity>? _systemMessages;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    RemoteEventsUtil.systemMessageEvents.getShownSystemMessages(context);

    // Initialize the timer
    _systemMessagesTimer = CustomTimer(
      onTick: (secondsLeft) {},
      onTimerStop: () {
        if (_systemMessages != null) {
          if (_systemMessagesIndexNotifier.value <
              (_systemMessages!.length - 1)) {
            _systemMessagesIndexNotifier.value =
                _systemMessagesIndexNotifier.value + 1;
          } else {
            _systemMessagesIndexNotifier.value = 0;
          }
        }
        _systemMessagesTimer.start(duration: const Duration(seconds: 6));
      },
    );
    _systemMessagesTimer.start(duration: const Duration(seconds: 6));
  }

  @override
  void dispose() {
    _systemMessagesTimer.stop();
    _systemMessagesIndexNotifier.dispose();
    super.dispose();
  }

//----------------------------------------------------------------------------------------------------//

  void _changeTheme(ThemeStyle themeStyle) {
    if (themeStyle == ThemeStyle.light) {
      AppEventsUtil.themeEvents.changeTheme(context, ThemeStyle.dark);
      PrefsUtil.setString(
          PrefsKeys.themeStyle, ThemeStyle.dark.toString().split('.').last);
    } else {
      AppEventsUtil.themeEvents.changeTheme(context, ThemeStyle.light);
      PrefsUtil.setString(
          PrefsKeys.themeStyle, ThemeStyle.light.toString().split('.').last);
    }
  }

  List<String> filteredSystemMessages(String languageCode) {
    if (_systemMessages != null) {
      return _systemMessages!
          .map((systemMessage) {
            // Find the translation for the given language code
            final translation = systemMessage.translations?.firstWhere(
              (translation) => translation.languageCode == languageCode,
              orElse: () => const SystemMessageTranslationModel(
                  languageCode: '', message: ''), // Return null if not found
            );

            // If a translation is found, return the message
            return translation?.message ??
                ''; // Return empty string if no translation
          })
          .where((message) => message.isNotEmpty) // Filter out empty messages
          .toList();
    }
    return [];
  }

//------------------------------------------------------------------------------------------------//

  DropdownOverlay _buildDropdown(
    BaseTheme theme,
    bool isRtl,
    List<Widget> items,
  ) {
    return DropdownOverlay(
      context: context,
      borderRadius: Radius.circular(r.size(3)),
      borderColor: theme.accent.withOpacity(0.3),
      borderWidth: r.size(1),
      margin: EdgeInsets.only(top: r.size(4)),
      shadowColor: theme.shadowColor,
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
      child: CustomField(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        isRtl: isRtl,
        gap: r.size(6),
        padding:
            EdgeInsets.symmetric(vertical: r.size(8), horizontal: r.size(12)),
        children: items,
      ),
    );
  }

  CustomButton _buildLanguageButton({
    required String text,
    String? fontFamily,
    required String iconPath,
    required Color textColor,
    required LanguageModel languageModel,
    Function()? onPressed,
  }) {
    return CustomButton(
      text: text,
      fontFamily: fontFamily,
      svgIconPath: iconPath,
      textColor: textColor,
      fontSize: r.size(10),
      iconWidth: r.size(12),
      iconHeight: r.size(12),
      onPressed: (position, size) {
        AppEventsUtil.languageEvents.loadLanguage(context, languageModel);
        if (onPressed != null) {
          onPressed();
        }
      },
    );
  }

  CustomButton _buildCurrencyButton({
    required String text,
    required Color textColor,
    required CurrencyModel currencyModel,
    Function()? onPressed,
  }) {
    return CustomButton(
      text: text,
      textColor: textColor,
      fontSize: r.size(10),
      onPressed: (position, size) {
        AppEventsUtil.currencyEvents.changeCurrency(context, currencyModel);
        if (onPressed != null) {
          onPressed();
        }
      },
    );
  }

  DropdownOverlay _buildLanguageDropdown(
    BaseTheme theme,
    bool isRtl,
  ) {
    DropdownOverlay? dropdown;
    dropdown = _buildDropdown(
      theme,
      isRtl,
      [
        _buildLanguageButton(
          text: 'Français',
          iconPath: AppPaths.vectors.frIcon,
          textColor: theme.bodyText,
          languageModel: LanguageModel.french,
          onPressed: () => dropdown?.dismiss(), // Dismiss when clicked
        ),
        _buildLanguageButton(
          text: 'العربية',
          fontFamily: LanguageModel.arabic.fontFamily,
          iconPath: AppPaths.vectors.maIcon,
          textColor: theme.bodyText,
          languageModel: LanguageModel.arabic,
          onPressed: () => dropdown?.dismiss(), // Dismiss when clicked
        ),
        _buildLanguageButton(
          text: 'English',
          iconPath: AppPaths.vectors.usIcon,
          textColor: theme.bodyText,
          languageModel: LanguageModel.english,
          onPressed: () => dropdown?.dismiss(), // Dismiss when clicked
        ),
        _buildLanguageButton(
          text: 'Deutsch',
          iconPath: AppPaths.vectors.deIcon,
          textColor: theme.bodyText,
          languageModel: LanguageModel.deutsch,
          onPressed: () => dropdown?.dismiss(), // Dismiss when clicked
        ),
      ],
    );

    return dropdown;
  }

  DropdownOverlay _buildCurrencyDropdown(
    BaseTheme theme,
    TranslationService ts,
    bool isRtl,
  ) {
    DropdownOverlay? dropdown;
    dropdown = _buildDropdown(
      theme,
      isRtl,
      [
        _buildCurrencyButton(
          text:
              '${ts.translate('global.currencies.moroccanDirham.symbol')} • ${ts.translate('global.currencies.moroccanDirham.name')}',
          textColor: theme.bodyText,
          currencyModel: CurrencyModel.mad,
          onPressed: () => dropdown?.dismiss(),
        ),
        _buildCurrencyButton(
          text:
              '${ts.translate('global.currencies.euro.symbol')} • ${ts.translate('global.currencies.euro.name')}',
          textColor: theme.bodyText,
          currencyModel: CurrencyModel.eur,
          onPressed: () => dropdown?.dismiss(),
        ),
        _buildCurrencyButton(
          text:
              '${ts.translate('global.currencies.usDollar.symbol')} • ${ts.translate('global.currencies.usDollar.name')}',
          textColor: theme.bodyText,
          currencyModel: CurrencyModel.usd,
          onPressed: () => dropdown?.dismiss(),
        ),
      ],
    );

    return dropdown;
  }

  CustomText _buildSystemMessage({
    required String text,
    Key? key,
    double? maxWidth,
    required Color textColor,
    TextDirection? textDirection,
    TextAlign? textAlign,
  }) {
    return CustomText(
      text: text,
      maxWidth: maxWidth,
      key: key,
      color: textColor,
      fontSize: r.size(8),
      textDirection: textDirection,
      textAlign: textAlign,
    );
  }

  Widget _buildSystemMessagesSwitcher({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<String> systemMessages,
    double? messageMaxWidth,
    TextAlign? textAlign,
  }) {
    final hasMultipleMessages =
        _systemMessages != null && (_systemMessages?.length ?? 0) > 1;

    return CustomField(
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      isRtl: isRtl,
      gap: r.size(8),
      children: [
        if (hasMultipleMessages)
          CustomButton(
            svgIconPath: !isRtl
                ? AppPaths.vectors.triangleLeftIcon
                : AppPaths.vectors.triangleRightIcon,
            iconColor: theme.headerTapeIconColor,
            iconHeight: r.size(8),
            width: r.size(8),
            height: r.size(8),
            onPressed: (position, size) {
              if (_systemMessages != null) {
                if (_systemMessagesIndexNotifier.value > 0) {
                  _systemMessagesIndexNotifier.value =
                      _systemMessagesIndexNotifier.value - 1;
                } else {
                  _systemMessagesIndexNotifier.value =
                      _systemMessages!.length - 1;
                }
              }
              _systemMessagesTimer.start(duration: const Duration(seconds: 6));
            },
          ),
        ValueListenableBuilder<int>(
          valueListenable: _systemMessagesIndexNotifier,
          builder: (context, currentMessageIndex, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                );
              },
              child: systemMessages.isNotEmpty
                  ? _buildSystemMessage(
                      text: systemMessages[currentMessageIndex],
                      key: ValueKey<int>(currentMessageIndex),
                      maxWidth: messageMaxWidth,
                      textAlign: textAlign,
                      textColor: theme.headerTapeColor,
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                    )
                  : _buildSystemMessage(
                      text: ts.translate('screens.home.headerTape.welcome'),
                      maxWidth: messageMaxWidth,
                      textAlign: textAlign,
                      textColor: theme.headerTapeColor,
                      textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                    ), // Show an empty container or handle undefined state
            );
          },
        ),
        if (hasMultipleMessages)
          CustomButton(
            svgIconPath: isRtl
                ? AppPaths.vectors.triangleLeftIcon
                : AppPaths.vectors.triangleRightIcon,
            iconColor: theme.headerTapeIconColor,
            iconHeight: r.size(8),
            width: r.size(8),
            height: r.size(8),
            onPressed: (position, size) {
              if (_systemMessages != null) {
                if (_systemMessagesIndexNotifier.value <
                    (_systemMessages!.length - 1)) {
                  _systemMessagesIndexNotifier.value =
                      _systemMessagesIndexNotifier.value + 1;
                } else {
                  _systemMessagesIndexNotifier.value = 0;
                }
                _systemMessagesTimer.start(
                    duration: const Duration(seconds: 6));
              }
            },
          ),
      ],
    );
  }
//---------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
            if (translationState.translationService != null &&
                translationState.language != null) {
              return BlocBuilder<AppCurrencyBloc, AppCurrencyState>(
                  builder: (context, currencyState) {
                return MultiBlocListener(
                  listeners: [
                    BlocListener<RemoteSystemMessageBloc,
                        RemoteSystemMessageState>(
                      listener: (context, state) {
                        if (state is RemoteShownSystemMessagesLoaded) {
                          setState(() {
                            _systemMessages = state.systemShownMessages;
                          });
                        }
                        if (state is RemoteSystemMessageError) {
                          AppEventsUtil.liteNotifications
                              .addLiteNotification(context,
                                  notification: LiteNotificationModel(
                                    notificationTitle:
                                        state.error?.response?.data["error"],
                                    notificationMessage:
                                        state.error?.response?.data["message"],
                                    notificationType: NotificationType.error,
                                  ));
                        }
                      },
                    ),
                  ],
                  child: ResponsiveScreenAdapter(
                      fallbackScreen: _buildLargeDesktop(
                          context,
                          themeState.theme,
                          themeState.themeStyle,
                          translationState.translationService!,
                          translationState.language!,
                          currencyState.currency,
                          _buildLanguageDropdown(themeState.theme,
                              translationState.language!.isRtl),
                          _buildCurrencyDropdown(
                              themeState.theme,
                              translationState.translationService!,
                              translationState.language!.isRtl)),
                      screenLargeDesktop: _buildLargeDesktop(
                          context,
                          themeState.theme,
                          themeState.themeStyle,
                          translationState.translationService!,
                          translationState.language!,
                          currencyState.currency,
                          _buildLanguageDropdown(themeState.theme,
                              translationState.language!.isRtl),
                          _buildCurrencyDropdown(
                              themeState.theme,
                              translationState.translationService!,
                              translationState.language!.isRtl)),
                      screenDesktop: _buildDesktop(
                          context,
                          themeState.theme,
                          themeState.themeStyle,
                          translationState.translationService!,
                          translationState.language!,
                          currencyState.currency,
                          _buildLanguageDropdown(themeState.theme,
                              translationState.language!.isRtl),
                          _buildCurrencyDropdown(
                              themeState.theme,
                              translationState.translationService!,
                              translationState.language!.isRtl)),
                      screenTablet: _buildTablet(
                          context,
                          themeState.theme,
                          themeState.themeStyle,
                          translationState.translationService!,
                          translationState.language!,
                          currencyState.currency,
                          _buildLanguageDropdown(themeState.theme,
                              translationState.language!.isRtl),
                          _buildCurrencyDropdown(
                              themeState.theme,
                              translationState.translationService!,
                              translationState.language!.isRtl)),
                      screenMobile: _buildMobile(
                          context,
                          themeState.theme,
                          themeState.themeStyle,
                          translationState.translationService!,
                          translationState.language!,
                          currencyState.currency,
                          _buildLanguageDropdown(themeState.theme,
                              translationState.language!.isRtl),
                          _buildCurrencyDropdown(
                              themeState.theme,
                              translationState.translationService!,
                              translationState.language!.isRtl))),
                );
              });
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildLargeDesktop(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
    DropdownOverlay languageDropdown,
    DropdownOverlay currencyDropdown,
  ) {
    return CustomField(
        arrangement: FieldArrangement.row,
        backgroundColor: theme.headerTapeBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: language.isRtl,
        padding: r.symmetric(vertical: r.size(2), horizontal: r.size(18)),
        children: [
          _buildSystemMessagesSwitcher(
              isRtl: language.isRtl,
              theme: theme,
              ts: ts,
              systemMessages: filteredSystemMessages(language.languageCode),
              messageMaxWidth: r.size(450)),
          CustomField(
              arrangement: FieldArrangement.row,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: r.size(14),
              isRtl: language.isRtl,
              children: [
                CustomButton(
                  text: ts.translate('screens.names.aboutUs'),
                  fontSize: r.size(10),
                  textColor: theme.accent.withOpacity(0.8),
                  animationDuration: 300.ms,
                  onHoverStyle: CustomButtonStyle(
                    textColor: theme.accent,
                  ),
                ),
                CustomButton(
                  text: ts.translate('screens.names.blog'),
                  fontSize: r.size(10),
                  textColor: theme.accent.withOpacity(0.8),
                  animationDuration: 300.ms,
                  onHoverStyle: CustomButtonStyle(
                    textColor: theme.accent,
                  ),
                  onPressed: (position, size) {
                    Beamer.of(context).beamToNamed(
                      AppPaths.routes.blogPostsScreen,
                    );
                  },
                ),
                CustomButton(
                  text: ts.translate('screens.names.termsAndPolicies'),
                  fontSize: r.size(10),
                  textColor: theme.accent.withOpacity(0.8),
                  animationDuration: 300.ms,
                  onHoverStyle: CustomButtonStyle(
                    textColor: theme.accent,
                  ),
                ),
                CustomButton(
                  svgIconPath: themeStyle == ThemeStyle.dark
                      ? AppPaths.vectors.sunIcon
                      : AppPaths.vectors.eclipseIcon,
                  width: r.size(10),
                  height: r.size(10),
                  iconColor: theme.accent.withOpacity(0.8),
                  animationDuration: 300.ms,
                  onHoverStyle: CustomButtonStyle(
                    iconColor: theme.accent,
                  ),
                  onPressed: (position, size) {
                    _changeTheme(themeStyle);
                  },
                ),
                CompositedTransformTarget(
                  link: _currencyDropdownLayerLink,
                  child: CustomButton(
                    text:
                        '${AppUtil.returnTranslatedSymbol(ts, currency.code)} ${currency.code}',
                    svgIconPath: AppPaths.vectors.triangleBottomIcon,
                    iconColor: theme.accent.withOpacity(0.8),
                    animationDuration: 300.ms,
                    onHoverStyle: CustomButtonStyle(
                      textColor: theme.accent,
                      iconColor: theme.accent,
                    ),
                    iconWidth: r.size(4),
                    iconHeight: r.size(4),
                    iconTextGap: r.size(4),
                    iconPosition: CustomButtonIconPosition.right,
                    fontSize: r.size(10),
                    fontWeight: FontWeight.bold,
                    textColor: theme.accent.withOpacity(0.8),
                    onPressed: (position, size) {
                      currencyDropdown.show(
                        layerLink: _currencyDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(150),
                        dropdownAlignment: language.isRtl
                            ? DropdownAlignment.start
                            : DropdownAlignment.end,
                      );
                    },
                  ),
                ),
                CompositedTransformTarget(
                  link: _languageDropdownLayerLink,
                  child: CustomButton(
                    svgIconPath: language.languageCode ==
                            LanguageModel.english.languageCode
                        ? AppPaths.vectors.usIcon
                        : language.languageCode ==
                                LanguageModel.french.languageCode
                            ? AppPaths.vectors.frIcon
                            : language.languageCode ==
                                    LanguageModel.arabic.languageCode
                                ? AppPaths.vectors.maIcon
                                : AppPaths.vectors.deIcon,
                    width: r.size(16),
                    height: r.size(16),
                    onPressed: (position, size) {
                      languageDropdown.show(
                        layerLink: _languageDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(90),
                        dropdownAlignment: language.isRtl
                            ? DropdownAlignment.start
                            : DropdownAlignment.end,
                      );
                    },
                  ),
                )
              ])
        ]);
  }

  Widget _buildDesktop(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
    DropdownOverlay languageDropdown,
    DropdownOverlay currencyDropdown,
  ) {
    return CustomField(
        arrangement: FieldArrangement.row,
        backgroundColor: theme.headerTapeBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: language.isRtl,
        padding: r.symmetric(vertical: r.size(2), horizontal: r.size(8)),
        children: [
          _buildSystemMessagesSwitcher(
              isRtl: language.isRtl,
              systemMessages: filteredSystemMessages(language.languageCode),
              theme: theme,
              ts: ts,
              messageMaxWidth: r.size(220)),
          CustomField(
              arrangement: FieldArrangement.row,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: r.size(14),
              isRtl: language.isRtl,
              children: [
                CustomButton(
                  text: ts.translate('screens.names.aboutUs'),
                  textColor: theme.headerTapeColor,
                  fontSize: r.size(10),
                ),
                CustomButton(
                  text: ts.translate('screens.names.blog'),
                  textColor: theme.headerTapeColor,
                  fontSize: r.size(10),
                ),
                CustomButton(
                  text: ts.translate('screens.names.termsAndPolicies'),
                  textColor: theme.headerTapeColor,
                  fontSize: r.size(10),
                ),
                CustomButton(
                  svgIconPath: themeStyle == ThemeStyle.dark
                      ? AppPaths.vectors.sunIcon
                      : AppPaths.vectors.eclipseIcon,
                  width: r.size(10),
                  height: r.size(10),
                  iconColor: theme.headerTapeIconColor,
                  onPressed: (position, size) {
                    _changeTheme(themeStyle);
                  },
                ),
                CompositedTransformTarget(
                  link: _currencyDropdownLayerLink,
                  child: CustomButton(
                    text:
                        '${AppUtil.returnTranslatedSymbol(ts, currency.code)} ${currency.code}',
                    fontSize: r.size(10),
                    fontWeight: FontWeight.bold,
                    textColor: theme.headerTapeIconColor,
                    onPressed: (position, size) {
                      currencyDropdown.show(
                        layerLink: _currencyDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(150),
                        dropdownAlignment: language.isRtl
                            ? DropdownAlignment.start
                            : DropdownAlignment.end,
                      );
                    },
                  ),
                ),
                CompositedTransformTarget(
                  link: _languageDropdownLayerLink,
                  child: CustomButton(
                    svgIconPath: language.languageCode ==
                            LanguageModel.english.languageCode
                        ? AppPaths.vectors.usIcon
                        : language.languageCode ==
                                LanguageModel.french.languageCode
                            ? AppPaths.vectors.frIcon
                            : language.languageCode ==
                                    LanguageModel.arabic.languageCode
                                ? AppPaths.vectors.maIcon
                                : AppPaths.vectors.deIcon,
                    width: r.size(16),
                    height: r.size(16),
                    onPressed: (position, size) {
                      languageDropdown.show(
                        layerLink: _languageDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(90),
                        dropdownAlignment: language.isRtl
                            ? DropdownAlignment.start
                            : DropdownAlignment.end,
                      );
                    },
                  ),
                )
              ])
        ]);
  }

  Widget _buildTablet(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
    DropdownOverlay languageDropdown,
    DropdownOverlay currencyDropdown,
  ) {
    return CustomField(
        arrangement: FieldArrangement.row,
        backgroundColor: theme.headerTapeBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: language.isRtl,
        padding: r.symmetric(vertical: r.size(2), horizontal: r.size(12)),
        children: [
          _buildSystemMessagesSwitcher(
              isRtl: language.isRtl,
              systemMessages: filteredSystemMessages(language.languageCode),
              theme: theme,
              ts: ts,
              messageMaxWidth: r.size(220)),
          CustomField(
              arrangement: FieldArrangement.row,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: r.size(10),
              isRtl: language.isRtl,
              children: [
                CustomButton(
                  svgIconPath: themeStyle == ThemeStyle.dark
                      ? AppPaths.vectors.sunIcon
                      : AppPaths.vectors.eclipseIcon,
                  width: r.size(12),
                  height: r.size(12),
                  iconColor: theme.headerTapeIconColor,
                  onPressed: (position, size) {
                    _changeTheme(themeStyle);
                  },
                ),
                CompositedTransformTarget(
                  link: _currencyDropdownLayerLink,
                  child: CustomButton(
                    text:
                        '${AppUtil.returnTranslatedSymbol(ts, currency.code)} ${currency.code}',
                    fontSize: r.size(12),
                    fontWeight: FontWeight.bold,
                    textColor: theme.headerTapeIconColor,
                    onPressed: (position, size) {
                      currencyDropdown.show(
                        layerLink: _currencyDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(150),
                        dropdownAlignment: language.isRtl
                            ? DropdownAlignment.start
                            : DropdownAlignment.end,
                      );
                    },
                  ),
                ),
                CompositedTransformTarget(
                  link: _languageDropdownLayerLink,
                  child: CustomButton(
                    svgIconPath: language.languageCode ==
                            LanguageModel.english.languageCode
                        ? AppPaths.vectors.usIcon
                        : language.languageCode ==
                                LanguageModel.french.languageCode
                            ? AppPaths.vectors.frIcon
                            : language.languageCode ==
                                    LanguageModel.arabic.languageCode
                                ? AppPaths.vectors.maIcon
                                : AppPaths.vectors.deIcon,
                    width: r.size(18),
                    height: r.size(18),
                    onPressed: (position, size) {
                      languageDropdown.show(
                        layerLink: _languageDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(90),
                        dropdownAlignment: language.isRtl
                            ? DropdownAlignment.start
                            : DropdownAlignment.end,
                      );
                    },
                  ),
                )
              ])
        ]);
  }

  Widget _buildMobile(
    BuildContext context,
    BaseTheme theme,
    ThemeStyle themeStyle,
    TranslationService ts,
    LanguageModel language,
    CurrencyModel currency,
    DropdownOverlay languageDropdown,
    DropdownOverlay currencyDropdown,
  ) {
    return CustomField(
        arrangement: FieldArrangement.column,
        backgroundColor: theme.headerTapeBackgroundColor,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: language.isRtl,
        padding: r.symmetric(vertical: r.size(4), horizontal: r.size(4)),
        gap: r.size(4),
        children: [
          CustomField(
              arrangement: FieldArrangement.row,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: r.size(12),
              isRtl: language.isRtl,
              children: [
                CustomButton(
                  svgIconPath: themeStyle == ThemeStyle.dark
                      ? AppPaths.vectors.sunIcon
                      : AppPaths.vectors.eclipseIcon,
                  iconHeight: r.size(12),
                  width: r.size(12),
                  height: r.size(12),
                  iconColor: theme.headerTapeIconColor,
                  onPressed: (position, size) {
                    _changeTheme(themeStyle);
                  },
                ),
                CompositedTransformTarget(
                  link: _currencyDropdownLayerLink,
                  child: CustomButton(
                    text:
                        '${AppUtil.returnTranslatedSymbol(ts, currency.code)} ${currency.code}',
                    fontSize: r.size(12),
                    fontWeight: FontWeight.bold,
                    textColor: theme.headerTapeIconColor,
                    onPressed: (position, size) {
                      currencyDropdown.show(
                        layerLink: _currencyDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(150),
                        dropdownAlignment: DropdownAlignment.center,
                      );
                    },
                  ),
                ),
                CompositedTransformTarget(
                  link: _languageDropdownLayerLink,
                  child: CustomButton(
                    svgIconPath: language.languageCode ==
                            LanguageModel.english.languageCode
                        ? AppPaths.vectors.usIcon
                        : language.languageCode ==
                                LanguageModel.french.languageCode
                            ? AppPaths.vectors.frIcon
                            : language.languageCode ==
                                    LanguageModel.arabic.languageCode
                                ? AppPaths.vectors.maIcon
                                : AppPaths.vectors.deIcon,
                    iconHeight: r.size(14),
                    width: r.size(14),
                    height: r.size(14),
                    onPressed: (position, size) {
                      languageDropdown.show(
                        layerLink: _languageDropdownLayerLink,
                        backgroundColor: theme.overlayBackgroundColor,
                        targetWidgetSize: size,
                        width: r.size(90),
                        dropdownAlignment: DropdownAlignment.center,
                      );
                    },
                  ),
                )
              ]),
          _buildSystemMessagesSwitcher(
              isRtl: language.isRtl,
              systemMessages: filteredSystemMessages(language.languageCode),
              theme: theme,
              ts: ts,
              messageMaxWidth: r.size(180),
              textAlign: TextAlign.center),
        ]);
  }
}
