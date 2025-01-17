import 'package:beamer/beamer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/features/presentation/screens/home/widgets/lite_notifications/lite_notifications.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';

import '../../../../config/routes/app_routes/home_routes/home_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/resources/global_contexts.dart';
import '../../../../core/resources/language_model.dart';
import '../../../../core/util/responsive_screen_adapter.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../../locator.dart';
import '../../../data/data_sources/local/app_database.dart';
import '../../bloc/app/language/translation_bloc.dart';
import '../../bloc/app/language/translation_state.dart';
import '../../bloc/app/theme/theme_bloc.dart';
import '../../bloc/app/theme/theme_state.dart';
import '../../widgets/common/custom_field.dart';
import 'widgets/footer.dart';
import 'widgets/header/header.dart';
import 'widgets/header_tape.dart';
import 'widgets/navigator.dart';
import 'widgets/quick_links.dart';
import 'widgets/service_highlights.dart';
import 'widgets/social_newsletter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ResponsiveSizeAdapter r;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _navigatorWidgetKey = GlobalKey();
  final GlobalKey _headerWidgetKey = GlobalKey();
  bool _toggleFixedNavigator = false;
  bool _toggleFixedHeader = false;
  double _fixedNavigatorOpacity = 1;
  late final AppDatabase database;

  bool _toggleToTopPage = false;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      locator<GlobalContexts>().setHomeContext(context);
      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    final RenderBox? navigartorTargetBox =
        _navigatorWidgetKey.currentContext?.findRenderObject() as RenderBox?;

    final RenderBox? headerTargetBox =
        _headerWidgetKey.currentContext?.findRenderObject() as RenderBox?;

    if (navigartorTargetBox != null) {
      final targetPosition = navigartorTargetBox.localToGlobal(Offset.zero);

      if (targetPosition.dy + navigartorTargetBox.size.height < 0) {
        setState(() {
          _toggleFixedNavigator = true;
        });
      } else {
        setState(() {
          _toggleFixedNavigator = false;
        });
      }
    }

    if (headerTargetBox != null) {
      final targetPosition = headerTargetBox.localToGlobal(Offset.zero);

      if (targetPosition.dy + headerTargetBox.size.height < 0) {
        setState(() {
          _toggleFixedHeader = true;
        });
      } else {
        setState(() {
          _toggleFixedHeader = false;
        });
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;

    if (_scrollController.position.pixels <= screenHeight / 2) {
      if (!_toggleToTopPage) {
        setState(() {
          _toggleToTopPage = true;
        });
      }
    } else {
      if (_toggleToTopPage) {
        setState(() {
          _toggleToTopPage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, themeState) {
      return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
        if (translationState.language != null) {
          return Scaffold(
            backgroundColor: themeState.theme.primaryBackgroundColor,
            body: _buildHome(
                context, themeState.theme, translationState.language!),
          );
        }
        return const SizedBox();
      });
    });
  }

  Widget _buildHome(
      BuildContext context, BaseTheme theme, LanguageModel language) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomField(isRtl: language.isRtl, children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: CustomField(
                  minHeight: screenSize.height,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  isRtl: language.isRtl,
                  children: [
                    CustomField(
                      isRtl: language.isRtl,
                      children: [
                        if (showHeaderTape) const HeaderTapeWidget(),
                        HeaderWidget(
                          key: _headerWidgetKey,
                        ),
                        NavigatorWidget(
                          key: _navigatorWidgetKey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: r.size(4), bottom: r.size(30)),
                          child: Beamer(
                            routerDelegate: HomeRoutes.homeBeamerDelegate,
                            backButtonDispatcher: BeamerBackButtonDispatcher(
                                delegate: HomeRoutes.homeBeamerDelegate),
                          ),
                        ),
                      ],
                    ),
                    CustomField(isRtl: language.isRtl, children: const [
                      ServiceHighlightsWidget(),
                      SocialNewsletterWidget(),
                      QuickLinksWidget(),
                      FooterWidget(),
                    ])
                  ]),
            ),
          ),
        ]),
        ResponsiveScreenAdapter(
          fallbackScreen: _toggleFixedNavigator == true
              ? AnimatedOpacity(
                  duration: 300.ms,
                  opacity: _fixedNavigatorOpacity,
                  child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _fixedNavigatorOpacity = 1;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _fixedNavigatorOpacity = 1;
                        });
                      },
                      child: CustomField(
                        isRtl: language.isRtl,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          HeaderWidget(),
                          NavigatorWidget(),
                        ],
                      )),
                ).animate(target: _toggleFixedNavigator ? 1 : 0).slideY(
                    duration: 400.ms,
                    curve: Curves.easeInOut,
                    begin: -1,
                    end: 0,
                  )
              : const SizedBox(),
          screenTablet: _toggleFixedHeader == true
              ? CustomField(
                  mainAxisSize: MainAxisSize.min,
                  shadowColor: theme.shadowColor,
                  shadowOffset: Offset(r.size(2), r.size(2)),
                  shadowBlurRadius: 8,
                  isRtl: language.isRtl,
                  children: const [
                    HeaderWidget(),
                  ],
                ).animate(target: _toggleFixedHeader ? 1 : 0).slideY(
                    duration: 400.ms,
                    curve: Curves.easeInOut,
                    begin: -1,
                    end: 0,
                  )
              : const SizedBox(),
          screenMobile: _toggleFixedHeader == true
              ? CustomField(
                  mainAxisSize: MainAxisSize.min,
                  shadowColor: theme.shadowColor,
                  shadowOffset: Offset(r.size(2), r.size(2)),
                  shadowBlurRadius: 8,
                  isRtl: language.isRtl,
                  children: const [
                    HeaderWidget(),
                  ],
                ).animate(target: _toggleFixedHeader ? 1 : 0).slideY(
                    duration: 400.ms,
                    curve: Curves.easeInOut,
                    begin: -1,
                    end: 0,
                  )
              : const SizedBox(),
        ),
        Positioned(
          bottom: r.size(10),
          right: !language.isRtl ? r.size(10) : null,
          left: language.isRtl ? r.size(10) : null,
          child: CustomButton(
            svgIconPath: AppPaths.vectors.arrowTopIcon,
            width: r.size(32),
            height: r.size(32),
            borderRadius: BorderRadius.all(Radius.circular(r.size(2))),
            padding: r.all(12),
            backgroundColor: AppColors.colors.grayEwa2.withOpacity(0.2),
            iconColor: AppColors.colors.whiteSolid,
            onHoverStyle: CustomButtonStyle(
              backgroundColor: AppColors.colors.greenSwagger.withOpacity(0.6),
            ),
            onPressed: (position, size) {
              _scrollController.position.animateTo(
                0,
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeIn,
              );
            },
          ),
        ).animate(target: _toggleToTopPage ? 1 : 0).fade(
              duration: 400.ms,
              curve: Curves.easeInOut,
              begin: 1,
              end: 0,
            ),
        Positioned(
          bottom: r.size(10),
          right: !language.isRtl ? r.size(10) : null,
          left: language.isRtl ? r.size(10) : null,
          child: const LiteNotificationsWidget(),
        )
      ],
    );
  }
}
