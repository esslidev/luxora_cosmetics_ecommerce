import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/screens/base/home_page/widgets/milestones.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/screens/base/home_page/widgets/rediscover_banner.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';

import '../../../../../../core/util/app_events_util.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../domain/entities/product.dart';
import '../../../widgets/common/custom_display.dart';
import 'widgets/brands_slider.dart';
import 'widgets/essential_products.dart';
import 'widgets/mission_vision_banner.dart';
import 'widgets/promo_videos.dart';
import 'widgets/testimonials_slider.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late ResponsiveSizeAdapter r;

  bool isEssentialProductsLoadingResponse = false;
  List<ProductEntity>? _essentialProductsResponse;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    AppEventsUtil.breadCrumbs.clearBreadCrumbs(
      context,
    );
    AppEventsUtil.routeEvents
        .changePath(context, AppPaths.routes.homePageScreen);
  }

  Widget _buildBranchDecoration({bool isReversed = false}) {
    return Transform.flip(
      flipX: isReversed,
      child: CustomDisplay(
        assetPath: AppPaths.vectors.branchDecoration1,
        width: r.size(160),
        isSvg: true,
        svgColor: AppColors.colors.jetGrey.withValues(alpha: .1),
      ).animate(onPlay: (controller) {
        controller.repeat(reverse: true);
      }).moveY(
        duration: 1.seconds,
        curve: Curves.fastOutSlowIn,
        begin: 0,
        end: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: r.size(200), child: _buildBranchDecoration()),
        Positioned(
          top: r.size(1800),
          right: 0,
          child: _buildBranchDecoration(isReversed: true),
        ),
        CustomField(
          children: [
            const RediscoverBanner(),
            const MissionVisionBanner(),
            const PromoVideos(),
            const EssentialProducts(),
            const Milestones(),
            TestimonialsSlider(testimonials: [
              Testimonial(
                  customerName: 'Sanaa L.',
                  customerImageUrl: AppPaths.images.testimonialCustomerImage,
                  city: 'Rabat',
                  country: 'Maroc',
                  testimonial:
                      'Ayant la peau sensible, je suis toujours prudent(e) lorsque j’essaie de nouveaux produits, mais le sérum au figuier de Barbarie de Luxora a dépassé mes attentes. Il est doux, apaisant et a aidé à réduire les rougeurs sur mon visage. Les ingrédients naturels me rassurent, et j’ai remarqué une nette amélioration de la texture de ma peau après seulement deux semaines. Un indispensable !'),
              Testimonial(
                  customerName: 'Sanaa L.',
                  customerImageUrl: AppPaths.images.testimonialCustomerImage,
                  city: 'Tangier',
                  country: 'Maroc',
                  testimonial:
                      'En tant que personne à la peau sensible, je suis toujours prudent(e) avec les nouveaux produits, mais le sérum au figuier de Barbarie de Luxora a dépassé mes attentes. Il est doux, apaisant et a aidé à réduire les rougeurs de mon visage. Ses ingrédients naturels me rassurent, et j’ai constaté une amélioration visible de la texture de ma peau en seulement deux semaines. Un incontournable !'),
              Testimonial(
                  customerName: 'Sanaa L.',
                  customerImageUrl: AppPaths.images.testimonialCustomerImage,
                  city: 'Casablanca',
                  country: 'Maroc',
                  testimonial:
                      'Ce sérum fait des merveilles ! Ma peau est incroyablement hydratée et repulpée, surtout pendant les mois froids où elle a tendance à se dessécher. La seule raison pour laquelle je lui ai donné 4 étoiles au lieu de 5, c’est que j’aurais aimé que le flacon soit plus grand—je n’en ai jamais assez ! Il vaut chaque centime pour les résultats qu’il offre.'),
            ]),
            BrandsSlider(
              brandsPaths: [
                AppPaths.images.calvinKleinBrandImage,
                AppPaths.images.aloeVeraBrandImage,
                AppPaths.images.farmesiBrandImage,
                AppPaths.images.barioneBrandImage,
                AppPaths.images.vaoodaBrandImage,
              ],
            ),
          ],
        ),
      ],
    );
  }
}
