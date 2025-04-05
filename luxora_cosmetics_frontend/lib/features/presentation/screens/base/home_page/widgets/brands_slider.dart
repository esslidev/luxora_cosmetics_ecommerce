import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class BrandsSlider extends StatefulWidget {
  final List<String> brandsPaths;
  const BrandsSlider({super.key, required this.brandsPaths});

  @override
  State<BrandsSlider> createState() => _BrandsSliderState();
}

class _BrandsSliderState extends State<BrandsSlider> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildBrandImage({required String assetPath}) {
    ValueNotifier<bool> isHoveredNotifier = ValueNotifier(false);
    return ValueListenableBuilder(
      valueListenable: isHoveredNotifier,
      builder: (BuildContext context, bool isHovered, Widget? child) {
        return CustomDisplay(
              assetPath: assetPath,
              height: r.size(20),
              onHoverEnter: () {
                isHoveredNotifier.value = true;
              },
              onHoverExit: () {
                isHoveredNotifier.value = false;
              },
            )
            .animate(target: isHovered == true ? 1 : 0)
            .fadeIn(duration: 350.ms, curve: Curves.easeOut, begin: .5);
      },
    );
  }

  Widget _buildBrandsSlider(
    BuildContext context, {
    bool? isDesktopScreen,
    bool? isTabletScreen,
    bool? isMobileScreen,
  }) {
    return CustomField(
      width: double.infinity,
      padding: r.symmetric(
        vertical: 60,
        horizontal:
            isDesktopScreen == true
                ? 60
                : isTabletScreen == true || isMobileScreen == true
                ? 20
                : 160,
      ),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      isWrap: true,
      wrapHorizontalSpacing: r.size(12),
      wrapVerticalSpacing: r.size(12),
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: r.size(20),
            autoPlay: true,
            autoPlayInterval: 4.seconds,
            autoPlayAnimationDuration: 10.seconds,
            autoPlayCurve: Curves.linear,
            enlargeCenterPage: false,
            viewportFraction:
                isTabletScreen == true
                    ? 1 / 4
                    : isMobileScreen == true
                    ? 1 / 2
                    : 1 / 5,
            enableInfiniteScroll: true,
          ),
          items:
              widget.brandsPaths.map((imagePath) {
                return _buildBrandImage(assetPath: imagePath);
              }).toList(),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildBrandsSlider(context),
      screenDesktop: _buildBrandsSlider(context, isDesktopScreen: true),
      screenTablet: _buildBrandsSlider(context, isTabletScreen: true),
      screenMobile: _buildBrandsSlider(context, isMobileScreen: true),
    );
  }
}
