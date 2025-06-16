import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/features/product.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_paths.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_text.dart';

class EssentialProducts extends StatefulWidget {
  const EssentialProducts({super.key});

  @override
  State<EssentialProducts> createState() => _EssentialProductsState();
}

class _EssentialProductsState extends State<EssentialProducts> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    r = ResponsiveSizeAdapter(context);
    super.initState();
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildButton() {
    return CustomButton(
      text: 'Voir Tous les Produits',
      fontSize: r.size(9),
      fontWeight: FontWeight.w500,
      textColor: AppColors.light.primary,
      iconColor: AppColors.light.accent.withValues(alpha: .6),
      svgIconPath: AppPaths.vectors.arrowToRightIcon,
      iconPosition: CustomButtonIconPosition.right,
      padding: r.symmetric(vertical: 7, horizontal: 16),
      borderRadius: BorderRadius.circular(r.size(20)),
      border: Border.all(
        color: AppColors.light.primary.withValues(alpha: .3),
        width: r.size(1),
      ),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
        backgroundColor: AppColors.light.primary.withValues(alpha: .3),
      ),
      onPressed: (position, size) {
        Beamer.of(context).beamToNamed(AppPaths.routes.boutiqueScreen);
      },
    );
  }

  Widget _buildTitleSection() {
    return CustomField(
      width: r.size(180),
      minHeight: r.size(180),
      gap: r.size(12),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'recoleta',
              fontSize: r.size(26),
              color: Colors.black, // Default color for the text
            ),
            children: [
              const TextSpan(text: "Nos "),
              TextSpan(
                text: "Produits Essentiels",
                style: TextStyle(
                  color: AppColors.light.primary, // Custom color for "Luxora"
                ),
              ),
            ],
          ),
        ),
        CustomText(
          text:
              "Découvrez les puissants bienfaits de l'extrait de figue de barbarie marocaine, un trésor naturel reconnu pour ses nutriments riches et ses propriétés réparatrices.",
          fontSize: r.size(8),
          color: AppColors.light.accent.withValues(alpha: .6),
          textAlign: TextAlign.justify,
        ),
        _buildButton(),
      ],
    );
  }

  Widget _buildEssentialProducts(BuildContext context, {bool? isCompact}) {
    return CustomField(
      width: double.infinity,
      padding: r.symmetric(horizontal: isCompact == true ? 20 : 160),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      isWrap: true,
      wrapHorizontalSpacing: r.size(12),
      wrapVerticalSpacing: r.size(12),
      arrangement: FieldArrangement.row,
      children: [
        _buildTitleSection(),
        ProductWidget(
          imageUrl: AppPaths.images.product1Image,
          name: 'Creme hydratante figue de barbarie',
          price: 120.55,
          pricePromo: 60,
          isBestSellers: true,
          onPressed: () {},
        ),
        ProductWidget(
          imageUrl: AppPaths.images.product2Image,
          name: 'Serum figue de barbarie',
          price: 120.55,
          isNewArrival: true,
          onPressed: () {},
        ),
        ProductWidget(
          imageUrl: AppPaths.images.product3Image,
          name: 'Gommage figue de barbarie',
          price: 120.55,
          pricePromo: 55,
          onPressed: () {},
        ),
        ProductWidget(
          imageUrl: AppPaths.images.product4Image,
          name: 'Blush liquide',
          price: 60.75,
          onPressed: () {},
        ),
        ProductWidget(
          imageUrl: AppPaths.images.product5Image,
          name: 'Savon figue de barbarie',
          price: 199.99,
          onPressed: () {},
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildEssentialProducts(context, isCompact: true),
      screenLargeDesktop: _buildEssentialProducts(context, isCompact: false),
    );
  }
}
