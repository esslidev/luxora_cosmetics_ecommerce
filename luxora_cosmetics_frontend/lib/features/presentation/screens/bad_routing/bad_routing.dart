import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_button.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../widgets/common/custom_field.dart';

class BadRoutingScreen extends StatelessWidget {
  const BadRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);

    return Scaffold(
      body: CustomField(
        width: r.screenWidth,
        height: r.screenHeight,
        gap: r.size(20),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomDisplay(
            assetPath: AppPaths.images.errorPageImage,
            width: r.size(400),
          ),
          CustomField(
            gap: r.size(9),
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                maxWidth: r.size(200),
                text: 'Oups ! On dirait que vous êtes perdu(e)',
                fontFamily: 'recoleta',
                fontSize: r.size(16),
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
              CustomText(
                maxWidth: r.size(340),
                text:
                    'Pas d’inquiétude, la page d’accueil est à un clic d’ici. Revenons vite pour continuer votre shopping beauté !',
                fontSize: r.size(9),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          CustomButton(
            text: 'Accéder à l’accueil',
            fontSize: r.size(9),
            fontWeight: FontWeight.bold,
            textColor: AppColors.colors.white,
            backgroundColor: AppColors.light.primary,
            padding: r.symmetric(vertical: 6, horizontal: 20),
            border: Border.all(color: Colors.transparent, width: r.size(1)),
            animationDuration: 200.ms,
            onHoverStyle: CustomButtonStyle(
              border: Border.all(
                color: AppColors.light.accent.withValues(alpha: .2),
                width: r.size(1),
              ),
            ),
            onPressed: (position, size) {
              Beamer.of(context).beamToNamed(AppPaths.routes.homePageScreen);
            },
          ),
        ],
      ),
    );
  }
}
