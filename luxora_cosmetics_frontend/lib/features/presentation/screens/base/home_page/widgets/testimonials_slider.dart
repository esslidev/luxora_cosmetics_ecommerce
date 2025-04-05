import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class Testimonial {
  final String customerName;
  final String customerImageUrl;
  final String city;
  final String country;
  final String testimonial;

  const Testimonial({
    required this.customerName,
    required this.customerImageUrl,
    required this.city,
    required this.country,
    required this.testimonial,
  });
}

class TestimonialsSlider extends StatefulWidget {
  final List<Testimonial> testimonials;
  const TestimonialsSlider({super.key, required this.testimonials});

  @override
  State<TestimonialsSlider> createState() => _TestimonialsSliderState();
}

class _TestimonialsSliderState extends State<TestimonialsSlider> {
  late ResponsiveSizeAdapter r;

  int _currentCarouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildSliderIndicator({
    required int index,
    required int length,
    required Function(int index) onPressed,
  }) {
    return CustomField(
      gap: r.size(3),
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        length,
        (i) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              onPressed(i);
            },
            child: AnimatedContainer(
              duration: 300.ms,
              width: r.size(8),
              height: r.size(8),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  width: r.size(0.6),
                  color: AppColors.light.secondary,
                ),
                color:
                    i == index
                        ? AppColors.light.secondary
                        : Colors.transparent, // Highlight active dot
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerImage({
    required String imageUrl,
    bool? isTabletScreen,
    bool? isMobileScreen,
  }) {
    return CustomField(
      backgroundColor: AppColors.colors.jetGrey.withValues(alpha: .1),
      borderRadius: r.size(100),
      width:
          isMobileScreen == true
              ? r.size(60)
              : isTabletScreen == true
              ? r.size(120)
              : r.size(180),
      height:
          isMobileScreen == true
              ? r.size(60)
              : isTabletScreen == true
              ? r.size(120)
              : r.size(180),
      padding: r.all(6),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomDisplay(
          assetPath: imageUrl,
          backgroundColor: AppColors.light.secondary,
          borderRadius: BorderRadius.circular(r.size(100)),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard({
    required Testimonial testimonial,
    bool? isTabletScreen,
    bool? isMobileScreen,
  }) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomField(
          minHeight: r.size(200),
          maxHeight: r.size(280),
          width: r.size(500),
          gap: r.size(12),
          backgroundColor: AppColors.colors.white,
          margin: r.only(right: isMobileScreen == true ? 0 : 90),
          padding: r.symmetric(vertical: 20, horizontal: 30),
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDisplay(
              assetPath: AppPaths.vectors.quoteIcon,
              isSvg: true,
              width: r.size(24),
              height: r.size(24),
            ),
            CustomText(
              maxWidth: r.size(300),
              text: testimonial.testimonial,
              fontFamily: 'recoleta',
              fontSize: r.size(14),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            CustomField(
              gap: r.size(2),
              children: [
                CustomText(
                  maxWidth: r.size(300),
                  text: testimonial.customerName,
                  fontSize: r.size(11),
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  maxWidth: r.size(300),
                  text:
                      '${testimonial.city}, ${testimonial.country.toUpperCase()}',
                  fontSize: r.size(7),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: isMobileScreen == true ? 0 : null,
          right: 0,
          child: _buildCustomerImage(
            imageUrl: testimonial.customerImageUrl,
            isTabletScreen: isTabletScreen,
            isMobileScreen: isMobileScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialsSlider(
    BuildContext context, {
    bool? isDesktopScreen,
    bool? isTabletScreen,
    bool? isMobileScreen,
  }) {
    return CustomField(
      width: double.infinity,
      padding: r.symmetric(
        vertical: 20,
        horizontal:
            isDesktopScreen == true ||
                    isTabletScreen == true ||
                    isMobileScreen == true
                ? 20
                : 160,
      ),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      isWrap: true,
      wrapHorizontalSpacing: r.size(12),
      wrapVerticalSpacing: r.size(12),
      children: [
        Stack(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: r.size(280),
                autoPlay: true,
                autoPlayInterval: 10.seconds,
                autoPlayAnimationDuration: 1.seconds,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
              items:
                  widget.testimonials.map((testimonial) {
                    return _buildTestimonialCard(
                      testimonial: testimonial,
                      isTabletScreen: isTabletScreen,
                      isMobileScreen: isMobileScreen,
                    );
                  }).toList(),
            ),
            Positioned(
              bottom: r.size(20),
              right: 0,
              left: r.size(80),
              child: _buildSliderIndicator(
                index: _currentCarouselIndex,
                length: widget.testimonials.length,
                onPressed: (index) {
                  _carouselController.animateToPage(index);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildTestimonialsSlider(context),
      screenDesktop: _buildTestimonialsSlider(context, isDesktopScreen: true),
      screenTablet: _buildTestimonialsSlider(context, isTabletScreen: true),
      screenMobile: _buildTestimonialsSlider(context, isMobileScreen: true),
    );
  }
}
