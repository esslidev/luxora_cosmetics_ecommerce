import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';

import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/util/app_events_util.dart';
import '../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../widgets/common/custom_button.dart';

class ProfileDropdown extends StatefulWidget {
  final Function() onSignInPressed;
  final Function() onSignUpPressed;
  final Function() onSignOutPressed;
  const ProfileDropdown({
    super.key,
    required this.onSignInPressed,
    required this.onSignUpPressed,
    required this.onSignOutPressed,
  });

  @override
  State<ProfileDropdown> createState() => _UserDropdownState();
}

class _UserDropdownState extends State<ProfileDropdown> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    r = ResponsiveSizeAdapter(context);
    super.initState();
    AppEventsUtil.breadCrumbs.clearBreadCrumbs(context);
  }

  Widget _buildProfileDropdown(BuildContext context) {
    return CustomField(
      width: double.infinity,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(2),
      padding: r.all(4),
      children: [
        CustomButton(
          useIntrinsicWidth: false,
          text: 'Se connecter',
          fontSize: r.size(10),
          borderRadius: BorderRadius.circular(r.size(1)),
          fontWeight: FontWeight.w700,
          textColor: AppColors.colors.white,
          backgroundColor: AppColors.light.primary,
          padding: r.symmetric(vertical: 4),
          border: Border.all(color: Colors.transparent, width: r.size(1)),
          animationDuration: 200.ms,
          onHoverStyle: CustomButtonStyle(
            border: Border.all(
              color: AppColors.light.accent.withValues(alpha: .2),
              width: r.size(1),
            ),
          ),
          onPressed: (position, size) {
            widget.onSignInPressed();
          },
        ),
        CustomButton(
          useIntrinsicWidth: false,
          text: 'Créer un compte',
          padding: r.symmetric(vertical: 2),
          fontSize: r.size(8),
          onPressed: (position, size) {
            widget.onSignUpPressed();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProfileDropdown(context);
  }
}
