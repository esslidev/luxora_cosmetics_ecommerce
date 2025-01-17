import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_display.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_field.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/resources/language_model.dart';
import '../../../../core/util/custom_timer.dart';
import '../../../../core/util/responsive_screen_adapter.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../../core/util/translation_service.dart';
import '../../bloc/app/language/translation_bloc.dart';
import '../../bloc/app/language/translation_state.dart';
import '../../bloc/app/theme/theme_bloc.dart';
import '../../bloc/app/theme/theme_state.dart';
import '../common/custom_text.dart';

class ShowcaseWidget extends StatefulWidget {
  final List<String> networks;
  final bool isTripletMode;
  const ShowcaseWidget({
    super.key,
    required this.networks,
    this.isTripletMode = false,
  });

  @override
  State<ShowcaseWidget> createState() => _ShowcaseWidgetState();
}

class _ShowcaseWidgetState extends State<ShowcaseWidget> {
  late ResponsiveSizeAdapter r;

  late CustomTimer _tripletTimer;
  final ValueNotifier<int> _tripletIndexNotifier = ValueNotifier<int>(0);

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    _tripletTimer = CustomTimer(
      onTick: (secondsLeft) {},
      onTimerStop: () {
        if (_tripletIndexNotifier.value < (widget.networks.length - 1)) {
          _tripletIndexNotifier.value = _tripletIndexNotifier.value + 1;
        } else {
          _tripletIndexNotifier.value = 0;
        }
        _tripletTimer.start(duration: const Duration(seconds: 6));
      },
    );
    _tripletTimer.start(duration: const Duration(seconds: 6));
  }

  @override
  void dispose() {
    _tripletTimer.stop();
    _tripletIndexNotifier.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, themeState) {
      return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
        if (translationState.translationService != null &&
            translationState.language != null) {
          return renderContent(
            themeState.theme,
            translationState.translationService!,
            translationState.language!,
          );
        }
        return const SizedBox();
      });
    });
  }

  Widget renderContent(
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
  ) {
    if (widget.isTripletMode && widget.networks.length >= 3) {
      return ResponsiveScreenAdapter(
        fallbackScreen: _buildLargeDesktopTriplet(
            networks: widget.networks, theme: theme, isRtl: language.isRtl),
        screenTablet: _buildTabletMobileTriplet(
            networks: widget.networks, theme: theme, isRtl: language.isRtl),
        screenMobile: _buildTabletMobileTriplet(
            networks: widget.networks, theme: theme, isRtl: language.isRtl),
      );
    }
    if (widget.networks.isNotEmpty) {
      return ResponsiveScreenAdapter(
        fallbackScreen: _buildSlider(
            networks: widget.networks, theme: theme, isRtl: language.isRtl),
        screenTablet: _buildSlider(
            networks: widget.networks,
            height: r.nonMultipliedSize(400),
            theme: theme,
            isRtl: language.isRtl),
        screenMobile: _buildSlider(
            networks: widget.networks,
            height: r.nonMultipliedSize(400),
            theme: theme,
            isRtl: language.isRtl),
      );
    }
    return _buildEmpty(theme: theme, ts: ts, language: language);
  }

  Widget _buildLargeDesktopTriplet(
      {required BaseTheme theme,
      required List<String> networks,
      required bool isRtl}) {
    return ValueListenableBuilder<int>(
      valueListenable: _tripletIndexNotifier,
      builder: (BuildContext context, int networksIndex, Widget? child) {
        return CustomField(
          height: r.nonMultipliedSize(300),
          margin: r.symmetric(horizontal: 4),
          arrangement: FieldArrangement.row,
          gap: r.size(4),
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 70, // 60% width
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: CustomDisplay(
                      key: ValueKey<int>(networksIndex),
                      assetPath: networks[networksIndex],
                      loadingWidget: _buildLoading(theme: theme),
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: r.nonMultipliedSize(300),
                      onTap: () {
                        print("showcase clicked");
                      },
                      cursor: SystemMouseCursors.click,
                    ),
                  ),
                  Positioned(
                      bottom: r.size(8),
                      left: isRtl != true ? r.size(22) : null,
                      right: isRtl == true ? r.size(22) : null,
                      child: _buildShowcaseIndicators(
                          index: networksIndex,
                          length: networks.length,
                          isRtl: isRtl,
                          onTap: (int index) {
                            _tripletIndexNotifier.value = index;
                            _tripletTimer.start(
                                duration: const Duration(seconds: 6));
                          }))
                ],
              ),
            ),
            Expanded(
              flex: 30, // 40% width
              child: CustomField(
                gap: r.nonMultipliedSize(4),
                children: [
                  Expanded(
                    flex: 1,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: CustomDisplay(
                        key: ValueKey<int>(
                            (networksIndex + 1) % networks.length),
                        assetPath:
                            networks[(networksIndex + 1) % networks.length],
                        loadingWidget: _buildLoading(theme: theme),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: r.nonMultipliedSize(300),
                        onTap: () {
                          print("showcase clicked");
                        },
                        cursor: SystemMouseCursors.click,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: CustomDisplay(
                        key: ValueKey<int>(
                            (networksIndex + 1) % networks.length),
                        assetPath:
                            networks[(networksIndex + 2) % networks.length],
                        loadingWidget: _buildLoading(theme: theme),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: r.nonMultipliedSize(300),
                        onTap: () {
                          print("showcase clicked");
                        },
                        cursor: SystemMouseCursors.click,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabletMobileTriplet(
      {required BaseTheme theme,
      required List<String> networks,
      required bool isRtl}) {
    return ValueListenableBuilder<int>(
      valueListenable: _tripletIndexNotifier,
      builder: (BuildContext context, int networksIndex, Widget? child) {
        return CustomField(
          margin: r.symmetric(horizontal: 4),
          arrangement: FieldArrangement.column,
          gap: r.size(4),
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: CustomDisplay(
                key: ValueKey<int>(networksIndex),
                assetPath: networks[networksIndex],
                fit: BoxFit.fill,
                loadingWidget: _buildLoading(theme: theme),
                width: double.infinity,
                height: r.nonMultipliedSize(300),
                onTap: () {
                  print("showcase clicked");
                },
                cursor: SystemMouseCursors.click,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: CustomDisplay(
                key: ValueKey<int>((networksIndex + 1) % networks.length),
                assetPath: networks[(networksIndex + 1) % networks.length],
                fit: BoxFit.fill,
                width: double.infinity,
                loadingWidget: _buildLoading(theme: theme),
                height: r.nonMultipliedSize(300),
                onTap: () {
                  print("showcase clicked");
                },
                cursor: SystemMouseCursors.click,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: CustomDisplay(
                key: ValueKey<int>((networksIndex + 2) % networks.length),
                assetPath: networks[(networksIndex + 2) % networks.length],
                fit: BoxFit.fill,
                width: double.infinity,
                loadingWidget: _buildLoading(theme: theme),
                height: r.nonMultipliedSize(300),
                onTap: () {
                  print("showcase clicked");
                },
                cursor: SystemMouseCursors.click,
              ),
            ),
            _buildShowcaseIndicators(
                index: networksIndex,
                length: networks.length,
                color: theme.accent,
                isRtl: isRtl,
                onTap: (int index) {
                  _tripletIndexNotifier.value = index;
                  _tripletTimer.start(duration: const Duration(seconds: 6));
                })
          ],
        );
      },
    );
  }

  Widget _buildSlider(
      {required BaseTheme theme,
      required List<String> networks,
      double? height,
      required bool isRtl}) {
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: networks.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return CustomDisplay(
              assetPath: networks[index],
              fit: BoxFit.fill,
              width: double.infinity,
              height: height ?? r.nonMultipliedSize(300),
              loadingWidget: _buildLoading(theme: theme),
              onTap: () {
                print("showcase clicked");
              },
              cursor: SystemMouseCursors.click,
            );
          },
          options: CarouselOptions(
            height: height ?? r.nonMultipliedSize(300),
            viewportFraction: 1,
            enlargeCenterPage: false,
            pauseAutoPlayOnTouch: false,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            autoPlay: true,
            scrollPhysics: const CarouselScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _tripletIndexNotifier.value = index;
                _tripletTimer.start(duration: const Duration(seconds: 6));
              });
            },
            // autoPlay: false,
          ),
        ),
        Positioned(
            bottom: r.size(8),
            left: isRtl != true ? r.size(22) : null,
            right: isRtl == true ? r.size(22) : null,
            child: _buildShowcaseIndicators(
                index: _tripletIndexNotifier.value,
                length: networks.length,
                isRtl: isRtl,
                onTap: (int index) {
                  _carouselController.animateToPage(index);
                  _tripletTimer.start(duration: const Duration(seconds: 6));
                }))
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildShowcaseIndicators(
      {required int index,
      required int length,
      required bool isRtl,
      Color? color,
      required Function(int index) onTap}) {
    return CustomField(
      gap: r.size(8),
      isRtl: isRtl,
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        length,
        (i) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              onTap(i);
            },
            child: AnimatedContainer(
              duration: 300.ms,
              width: i == index ? r.size(6) : r.size(4),
              height: i == index ? r.size(6) : r.size(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: r.size(1.5),
                    color: i == index
                        ? AppColors.colors.greenSwagger
                        : Colors.transparent),
                color: i == index
                    ? Colors.transparent
                    : color ??
                        AppColors.colors.whiteSolid, // Highlight active dot
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading({required BaseTheme theme}) {
    return Container(
      width: double.infinity,
      height: r.nonMultipliedSize(300),
      padding: r.symmetric(horizontal: 12),
      color: theme.thirdBackgroundColor,
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
            delay: 200.ms,
            duration: 500.ms,
            curve: Curves.easeInOut,
            color: theme.accent.withOpacity(0.2));
  }

  Widget _buildEmpty({
    required BaseTheme theme,
    required TranslationService ts,
    required LanguageModel language,
  }) {
    return Container(
      width: double.infinity,
      height: r.nonMultipliedSize(300),
      padding: r.symmetric(horizontal: 12),
      color: theme.secondaryBackgroundColor,
      child: Center(
        child: CustomText(
          color: theme.bodyText,
          textDirection:
              language.isRtl == true ? TextDirection.rtl : TextDirection.ltr,
          fontSize: r.size(12),
          text: ts.translate('widgets.showcase.emptyShowcase'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
