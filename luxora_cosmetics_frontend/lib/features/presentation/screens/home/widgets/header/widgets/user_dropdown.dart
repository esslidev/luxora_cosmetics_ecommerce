import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/core/util/app_util.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/shared_preference_keys.dart';
import '../../../../../../../core/enums/theme_style.dart';
import '../../../../../../../core/enums/widgets.dart';
import '../../../../../../../core/resources/global_contexts.dart';
import '../../../../../../../core/util/prefs_util.dart';
import '../../../../../../../core/util/remote_events_util.dart';
import '../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../../core/util/translation_service.dart';
import '../../../../../../../locator.dart';
import '../../../../../../domain/entities/user.dart';
import '../../../../../bloc/remote/user/user_bloc.dart';
import '../../../../../bloc/remote/user/user_state.dart';
import '../../../../../widgets/common/custom_button.dart';
import '../../../../../widgets/common/custom_field.dart';
import '../../../../../widgets/common/custom_line.dart';

class UserDropdown extends StatefulWidget {
  final BaseTheme theme;
  final ThemeStyle themeStyle;
  final TranslationService ts;
  final bool isRtl;
  final Function() onSignInPressed;
  final Function() onSignUpPressed;
  final Function() onSignOutPressed;
  final Function() onDismiss;

  const UserDropdown({
    required this.theme,
    required this.themeStyle,
    required this.ts,
    required this.isRtl,
    required this.onSignInPressed,
    required this.onSignUpPressed,
    required this.onSignOutPressed,
    required this.onDismiss,
    super.key,
  });

  @override
  State<UserDropdown> createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  UserEntity? _userResponse;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (PrefsUtil.containsKey(PrefsKeys.userAccessToken) == true) {
        RemoteEventsUtil.userEvents.getLoggedInUser(context);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
  // ------------------------------------------------------- //

  Widget _buildUserHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required bool isAdmin,
  }) {
    return CustomField(gap: r.size(2), isRtl: isRtl, children: [
      CustomField(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        padding: r.symmetric(vertical: 4, horizontal: 4),
        isRtl: isRtl,
        gap: r.size(4),
        arrangement: FieldArrangement.row,
        children: [
          Expanded(
            child: CustomField(
                gap: r.size(4),
                arrangement: FieldArrangement.row,
                crossAxisAlignment: CrossAxisAlignment.center,
                isRtl: isRtl,
                children: [
                  CustomField(
                      width: r.size(24),
                      height: r.size(24),
                      borderRadius: r.size(15),
                      backgroundColor: theme.thirdBackgroundColor,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              '${_userResponse?.firstName?.substring(0, 1).toUpperCase()} ${_userResponse?.lastName?.substring(0, 1).toUpperCase()}',
                          fontSize: r.size(11),
                          fontWeight: FontWeight.w900,
                          color: theme.accent.withOpacity(0.4),
                        )
                      ]),
                  Expanded(
                    child: CustomField(gap: r.size(2), isRtl: isRtl, children: [
                      CustomText(
                        text:
                            '${AppUtil.capitalizeFirstLetter(_userResponse?.firstName ?? '')} ${AppUtil.capitalizeFirstLetter(_userResponse?.lastName ?? '')}',
                        fontSize: r.size(9),
                        lineHeight: 1,
                      ),
                      CustomText(
                        text: '${_userResponse?.email} ',
                        fontSize: r.size(8),
                        color: theme.accent.withOpacity(0.8),
                        lineHeight: 1,
                      )
                    ]),
                  ),
                ]),
          ),
          if (isAdmin)
            CustomText(
              text: ts.translate('screens.home.header.profile.admin'),
              fontSize: r.size(6),
              backgroundColor: theme.primary.withOpacity(0.4),
              padding: r.symmetric(vertical: 2, horizontal: 4),
              borderRadius: r.size(1),
            )
        ],
      ),
      CustomLine(
        color: widget.theme.accent.withOpacity(0.4),
        thickness: r.size(0.2),
      ),
    ]);
  }

  Widget _buildActionButton({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String text,
    required String svgIconPath,
    required Function() onPressed,
    Color? onHoverBackground,
  }) {
    return CustomButton(
      useIntrinsicWidth: false,
      text: text,
      fontSize: r.size(10),
      svgIconPath: svgIconPath,
      iconHeight: r.size(10),
      iconColor: theme.accent.withOpacity(0.8),
      mainAxisAlignment: MainAxisAlignment.start,
      padding: r.symmetric(vertical: 2, horizontal: 6),
      borderRadius: BorderRadius.circular(r.size(1)),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
          backgroundColor: onHoverBackground ?? theme.secondaryBackgroundColor),
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
    return CustomField(
      gap: r.size(6),
      mainAxisSize: MainAxisSize.min,
      isRtl: isRtl,
      children: [
        _buildActionButton(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            text: ts.translate('screens.home.header.profile.editProfile'),
            svgIconPath: AppPaths.vectors.userEditIcon,
            onPressed: () {
              widget.onDismiss();
              Beamer.of(context).beamToNamed(
                AppPaths.routes.editProfileScreen,
              );
            }),
        _buildActionButton(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            text: ts.translate('screens.home.header.profile.orderHistory'),
            svgIconPath: AppPaths.vectors.clockIcon,
            onPressed: () {
              widget.onDismiss();
              Beamer.of(context).beamToNamed(
                AppPaths.routes.orderHistoryScreen,
              );
            }),
        CustomLine(
          color: widget.theme.accent.withOpacity(0.4),
          thickness: r.size(0.2),
        ),
      ],
    );
  }

  Widget _buildAdminActionButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      gap: r.size(6),
      mainAxisSize: MainAxisSize.min,
      isRtl: isRtl,
      children: [
        _buildActionButton(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            text:
                ts.translate('screens.home.header.profile.showcaseManagement'),
            svgIconPath: AppPaths.vectors.showcaseIcon,
            onHoverBackground: theme.primary.withOpacity(0.2),
            onPressed: () {
              widget.onDismiss();
              Beamer.of(context).beamToNamed(
                AppPaths.routes.showcaseManagementScreen,
              );
            }),
        _buildActionButton(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            text: ts.translate('screens.home.header.profile.postManagement'),
            svgIconPath: AppPaths.vectors.penIcon,
            onHoverBackground: theme.primary.withOpacity(0.2),
            onPressed: () {
              widget.onDismiss();
              Beamer.of(context).beamToNamed(
                AppPaths.routes.postManagementScreen,
              );
            }),
        CustomLine(
          color: widget.theme.accent.withOpacity(0.4),
          thickness: r.size(0.2),
        ),
      ],
    );
  }

  Widget _buildOnConnectedUser({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      width: double.infinity,
      isRtl: widget.isRtl,
      gap: r.size(6),
      padding: r.symmetric(vertical: 4, horizontal: 4),
      children: [
        _buildUserHeader(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            isAdmin: _userResponse?.isAdmin == true),
        _buildActionButtons(
            theme: widget.theme, ts: widget.ts, isRtl: widget.isRtl),
        if (_userResponse?.isAdmin == true)
          _buildAdminActionButtons(
              theme: widget.theme, ts: widget.ts, isRtl: widget.isRtl),
        _buildActionButton(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            text: ts.translate('screens.home.header.profile.signOut'),
            svgIconPath: AppPaths.vectors.logoutIcon,
            onHoverBackground: AppColors.colors.redRouge.withOpacity(0.2),
            onPressed: () {
              widget.onDismiss();
              widget.onSignOutPressed();
              Beamer.of(context).beamToNamed(
                AppPaths.routes.exploreScreen,
              );
            })
      ],
    );
  }

  Widget _buildOnDisconnectedUser({
    required BaseTheme theme,
    required ThemeStyle themeStyle,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
        width: double.infinity,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        isRtl: isRtl,
        gap: r.size(6),
        padding: r.all(4),
        children: [
          CustomButton(
            useIntrinsicWidth: false,
            text: ts.translate('screens.home.header.profile.signIn'),
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            borderRadius: BorderRadius.all(Radius.circular(r.size(1))),
            textColor: AppColors.colors.whiteSolid,
            backgroundColor: theme.primary,
            height: r.size(20),
            onPressed: (position, size) {
              widget.onDismiss();
              widget.onSignInPressed();
            },
          ),
          CustomButton(
            useIntrinsicWidth: false,
            text: ts.translate('screens.home.header.profile.createAccount'),
            fontSize: r.size(10),
            textColor: theme.bodyText,
            onPressed: (position, size) {
              widget.onDismiss();
              widget.onSignUpPressed();
            },
          ),
        ]);
  }

  _buildLoadingIndicator({required BaseTheme theme}) {
    return CustomField(
      width: r.size(20),
      height: r.size(20),
      margin: r.symmetric(vertical: 12),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.theme.accent.withOpacity(0.4),
          ),
          strokeWidth: r.size(2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RemoteUserBloc, RemoteUserState>(
          listener: (context, state) {
            if (state is RemoteUserLoading) {
              _isLoading = true;
            }
            if (state is RemoteUserLoaded) {
              _isLoading = false;
              if (state.user != null) {
                setState(() {
                  _userResponse = state.user;
                });
              }
            }

            if (state is RemoteUserError) {}
          },
        ),
      ],
      child: _isLoading == false
          ? _userResponse != null
              ? _buildOnConnectedUser(
                  theme: widget.theme, ts: widget.ts, isRtl: widget.isRtl)
              : _buildOnDisconnectedUser(
                  theme: widget.theme,
                  themeStyle: widget.themeStyle,
                  ts: widget.ts,
                  isRtl: widget.isRtl)
          : _buildLoadingIndicator(theme: widget.theme),
    );
  }
}
