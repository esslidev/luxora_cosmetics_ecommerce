import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class MissionVisionBanner extends StatefulWidget {
  const MissionVisionBanner({super.key});

  @override
  State<MissionVisionBanner> createState() => _MissionVisionBannerState();
}

class _MissionVisionBannerState extends State<MissionVisionBanner> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    r = ResponsiveSizeAdapter(context);
    super.initState();
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildImage({double? size}) {
    return CustomDisplay(
      assetPath: AppPaths.images.missionVisionBannerImage,
      height: size ?? r.size(260),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(size ?? r.size(150)),
        topRight: Radius.circular(size ?? r.size(150)),
      ),
    );
  }

  Widget _buildSectionText() {
    return SizedBox(
      width: r.size(340),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'recoleta',
            fontSize: r.size(22),
            color: Colors.black, // Default color for the text
          ),
          children: [
            const TextSpan(
              text:
                  "Découvrez l'harmonie entre nature et innovation avec les soins du Maroc par ",
            ),
            TextSpan(
              text: "Luxora.",
              style: TextStyle(
                color: AppColors.light.primary, // Custom color for "Luxora"
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String text}) {
    return CustomField(
      width: r.size(160),
      gap: r.size(4),
      children: [
        CustomText(
          text: title,
          fontSize: r.size(9),
          fontWeight: FontWeight.w600,
          color: AppColors.light.accent.withValues(alpha: .8),
        ),
        CustomText(
          text: text,
          fontSize: r.size(8),
          color: AppColors.light.accent.withValues(alpha: .6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildSection({bool? isDesktopScreen}) {
    return CustomField(
      gap: r.size(18),
      backgroundColor: AppColors.light.backgroundSecondary,
      margin: r.only(left: isDesktopScreen == true ? 140 : 160),
      padding: r.symmetric(
        vertical: isDesktopScreen == true ? 40 : 80,
        horizontal: isDesktopScreen == true ? 60 : 140,
      ),
      children: [
        _buildSectionText(),
        CustomField(
          gap: r.size(12),
          arrangement: FieldArrangement.row,
          children: [
            _buildSectionCard(
              title: 'Notre Mission',
              text:
                  "Offrir des produits de beauté naturels qui célèbrent le patrimoine marocain, respectent l'environnement et soutiennent les communautés locales.",
            ),
            _buildSectionCard(
              title: 'Notre Vision',
              text:
                  "Mélanger la tradition marocaine avec l'innovation pour créer des produits durables et de haute qualité qui autonomisent les communautés.",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionOnSmallScreens({bool? isMobileScreen}) {
    return CustomField(
      width: double.infinity,
      gap: r.size(18),
      backgroundColor: AppColors.light.backgroundSecondary,
      margin: r.only(top: 120),
      padding: r.only(top: 80, bottom: 20, left: 20, right: 20),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionText(),
        CustomField(
          gap: r.size(12),
          mainAxisSize: MainAxisSize.min,
          arrangement:
              isMobileScreen == true
                  ? FieldArrangement.column
                  : FieldArrangement.row,
          children: [
            _buildSectionCard(
              title: 'Notre Mission',
              text:
                  "Offrir des produits de beauté naturels qui célèbrent le patrimoine marocain, respectent l'environnement et soutiennent les communautés locales.",
            ),
            _buildSectionCard(
              title: 'Notre Vision',
              text:
                  "Mélanger la tradition marocaine avec l'innovation pour créer des produits durables et de haute qualité qui autonomisent les communautés.",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionVisionBanner(
    BuildContext context, {
    bool? isDesktopScreen,
  }) {
    return CustomField(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        Stack(
          children: [
            _buildSection(isDesktopScreen: isDesktopScreen),
            Positioned(
              top: 0,
              bottom: 0,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  _buildImage(
                    size: isDesktopScreen == true ? r.size(180) : null,
                  ),
                  Positioned(
                    top: r.size(36),
                    right: 0,
                    child: CustomField(
                      width: r.size(60),
                      height: r.size(60),
                      borderRadius: r.size(30),
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      backgroundColor: AppColors.colors.white.withValues(
                        alpha: .6,
                      ),
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomDisplay(
                                  assetPath:
                                      AppPaths
                                          .vectors
                                          .missionVisionBannerRoundedText,
                                  isSvg: true,
                                  width: r.size(54),
                                  height: r.size(54),
                                )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .rotate(duration: 10.seconds, begin: 1, end: 0),
                            Align(
                              alignment: Alignment.center,
                              child: CustomDisplay(
                                assetPath:
                                    AppPaths.vectors.arrowToBottomIconStyle2,
                                svgColor: AppColors.light.secondary.withValues(
                                  alpha: .8,
                                ),
                                isSvg: true,
                                width: r.size(24),
                                height: r.size(24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionVisionBannerOnSmallScreens(
    BuildContext context, {
    bool? isMobileScreen,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildSectionOnSmallScreens(isMobileScreen: isMobileScreen),
        _buildImage(size: r.size(180)),
        Transform.translate(
          offset: Offset(r.size(60), 0),
          child: CustomField(
            width: r.size(60),
            height: r.size(60),
            borderRadius: r.size(30),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            backgroundColor: AppColors.colors.white.withValues(alpha: .6),
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CustomDisplay(
                        assetPath:
                            AppPaths.vectors.missionVisionBannerRoundedText,
                        isSvg: true,
                        width: r.size(54),
                        height: r.size(54),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 10.seconds, begin: 1, end: 0),
                  Align(
                    alignment: Alignment.center,
                    child: CustomDisplay(
                      assetPath: AppPaths.vectors.arrowToBottomIconStyle2,
                      svgColor: AppColors.light.secondary.withValues(alpha: .8),
                      isSvg: true,
                      width: r.size(24),
                      height: r.size(24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildMissionVisionBanner(context),
      screenDesktop: _buildMissionVisionBanner(context, isDesktopScreen: true),
      screenTablet: _buildMissionVisionBannerOnSmallScreens(context),
      screenMobile: _buildMissionVisionBannerOnSmallScreens(
        context,
        isMobileScreen: true,
      ),
    );
  }
}
