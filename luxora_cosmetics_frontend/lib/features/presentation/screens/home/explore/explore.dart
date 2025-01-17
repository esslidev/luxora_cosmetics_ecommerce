import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/util/remote_events_util.dart';
import 'package:librairie_alfia/features/data/models/author.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/widgets.dart';
import '../../../../../core/resources/bread_crumb_model.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../../domain/entities/product.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';

import '../../../bloc/remote/product/product_bloc.dart';
import '../../../bloc/remote/product/product_state.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/features/product_slider.dart';
import '../../../widgets/features/showcase.dart';
import 'widgets/author_of_month.dart';
import 'widgets/recent_blogs.dart';
import 'widgets/to_top_page.dart';
import 'widgets/top_products.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;
  bool isTripletMode = true;

  final int _booksReferencesCategoryNumber = 100;
  final int _bestSellersLiteratureCategoryNumber = 100;
  final int _bestSellersEssaysCategoryNumber = 100;
  final int _bestSellersHealthCategoryNumber = 100;

  List<ProductEntity>? _productsNewArrivals;
  List<ProductEntity>? _productsBooksReferences;
  List<ProductEntity>? _productsBestSellersLiterature;
  List<ProductEntity>? _productsBestSellersEssays;
  List<ProductEntity>? _productsBestSellersHealth;
  List<ProductEntity>? _productsTopSellers;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = locator<GlobalContexts>().homeContext;
      AppEventsUtil.breadCrumbs.clearBreadCrumbs(
        context,
      );
      AppEventsUtil.routeEvents
          .changePath(context, AppPaths.routes.exploreScreen);
      RemoteEventsUtil.productEvents.getNewArrivals(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
            if (translationState.translationService != null &&
                translationState.language != null) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<RemoteProductBloc, RemoteProductState>(
                    listener: (context, state) {
                      if (state is RemoteProductsLoaded) {
                        // Load new arrivals
                        if (state.productsNewArrivals != null) {
                          setState(() {
                            _productsNewArrivals = state.productsNewArrivals;
                            RemoteEventsUtil.productEvents.getBooksReferences(
                                context,
                                categoryNumber: _booksReferencesCategoryNumber);
                          });
                        }
                        // Load book references
                        else if (state.productsBooksReferences != null) {
                          print('worked!!');
                          setState(() {
                            _productsBooksReferences =
                                state.productsBooksReferences;
                            RemoteEventsUtil.productEvents
                                .getBestSellersLiterature(
                                    context,
                                    categoryNumber:
                                        _bestSellersLiteratureCategoryNumber);
                          });
                        }
                        // Load best sellers in literature
                        else if (state.productsBestSellersLiterature != null) {
                          setState(() {
                            _productsBestSellersLiterature =
                                state.productsBestSellersLiterature;
                            RemoteEventsUtil.productEvents.getBestSellersEssays(
                                context,
                                categoryNumber:
                                    _bestSellersEssaysCategoryNumber);
                          });
                        }
                        // Load best sellers in essays
                        else if (state.productsBestSellersEssays != null) {
                          setState(() {
                            _productsBestSellersEssays =
                                state.productsBestSellersEssays;
                            RemoteEventsUtil.productEvents.getBestSellersHealth(
                                context,
                                categoryNumber:
                                    _bestSellersHealthCategoryNumber);
                          });
                        }
                        // Load best sellers in health
                        else if (state.productsBestSellersHealth != null) {
                          setState(() {
                            _productsBestSellersHealth =
                                state.productsBestSellersHealth;
                            RemoteEventsUtil.productEvents
                                .getTopSellers(context);
                          });
                        }
                        // Load top sellers
                        else if (state.productsTopSellers != null) {
                          setState(() {
                            _productsTopSellers = state.productsTopSellers;
                          });
                        }
                      }
                      if (state is RemoteProductError) {}
                    },
                  ),
                ],
                child: ResponsiveScreenAdapter(
                  fallbackScreen: _buildLargeDesktop(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!),
                  screenLargeDesktop: _buildLargeDesktop(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!),
                  screenDesktop: _buildDesktopTabletMobile(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!),
                  screenTablet: _buildDesktopTabletMobile(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!,
                      hideController: true,
                      productCount: 3),
                  screenMobile: _buildDesktopTabletMobile(
                      context,
                      themeState.theme,
                      translationState.translationService!,
                      translationState.language!,
                      hideController: true,
                      productCount: 1),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildLargeDesktop(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(gap: r.size(24), isRtl: language.isRtl, children: [
      ShowcaseWidget(isTripletMode: isTripletMode, networks: [
        AppPaths.images.coverExample,
        AppPaths.images.cover2Example,
        AppPaths.images.cover3Example,
        AppPaths.images.cover2Example,
      ]),
      CustomField(
        padding: r.symmetric(horizontal: 60),
        gap: r.size(30),
        children: [
          ProductSliderWidget(
            books: _productsNewArrivals ?? [],
            reverse: language.isRtl,
            title:
                ts.translate('screens.explore.productSliderNames.newArrivals'),
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?orderByCreateDate=true');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Nouveautés',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?orderByCreateDate=true'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
          ProductSliderWidget(
            books: _productsBooksReferences ?? [],
            reverse: language.isRtl,
            title: ts.translate(
                'screens.explore.productSliderNames.booksReferences'),
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_booksReferencesCategoryNumber');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Livre/Références',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_booksReferencesCategoryNumber'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
        ],
      ),
      IntrinsicHeight(
        child: CustomField(
            gap: r.size(20),
            arrangement: FieldArrangement.row,
            padding: EdgeInsets.symmetric(horizontal: r.size(60)),
            isRtl: language.isRtl,
            children: [
              Expanded(
                child: CustomField(gap: r.size(14), children: [
                  ProductSliderWidget(
                    books: _productsBestSellersLiterature ?? [],
                    productCount: 4,
                    height: r.size(280),
                    hideController: true,
                    reverse: language.isRtl,
                    title: ts.translate(
                        'screens.explore.productSliderNames.BestsellersLiterature'),
                    onPressed: (productId, productName) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: productName,
                              path:
                                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
                    },
                    onSeeAllPressed: () {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersLiteratureCategoryNumber&orderBySales=true');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: 'Meilleures ventes littérature',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersLiteratureCategoryNumber&orderBySales=true'));
                    },
                    onAuthorPressed: (author) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name:
                                  'Auteur: ${author.firstName} ${author.lastName}',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
                    },
                  ),
                  ProductSliderWidget(
                    books: _productsBestSellersEssays ?? [],
                    productCount: 4,
                    height: r.size(280),
                    hideController: true,
                    reverse: language.isRtl,
                    title: ts.translate(
                        'screens.explore.productSliderNames.BestsellersEssays'),
                    onPressed: (productId, productName) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: productName,
                              path:
                                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
                    },
                    onSeeAllPressed: () {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersEssaysCategoryNumber&orderBySales=true');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: 'Meilleures ventes essais',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersEssaysCategoryNumber&orderBySales=true'));
                    },
                    onAuthorPressed: (author) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name:
                                  'Auteur: ${author.firstName} ${author.lastName}',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
                    },
                  ),
                  ProductSliderWidget(
                    books: _productsBestSellersHealth ?? [],
                    productCount: 4,
                    height: r.size(280),
                    hideController: true,
                    reverse: language.isRtl,
                    title: ts.translate(
                        'screens.explore.productSliderNames.BestsellersHealth'),
                    onPressed: (productId, productName) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: productName,
                              path:
                                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
                    },
                    onSeeAllPressed: () {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersHealthCategoryNumber&orderBySales=true');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name: 'Meilleures ventes santé',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersHealthCategoryNumber&orderBySales=true'));
                    },
                    onAuthorPressed: (author) {
                      Beamer.of(context).beamToNamed(
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
                      AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                          breadCrumb: BreadCrumbModel(
                              name:
                                  'Auteur: ${author.firstName} ${author.lastName}',
                              path:
                                  '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
                    },
                  ),
                ]),
              ),
              TopProductsWidget(
                topBooks: _productsTopSellers ?? [],
                onPressed: (productId, productName) {
                  Beamer.of(context).beamToNamed(
                      '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
                  AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                      breadCrumb: BreadCrumbModel(
                          name: productName,
                          path:
                              '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
                },
                onSeeAllPressed: () {
                  Beamer.of(context).beamToNamed(
                      '${AppPaths.routes.boutiqueScreen}?isTop100=true');
                  AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                      breadCrumb: BreadCrumbModel(
                          name: 'TOP 100 des ventes',
                          path:
                              '${AppPaths.routes.boutiqueScreen}?isTop100=true'));
                },
                onAuthorPressed: (author) {
                  Beamer.of(context).beamToNamed(
                      '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
                  AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                      breadCrumb: BreadCrumbModel(
                          name:
                              'Auteur: ${author.firstName} ${author.lastName}',
                          path:
                              '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
                },
              ),
            ]),
      ),
      const AuthorOfMonthWidget(),
      const RecentBlogsWidget(),
      const ToTopPageWidget()
    ]);
  }

  ProductSliderWidget _buildProductSliderDesktop({
    required String title,
    required List<ProductEntity> books,
    required int productCount,
    required bool hideController,
    required bool isRtl, // action callbacks
    Function()? onSeeAllPressed,
    Function(int productId, String productName)? onPressed,
    Function(int productId)? onPurchasePressed,
    Function(AuthorModel author)? onAuthorPressed,
  }) {
    return ProductSliderWidget(
      books: books,
      productCount: productCount,
      height: r.size(260),
      hideController: hideController,
      reverse: isRtl,
      authorFontSize: r.size(10),
      titleFontSize: r.size(10),
      priceFontSize: r.size(12),
      title: title,
      onSeeAllPressed: onSeeAllPressed,
      onPressed: onPressed,
      onPurchasePressed: onPurchasePressed,
      onAuthorPressed: onAuthorPressed,
    );
  }

  Widget _buildDesktopTabletMobile(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language, {
    int productCount = 4,
    bool hideController = false,
  }) {
    return CustomField(gap: r.size(30), isRtl: language.isRtl, children: [
      ShowcaseWidget(isTripletMode: isTripletMode, networks: [
        AppPaths.images.coverExample,
        AppPaths.images.cover2Example,
        AppPaths.images.cover3Example
      ]),
      CustomField(
        padding: r.symmetric(horizontal: 20),
        gap: r.size(30),
        children: [
          _buildProductSliderDesktop(
            title:
                ts.translate('screens.explore.productSliderNames.newArrivals'),
            books: _productsNewArrivals ?? [],
            productCount: productCount,
            hideController: hideController,
            isRtl: language.isRtl,
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?orderByCreateDate=true');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Nouveautés',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?orderByCreateDate=true'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?search=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
          _buildProductSliderDesktop(
            title: ts.translate(
                'screens.explore.productSliderNames.booksReferences'),
            books: _productsBooksReferences ?? [],
            productCount: productCount,
            hideController: hideController,
            isRtl: language.isRtl,
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_booksReferencesCategoryNumber');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Livre/Références',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_booksReferencesCategoryNumber'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?search=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
          _buildProductSliderDesktop(
            title: ts.translate(
                'screens.explore.productSliderNames.BestsellersLiterature'),
            books: _productsBestSellersLiterature ?? [],
            productCount: productCount,
            hideController: hideController,
            isRtl: language.isRtl,
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersLiteratureCategoryNumber&orderBySales=true');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Meilleures ventes littérature',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersLiteratureCategoryNumber&orderBySales=true'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?search=${author.firstName} ${author.lastName}');

              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
          _buildProductSliderDesktop(
            title: ts.translate(
                'screens.explore.productSliderNames.BestsellersEssays'),
            books: _productsBestSellersEssays ?? [],
            productCount: productCount,
            hideController: hideController,
            isRtl: language.isRtl,
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersEssaysCategoryNumber&orderBySales=true');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Meilleures ventes essais',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersEssaysCategoryNumber&orderBySales=true'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?search=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
          _buildProductSliderDesktop(
            title: ts.translate(
                'screens.explore.productSliderNames.BestsellersHealth'),
            books: _productsBestSellersHealth ?? [],
            productCount: productCount,
            hideController: hideController,
            isRtl: language.isRtl,
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersHealthCategoryNumber&orderBySales=true');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Meilleures ventes santé',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?categoryPath=$_bestSellersHealthCategoryNumber&orderBySales=true'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?search=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
          TopProductsWidget(
            topBooks: _productsTopSellers ?? [],
            isHorizontal: true,
            onPressed: (productId, productName) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: productName,
                      path:
                          '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
            },
            onSeeAllPressed: () {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?isTop100=true');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'TOP 100 des ventes',
                      path: '${AppPaths.routes.boutiqueScreen}?isTop100=true'));
            },
            onAuthorPressed: (author) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?search=${author.firstName} ${author.lastName}');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Auteur: ${author.firstName} ${author.lastName}',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
            },
          ),
        ],
      ),
      const AuthorOfMonthWidget(),
      const RecentBlogsWidget(),
      const ToTopPageWidget()
    ]);
  }
}
