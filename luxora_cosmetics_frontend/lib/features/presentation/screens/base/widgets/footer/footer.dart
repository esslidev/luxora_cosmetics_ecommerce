import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/core/enums/widgets.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/screens/base/widgets/footer/widgets/join_us_grid.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_button.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_line.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../core/util/app_util.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  Widget _buildLogoButton({double? height}) {
    return CustomDisplay(
      assetPath: AppPaths.images.logoDark,
      height: height ?? r.size(62),
    );
  }

  Widget _buildQuoteText() {
    return CustomText(
      maxWidth: r.size(240),
      text:
          "Rejoignez la famille Luxora et adoptez l'essence de la beauté marocaine.",
      fontSize: r.size(11),
      fontFamily: 'recoleta',
      color: AppColors.colors.white,
    );
  }

  Widget _buildSocialButton({required String path, required String socialUrl}) {
    ValueNotifier<bool> isHoveredNotifier = ValueNotifier(false);
    return ValueListenableBuilder(
        valueListenable: isHoveredNotifier,
        builder: (BuildContext context, bool isHovered, Widget? child) {
          return CustomButton(
            svgIconPath: path,
            height: r.size(9),
            onHoverEnter: (position, size) {
              isHoveredNotifier.value = true;
            },
            onHoverExit: () {
              isHoveredNotifier.value = false;
            },
            onPressed: (position, size) {
              AppUtil.launchURL(socialUrl);
            },
          ).animate(target: isHovered == true ? 1 : 0).scaleXY(
                duration: 250.ms,
                curve: Curves.easeOut,
                begin: 1,
                end: 1.4,
              );
        });
  }

  Widget _buildSocialButtons() {
    return CustomField(
      gap: r.size(12),
      arrangement: FieldArrangement.row,
      children: [
        _buildSocialButton(
            path: AppPaths.vectors.facebookIcon,
            socialUrl: 'https://facebook.com'),
        _buildSocialButton(
            path: AppPaths.vectors.instagramIcon,
            socialUrl: 'https://instagram.com'),
        _buildSocialButton(
            path: AppPaths.vectors.twitterIcon, socialUrl: 'https://x.com'),
        _buildSocialButton(
            path: AppPaths.vectors.linkdinIcon,
            socialUrl: 'https://linkedin.com'),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Stack(
      children: [
        CustomField(
          width: double.infinity,
          height: r.size(240),
          backgroundColor: AppColors.colors.lostInSadness,
          margin: r.only(top: r.size(50)),
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomField(
                gap: r.size(24),
                margin: r.only(top: 60),
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                arrangement: FieldArrangement.row,
                children: [
                  _buildLogoButton(),
                  _buildQuoteText(),
                  _buildSocialButtons(),
                ],
              ),
            ),
            CustomField(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomLine(
                  size: r.size(200),
                  thickness: r.size(.4),
                  color: AppColors.colors.white.withValues(alpha: .3),
                ),
                CustomText(
                  padding: r.symmetric(vertical: 16),
                  text: 'Copyright © 2025 Devwave  | All rights reserved.',
                  color: AppColors.colors.white.withValues(alpha: .6),
                )
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: JoinUsGrid(items: [
            JoinUsGridItem(
                imagePath: AppPaths.images.joinUsImage1,
                instagramUrl: 'https://instagram.com'),
            JoinUsGridItem(
                imagePath: AppPaths.images.joinUsImage2,
                instagramUrl: 'https://instagram.com'),
            JoinUsGridItem(
                imagePath: AppPaths.images.joinUsImage3,
                instagramUrl: 'https://instagram.com'),
            JoinUsGridItem(
                imagePath: AppPaths.images.joinUsImage2,
                instagramUrl: 'https://instagram.com'),
          ]),
        ),
        Positioned(
            bottom: 0,
            child: CustomDisplay(
              assetPath: AppPaths.vectors.branchDecoration2,
              width: r.size(120),
              isSvg: true,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildFooter(context),
    );
  }
}
