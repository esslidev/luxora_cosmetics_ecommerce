import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_button.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class RediscoverBanner extends StatefulWidget {
  const RediscoverBanner({super.key});

  @override
  State<RediscoverBanner> createState() => _RediscoverBannerState();
}

class _RediscoverBannerState extends State<RediscoverBanner> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    r = ResponsiveSizeAdapter(context);
    super.initState();
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildTitle() {
    return CustomField(
      children: [
        CustomText(
          text: 'Rediscover',
          fontFamily: 'recoleta',
          fontSize: r.size(42),
          lineHeight: 1,
        ),
        CustomText(
          text: 'Your Natural',
          fontFamily: 'recoleta',
          fontSize: r.size(42),
          lineHeight: 1,
        ),
        CustomField(
          crossAxisAlignment: CrossAxisAlignment.center,
          arrangement: FieldArrangement.row,
          children: [
            Padding(
              padding: r.symmetric(horizontal: 24),
              child: CustomDisplay(
                assetPath: AppPaths.images.rediscoverBannerTitleImage,
                height: r.size(42),
              ),
            ),
            CustomText(
              text: 'Beauty',
              fontFamily: 'recoleta',
              fontSize: r.size(42),
              lineHeight: 1,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSubtitle() {
    return CustomText(
      maxWidth: r.size(280),
      text:
          'Inspirée par les trésors du Maroc, notre gamme de soins allie tradition et modernité pour offrir à votre peau le meilleur de la nature.',
      fontSize: r.size(9),
      fontWeight: FontWeight.w500,
      color: AppColors.light.accent.withValues(alpha: .6),
      lineHeight: 1.6,
    );
  }

  Widget _buildButton() {
    return CustomButton(
      text: 'Acheter Maintenant',
      fontSize: r.size(9),
      fontWeight: FontWeight.w500,
      textColor: AppColors.colors.white,
      iconColor: AppColors.colors.white,
      svgIconPath: AppPaths.vectors.arrowToRightIcon,
      iconPosition: CustomButtonIconPosition.right,
      backgroundColor: AppColors.light.primary,
      padding: r.symmetric(vertical: 7, horizontal: 16),
      borderRadius: BorderRadius.circular(r.size(20)),
      border: Border.all(
        color: Colors.transparent,
        width: r.size(1),
      ),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
        border: Border.all(
          color: AppColors.light.accent.withValues(alpha: .2),
          width: r.size(1),
        ),
      ),
      onPressed: (position, size) {
        Beamer.of(context).beamToNamed(
          AppPaths.routes.boutiqueScreen,
        );
      },
    );
  }

  Widget _buildImage() {
    return CustomDisplay(
      assetPath: AppPaths.images.rediscoverBannerImage,
      height: r.size(300),
    );
  }

  Widget _buildRediscoverBanner(BuildContext context) {
    return CustomField(
      padding: r.symmetric(horizontal: 160),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        CustomField(
          gap: r.size(18),
          children: [
            _buildTitle(),
            _buildSubtitle(),
            _buildButton(),
          ],
        ),
        _buildImage(),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildRediscoverBanner(context),
    );
  }
}
