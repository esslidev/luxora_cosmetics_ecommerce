import 'package:flutter/material.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class Milestones extends StatefulWidget {
  const Milestones({super.key});

  @override
  State<Milestones> createState() => _MilestonesState();
}

class _MilestonesState extends State<Milestones> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    r = ResponsiveSizeAdapter(context);
    super.initState();
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildImage() {
    return CustomDisplay(
      backgroundColor: AppColors.colors.peachOfMind,
      assetPath: AppPaths.images.milestonesImage,
      width: r.size(200),
      height: r.size(280),
      borderRadius: BorderRadius.circular(r.size(200)),
    );
  }

  Widget _buildSectionText() {
    return CustomField(
      gap: r.size(9),
      children: [
        SizedBox(
          width: r.size(300),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'recoleta',
                fontSize: r.size(26),
                color: Colors.black, // Default color for the text
              ),
              children: [
                const TextSpan(
                  text: "Nous sublimons ",
                ),
                TextSpan(
                  text: "la beauté",
                  style: TextStyle(
                    color: AppColors.light.primary, // Custom color for "Luxora"
                  ),
                ),
                const TextSpan(
                  text: " au naturel.",
                ),
              ],
            ),
          ),
        ),
        CustomText(
          width: r.size(340),
          text:
              "Rejoignez la famille Luxora et embrassez l'essence de la beauté marocaine. Découvrez notre collection de soins biologiques et laissez la nature prendre soin de votre peau.",
          fontSize: r.size(9),
        ),
      ],
    );
  }

  Widget _buildSectionMilestoneCard(
      {required String title,
      required String count,
      bool reverseGradient = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: 30 * 3.14159 / 180,
          child: Container(
            width: r.size(90),
            height: r.size(120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              gradient: LinearGradient(
                colors: [AppColors.colors.white, AppColors.colors.snowGreen],
                begin: reverseGradient
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                end: reverseGradient
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        CustomField(
          width: r.size(60),
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: r.size(4),
          children: [
            CustomText(
              text: title,
              fontSize: r.size(9),
              fontWeight: FontWeight.w500,
              color: AppColors.light.accent.withValues(alpha: .8),
              textAlign: TextAlign.center,
            ),
            CustomText(
              text: count,
              fontFamily: 'recoleta',
              fontSize: r.size(24),
              color: AppColors.light.primary,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSection() {
    return CustomField(
      minWidth: r.size(800),
      gap: r.size(18),
      backgroundColor: AppColors.light.backgroundSecondary,
      margin: r.only(right: r.size(70)),
      padding: r.symmetric(
        vertical: 80,
      ),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionText(),
        CustomField(
          minWidth: r.size(340),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          arrangement: FieldArrangement.row,
          children: [
            _buildSectionMilestoneCard(
              title: 'Product Users',
              count: "10K+",
            ),
            _buildSectionMilestoneCard(
              title: 'Brand Product',
              count: "10+",
              reverseGradient: true,
            ),
            _buildSectionMilestoneCard(
              title: 'Product Reviews',
              count: "5K",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestones(BuildContext context) {
    return CustomField(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: r.symmetric(vertical: 40),
      arrangement: FieldArrangement.row,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            _buildSection(),
            Positioned(right: 0, child: _buildImage()),
          ],
        )
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildMilestones(context),
    );
  }
}
