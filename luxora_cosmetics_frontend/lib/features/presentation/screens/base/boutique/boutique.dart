import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_button.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text_field.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../widgets/common/custom_text.dart';
import '../../../widgets/features/paginator.dart';
import '../../../widgets/features/product.dart';

class BoutiqueScreen extends StatefulWidget {
  const BoutiqueScreen({super.key});

  @override
  State<BoutiqueScreen> createState() => _BoutiqueScreenState();
}

class _BoutiqueScreenState extends State<BoutiqueScreen> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  Widget _buildHeader() {
    return CustomField(
      gap: r.size(6),
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'recoleta',
              fontSize: r.size(26),
              color: AppColors.light.accent, // Default color for the text
            ),
            children: [
              const TextSpan(text: "Découvrez "),
              TextSpan(
                text: "notre boutique.",
                style: TextStyle(
                  color: AppColors.light.primary, // Custom color for "Luxora"
                ),
              ),
            ],
          ),
        ),
        CustomText(
          text:
              "Des soins de la peau au maquillage, notre plateforme propose une large gamme de produits répondant à tous vos besoins en matière de beauté. Nous nous efforçons d'offrir à nos clients une expérience d'achat luxueuse, depuis la découverte de nos produits soigneusement sélectionnés jusqu'à leur réception dans notre emballage signature. Faites vos achats chez nous pour une expérience beauté ultime et haut de gamme.",
          fontSize: r.size(8),
          color: AppColors.light.accent.withValues(alpha: .6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildProductTypeButton({
    required String typeName,
    String? svgIconPath,
    bool isActive = false,
    required Function() onPressed,
  }) {
    return CustomButton(
      text: typeName,
      svgIconPath: svgIconPath,
      iconHeight: r.size(8),
      iconWidth: r.size(8),
      iconColor: isActive ? AppColors.colors.white : AppColors.light.accent,
      textColor: isActive ? AppColors.colors.white : AppColors.light.accent,
      fontSize: r.size(8),
      fontWeight: FontWeight.w400,
      padding: r.symmetric(vertical: 6, horizontal: 8),
      border: Border.all(
        width: r.size(0.6),
        color: AppColors.light.primary.withValues(alpha: .4),
      ),
      borderRadius: BorderRadius.circular(r.size(1)),
      backgroundColor:
          isActive ? AppColors.light.primary.withValues(alpha: .7) : null,
      animationDuration: 200.ms,
      onHoverStyle: CustomButtonStyle(
        textColor: isActive ? AppColors.colors.white : null,
        iconColor: isActive ? AppColors.colors.white : null,
        backgroundColor:
            isActive
                ? AppColors.light.primary.withValues(alpha: .7)
                : AppColors.light.primary.withValues(alpha: .1),
      ),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildProductTypeSelector() {
    return CustomField(
      gap: r.size(4),
      arrangement: FieldArrangement.row,
      children: [
        _buildProductTypeButton(
          typeName: 'Tous les produits',
          isActive: true,
          onPressed: () {},
        ),
        _buildProductTypeButton(
          svgIconPath: AppPaths.vectors.skinCareIcon,
          typeName: 'Soins de la peau',
          onPressed: () {},
        ),
        _buildProductTypeButton(
          svgIconPath: AppPaths.vectors.makeupIcon,
          typeName: 'Maquillage ',
          onPressed: () {},
        ),
        _buildProductTypeButton(
          svgIconPath: AppPaths.vectors.bathBodyIcon,
          typeName: 'Bain et corps ',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return CustomField(
      padding: r.symmetric(vertical: 6, horizontal: 8),
      borderRadius: r.size(1),
      border: Border.all(
        width: r.size(0.6),
        color: AppColors.light.primary.withValues(alpha: .4),
      ),
      crossAxisAlignment: CrossAxisAlignment.center,
      arrangement: FieldArrangement.row,
      children: [
        CustomTextField(
          width: r.size(160),
          hintText: 'Recherche',
          fontSize: r.size(8),
        ),
        CustomDisplay(
          assetPath: AppPaths.vectors.searchIcon,
          isSvg: true,
          width: r.size(8),
          height: r.size(8),
          svgColor: AppColors.light.accent,
        ),
      ],
    );
  }

  Widget _buildProductsList() {
    return CustomField(
      arrangement: FieldArrangement.row,
      isWrap: true,
      wrapVerticalSpacing: r.size(10),
      wrapHorizontalSpacing: r.size(10),
      children: [
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

  Widget _buildBoutique(
    BuildContext context, {
    bool? isDesktopScreen,
    bool? isTabletScreen,
    bool? isMobileScreen,
  }) {
    return CustomField(
      gap: r.size(40),
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: r.only(
        left: isDesktopScreen == true ? 20 : 120,
        right: isDesktopScreen == true ? 20 : 120,
        top: 30,
        bottom: 80,
      ),
      children: [
        _buildHeader(),
        CustomField(
          backgroundColor: AppColors.colors.white,
          padding: r.all(6),
          borderRadius: r.size(2),
          arrangement: FieldArrangement.row,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildProductTypeSelector(), _buildSearchBar()],
        ),
        _buildProductsList(),
        Paginator(totalPages: 7, onPageChanged: (int value) {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildBoutique(context),
      screenDesktop: _buildBoutique(context, isDesktopScreen: true),
      screenTablet: _buildBoutique(context, isTabletScreen: true),
      screenMobile: _buildBoutique(context, isMobileScreen: true),
    );
  }
}
