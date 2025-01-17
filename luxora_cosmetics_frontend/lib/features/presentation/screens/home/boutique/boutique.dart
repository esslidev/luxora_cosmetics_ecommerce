import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/core/util/remote_events_util.dart';
import 'package:librairie_alfia/features/domain/entities/author.dart';
import 'package:librairie_alfia/features/domain/entities/category.dart';
import 'package:librairie_alfia/features/domain/entities/pagination.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_line.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_text.dart';
import 'package:librairie_alfia/features/presentation/widgets/features/paginator.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_paths.dart';
import '../../../../../core/enums/notification_type.dart';
import '../../../../../core/enums/product.dart';
import '../../../../../core/resources/bread_crumb_model.dart';
import '../../../../../core/resources/global_contexts.dart';
import '../../../../../core/resources/language_model.dart';
import '../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../core/util/app_events_util.dart';
import '../../../../../core/util/app_util.dart';
import '../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../core/util/translation_service.dart';
import '../../../../../locator.dart';
import '../../../../data/models/category_translation.dart';
import '../../../../data/models/wishlist_item.dart';
import '../../../../domain/entities/cart.dart';
import '../../../../domain/entities/filtering_data.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/wishlist.dart';
import '../../../bloc/app/language/translation_bloc.dart';
import '../../../bloc/app/language/translation_state.dart';
import '../../../bloc/app/theme/theme_bloc.dart';
import '../../../bloc/app/theme/theme_state.dart';

import '../../../bloc/remote/author/author_bloc.dart';
import '../../../bloc/remote/author/author_state.dart';
import '../../../bloc/remote/cart/cart_bloc.dart';
import '../../../bloc/remote/cart/cart_state.dart';
import '../../../bloc/remote/category/category_bloc.dart';
import '../../../bloc/remote/category/category_state.dart';
import '../../../bloc/remote/product/product_bloc.dart';
import '../../../bloc/remote/product/product_state.dart';
import '../../../bloc/remote/wishlist/wishlist_bloc.dart';
import '../../../bloc/remote/wishlist/wishlist_state.dart';
import '../../../overlays/dropdown/dropdown.dart';
import '../../../overlays/loading/loading.dart';
import '../../../widgets/common/custom_display.dart';
import '../../../widgets/common/custom_field.dart';
import '../../../widgets/common/custom_shrinking_line.dart';
import '../../../widgets/features/bread_crumbs.dart';
import '../../../widgets/features/product.dart';
import '../widgets/header/widgets/searchbar/widgets/search_bar_advanced_dropdown.dart';
import 'widgets/boutique_sidebar.dart';
import 'widgets/sort_by_dropdown.dart';

enum BoutiqueSortCriteria {
  none,
  titleAsc, // Sort by title, ascending
  titleDesc, // Sort by title, descending
  authorAsc, // Sort by author, ascending
  authorDesc, // Sort by author, descending
  stock, // Sort by stock availability
  sortByPriceLowToHigh, // Sort by price, lowest first
  sortByPriceHighToLow, // Sort by price, highest first
  publicationDateAsc, // Sort by author, ascending
  publicationDateDesc, // Sort by author, descending
}

extension BoutiqueSortCriteriaExtension on BoutiqueSortCriteria {
  String get text {
    switch (this) {
      case BoutiqueSortCriteria.none:
        return "Défaut";
      case BoutiqueSortCriteria.titleAsc:
        return "Titre de A à Z";
      case BoutiqueSortCriteria.titleDesc:
        return "Titre de Z à A";
      case BoutiqueSortCriteria.authorAsc:
        return "Auteur de A à Z";
      case BoutiqueSortCriteria.authorDesc:
        return "Auteur de Z à A";
      case BoutiqueSortCriteria.stock:
        return "Disponibilité";
      case BoutiqueSortCriteria.sortByPriceHighToLow:
        return "Prix (Decroissant)";
      case BoutiqueSortCriteria.sortByPriceLowToHigh:
        return "Prix (Croissant)";
      case BoutiqueSortCriteria.publicationDateAsc:
        return "Date de parution (Croissant)";
      case BoutiqueSortCriteria.publicationDateDesc:
        return "Date de parution (Décroissant)";
    }
  }
}

enum BoutiqueFilterOption {
  none, // no Filter is picked
  newArrivals, // Filter by new arrivals
  bestSellers, // Filter by best sellers
  preorders, // Filter by pre-orders
  favourites, // Filter by favorites
}

class BoutiqueScreen extends StatefulWidget {
  final int? mainCategoryNumber;
  final bool? isTop100;
  final String? searchValue;
  final AdvancedSearchValues? advancedSearchValues;
  final String? isbn;
  final String? authorName;
  final String? title;
  final String? editor;
  final String? categoryName;
  final String? publicationDate;
  final bool? orderByCreateDate;
  final bool? orderBySales;
  const BoutiqueScreen(
      {super.key,
      this.mainCategoryNumber,
      this.isTop100,
      this.searchValue,
      this.advancedSearchValues,
      this.isbn,
      this.authorName,
      this.title,
      this.editor,
      this.categoryName,
      this.publicationDate,
      this.orderByCreateDate,
      this.orderBySales});

  @override
  State<BoutiqueScreen> createState() => _BoutiqueScreenState();
}

class _BoutiqueScreenState extends State<BoutiqueScreen> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  late LoadingOverlay _loadingOverlay;
  late DropdownOverlay _boutiqueSidebarDropdown;

  // for linking sortByDropdown to its button...
  final LayerLink _bodySortByDropdownLayerLink = LayerLink();
  final LayerLink _footerSortByDropdownLayerLink = LayerLink();

  // Api responses...
  List<ProductEntity> _productsResponse = [];
  PaginationEntity _paginationResponse = const PaginationEntity(
    limit: 24,
    total: 0,
    page: 1,
    pages: 1,
  );
  FilteringDataEntity _filteringDataResponse = const FilteringDataEntity(
    inStockCount: 0,
    preorderCount: 0,
  );
  CategoryEntity? _mainCategoryResponse;
  List<AuthorEntity> _featuredAuthorsResponse = [];
  CartEntity? _cartResponse;
  WishlistEntity? _wishlistResponse;

  // needed saved values in ram...
  BoutiqueSortCriteria _boutiqueSortCriteriaValue = BoutiqueSortCriteria.none;
  BoutiqueFilterOption _boutiqueFilterOptionValue = BoutiqueFilterOption.none;

  BoutiqueFilterByAvailability _boutiqueFilterByAvailabilityValue =
      BoutiqueFilterByAvailability.allStock;
  BoutiqueFilterByPublicationDate _boutiqueFilterByPublicationDateValue =
      BoutiqueFilterByPublicationDate.allTime;
  BoutiqueFilterByFormat _boutiqueFilterByFormatValue =
      BoutiqueFilterByFormat.allFormats;
  BoutiqueFilterByPriceRange _boutiqueFilterByPriceRangeValue =
      BoutiqueFilterByPriceRange();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = locator<GlobalContexts>().homeContext;

      _loadingOverlay = LoadingOverlay(
        context: homeContext!,
      );
      _boutiqueSidebarDropdown = _buildBoutiqueSidebarDropdown();

      //jump page to top
      AppUtil.jumpToTop(context);

      //product event util
      _getProductsEvent();

      //boutique main category event util
      if (widget.mainCategoryNumber != null) {
        RemoteEventsUtil.categoryEvents.getBoutiqueMainCategory(context,
            categoryNumber: widget.mainCategoryNumber!);
      }

      RemoteEventsUtil.authorEvents.getBoutiqueFeaturedAuthors(context);

      //wishlist and cart
      RemoteEventsUtil.wishlistEvents.getWishlist(context);
      RemoteEventsUtil.cartEvents.getCart(context);
    });
  }

  String getProductIds(List<WishlistItemModel> wishlistItems) {
    return wishlistItems.map((item) => item.productId.toString()).join('_');
  }

  void _getProductsEvent({int? page}) {
    // Get the current date and time for publication date filtrations
    DateTime now = DateTime.now();
    DateTime sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    DateTime threeMonthsLater = DateTime(now.year, now.month + 3, now.day);

    RemoteEventsUtil.productEvents.getProducts(
      context,
      limit: 24,
      page: page ?? _paginationResponse.page,
      search: widget.searchValue,
      isbn: widget.isbn,
      title: widget.title ?? widget.advancedSearchValues?.title,
      authorName: widget.authorName ?? widget.advancedSearchValues?.authorName,
      categoryNumber: widget.mainCategoryNumber,
      categoryName:
          widget.categoryName ?? widget.advancedSearchValues?.categoryName,
      publicationDate: widget.publicationDate ??
          widget.advancedSearchValues?.publicationDate,
      formatType:
          _boutiqueFilterByFormatValue == BoutiqueFilterByFormat.paperback
              ? ProductFormatType.paperback
              : _boutiqueFilterByFormatValue == BoutiqueFilterByFormat.grand
                  ? ProductFormatType.grand
                  : null,
      priceRange:
          '${_boutiqueFilterByPriceRangeValue.lowestPrice ?? ''}_${_boutiqueFilterByPriceRangeValue.highestPrice ?? ''}',
      isPublished: _boutiqueFilterByPublicationDateValue ==
              BoutiqueFilterByPublicationDate.published
          ? true
          : null,
      publishedIn: _boutiqueFilterByPublicationDateValue ==
              BoutiqueFilterByPublicationDate.past6Months
          ? sixMonthsAgo.toString()
          : null,
      publishedWithin: _boutiqueFilterByPublicationDateValue ==
              BoutiqueFilterByPublicationDate.within3Months
          ? threeMonthsLater.toString()
          : null,
      isNewArrivals:
          _boutiqueFilterOptionValue == BoutiqueFilterOption.newArrivals,
      isBestSellers:
          _boutiqueFilterOptionValue == BoutiqueFilterOption.bestSellers,
      isPreorder: _boutiqueFilterOptionValue == BoutiqueFilterOption.preorders,
      isInStock: _boutiqueFilterByAvailabilityValue ==
          BoutiqueFilterByAvailability.inStock,
      productIds: _boutiqueFilterOptionValue == BoutiqueFilterOption.favourites
          ? getProductIds((_wishlistResponse!.items!))
          : null,
      orderBySales: widget.isTop100 == true ? true : null,
      orderByTitle:
          _boutiqueSortCriteriaValue == BoutiqueSortCriteria.titleAsc ||
                  _boutiqueSortCriteriaValue == BoutiqueSortCriteria.titleDesc
              ? true
              : null,
      orderByAuthor:
          _boutiqueSortCriteriaValue == BoutiqueSortCriteria.authorAsc ||
                  _boutiqueSortCriteriaValue == BoutiqueSortCriteria.authorDesc
              ? true
              : null,
      orderByStock: _boutiqueSortCriteriaValue == BoutiqueSortCriteria.stock
          ? true
          : null,
      orderByPrice: _boutiqueSortCriteriaValue ==
                  BoutiqueSortCriteria.sortByPriceLowToHigh ||
              _boutiqueSortCriteriaValue ==
                  BoutiqueSortCriteria.sortByPriceHighToLow
          ? true
          : null,
      orderByPublicationDate: _boutiqueSortCriteriaValue ==
                  BoutiqueSortCriteria.publicationDateAsc ||
              _boutiqueSortCriteriaValue ==
                  BoutiqueSortCriteria.publicationDateDesc
          ? true
          : null,
      sortOrder: _boutiqueSortCriteriaValue == BoutiqueSortCriteria.titleDesc ||
              _boutiqueSortCriteriaValue == BoutiqueSortCriteria.authorDesc ||
              _boutiqueSortCriteriaValue == BoutiqueSortCriteria.stock ||
              _boutiqueSortCriteriaValue ==
                  BoutiqueSortCriteria.sortByPriceHighToLow ||
              _boutiqueSortCriteriaValue ==
                  BoutiqueSortCriteria.publicationDateDesc ||
              widget.isTop100 == true
          ? SortOrder.desc
          : SortOrder.asc,
    );
  }

  CategoryTranslationModel? getCategoryTranslation({
    required List<CategoryTranslationModel>? translations,
    String? languageCode = 'fr',
  }) {
    if (translations == null || translations.isEmpty) return null;

    // Use firstWhereOrNull to simplify null handling
    final languageSpecificTranslation = translations.firstWhereOrNull(
      (translation) => translation.languageCode == languageCode,
    );

    final defaultTranslation = translations.firstWhereOrNull(
      (translation) => translation.isDefault == true,
    );

    // Return the language-specific translation if available; otherwise, default translation
    return defaultTranslation ?? languageSpecificTranslation;
  }
  //------------------------------------------------------------------------------------------------//

  DropdownOverlay _buildBoutiqueSidebarDropdown() {
    return DropdownOverlay(
      context: homeContext!,
      borderRadius: Radius.circular(r.size(2)),
      borderWidth: r.size(1),
      margin: EdgeInsets.only(top: r.size(2)),
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
    );
  }

//------------------------------------------------------------------------------------------------//

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
                      if (state is RemoteProductsLoading) {
                        if (state.boutiqueProductsLoading == true) {
                          _loadingOverlay.show(
                              translationService:
                                  translationState.translationService!,
                              r: r,
                              theme: themeState.theme);
                        }
                      }
                      if (state is RemoteProductsLoaded) {
                        // Load new arrivals
                        if (state.boutiqueProducts != null &&
                            state.pagination != null) {
                          setState(() {
                            _productsResponse = state.boutiqueProducts!;
                            _filteringDataResponse = state.filteringData!;
                            _paginationResponse = state.pagination!;
                          });
                          _loadingOverlay.dismiss();
                        }
                      }
                      if (state is RemoteProductError) {
                        _loadingOverlay.dismiss();
                      }
                    },
                  ),
                  BlocListener<RemoteCategoryBloc, RemoteCategoryState>(
                    listener: (context, state) {
                      if (state is RemoteCategoryLoaded) {
                        if (state.boutiqueCategory != null) {
                          setState(() {
                            _mainCategoryResponse = state.boutiqueCategory!;
                          });
                        }
                      }
                      if (state is RemoteCategoriesLoaded) {
                        if (state.categories != null) {
                          setState(() {
                            // _categoryPathResponse = state.categories!;
                          });
                        }
                      }
                      if (state is RemoteCategoryError) {
                        _loadingOverlay.dismiss();
                      }
                    },
                  ),
                  BlocListener<RemoteAuthorBloc, RemoteAuthorState>(
                    listener: (context, state) {
                      if (state is RemoteAuthorsLoaded) {
                        if (state.boutiqueFeaturedAuthors != null) {
                          print('authors:: ${state.boutiqueFeaturedAuthors}');
                          setState(() {
                            _featuredAuthorsResponse =
                                state.boutiqueFeaturedAuthors!;
                          });
                        }
                      }

                      if (state is RemoteAuthorError) {
                        AppEventsUtil.liteNotifications
                            .addLiteNotification(context,
                                notification: LiteNotificationModel(
                                  notificationTitle:
                                      state.error?.response?.data["error"],
                                  notificationMessage:
                                      state.error?.response?.data["message"],
                                  notificationType: NotificationType.error,
                                ));
                      }
                    },
                  ),
                  BlocListener<RemoteWishlistBloc, RemoteWishlistState>(
                    listener: (context, state) {
                      if (state is RemoteWishlistSynced) {
                        setState(() {
                          _wishlistResponse = state.wishlist;
                        });
                      }

                      if (state is RemoteWishlistLoaded) {
                        setState(() {
                          _wishlistResponse = state.wishlist;
                        });
                      }

                      if (state is RemoteWishlistItemAdded) {
                        setState(() {
                          final existingIndex =
                              _wishlistResponse?.items?.indexWhere(
                            (element) =>
                                element.productId == state.item!.productId,
                          );

                          if (existingIndex != null && existingIndex >= 0) {
                            _wishlistResponse?.items?[existingIndex] =
                                state.item!;
                          } else {
                            _wishlistResponse?.items?.add(state.item!);
                          }
                        });
                      }

                      if (state is RemoteWishlistItemUpdated) {
                        setState(() {
                          final index = _wishlistResponse?.items?.indexWhere(
                            (element) => element.id == state.item!.id,
                          );
                          if (index != null && index >= 0) {
                            _wishlistResponse?.items?[index] = state.item!;
                          }
                        });
                      }

                      if (state is RemoteWishlistItemRemoved) {
                        setState(() {
                          _wishlistResponse?.items?.removeWhere(
                            (element) => element.id == state.item?.id,
                          );
                        });
                      }

                      if (state is RemoteWishlistCleared) {
                        setState(() {
                          _wishlistResponse?.items?.clear();
                        });
                      }

                      if (state is RemoteWishlistError) {
                        setState(() {
                          _wishlistResponse = null;
                        });
                      }
                    },
                  ),
                  BlocListener<RemoteCartBloc, RemoteCartState>(
                    listener: (context, state) {
                      if (state is RemoteCartSynced) {
                        setState(() {
                          _cartResponse = state.cart;
                        });
                      }

                      if (state is RemoteCartLoaded) {
                        if (state.cart != null) {
                          setState(() {
                            _cartResponse = state.cart;
                          });
                        }
                      }

                      if (state is RemoteCartItemAdded) {
                        setState(() {
                          final existingIndex =
                              _cartResponse?.items?.indexWhere(
                            (element) =>
                                element.productId == state.item!.productId,
                          );

                          if (existingIndex != null && existingIndex >= 0) {
                            _cartResponse?.items?[existingIndex] = state.item!;
                          } else {
                            _cartResponse?.items?.add(state.item!);
                          }
                        });
                      }

                      if (state is RemoteCartItemUpdated) {
                        setState(() {
                          final index = _cartResponse?.items?.indexWhere(
                            (element) => element.id == state.item!.id,
                          );
                          if (index != null && index >= 0) {
                            _cartResponse?.items?[index] = state.item!;
                          }
                        });
                      }

                      if (state is RemoteCartItemRemoved) {
                        setState(() {
                          _cartResponse?.items?.removeWhere(
                            (element) => element.id == state.item?.id,
                          );
                        });
                      }

                      if (state is RemoteCartCleared) {
                        setState(() {
                          _cartResponse?.items?.clear();
                        });
                      }

                      if (state is RemoteCartError) {
                        setState(() {
                          _cartResponse = null;
                        });
                      }
                    },
                  ),
                ],
                child: ResponsiveScreenAdapter(
                  fallbackScreen: _buildLargeDesktop(
                    context,
                    themeState.theme,
                    translationState.translationService!,
                    translationState.language!,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildTitle(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      bool isTop100 = false}) {
    CategoryTranslationModel? mainCategoryTranslation = getCategoryTranslation(
        translations: _mainCategoryResponse?.translations);

    String title = mainCategoryTranslation?.name ??
        (widget.isTop100 == true
            ? 'Top 100 des ventes'
            : widget.searchValue != null
                ? '${widget.searchValue}'
                : widget.advancedSearchValues != null
                    ? '${widget.advancedSearchValues!.title != null ? 'Titre: ${widget.advancedSearchValues!.title}' : ''}'
                        '${widget.advancedSearchValues!.authorName != null && widget.advancedSearchValues!.title != null ? ', ' : ''}'
                        '${widget.advancedSearchValues!.authorName != null ? 'Auteur: ${widget.advancedSearchValues!.authorName}' : ''}'
                        '${widget.advancedSearchValues!.editor != null && (widget.advancedSearchValues!.authorName != null || widget.advancedSearchValues!.title != null) ? ', ' : ''}'
                        '${widget.advancedSearchValues!.editor != null ? 'Editeur: ${widget.advancedSearchValues!.editor}' : ''}'
                        '${widget.advancedSearchValues!.categoryName != null && (widget.advancedSearchValues!.editor != null || widget.advancedSearchValues!.authorName != null || widget.advancedSearchValues!.title != null) ? ', ' : ''}'
                        '${widget.advancedSearchValues!.categoryName != null ? 'Categorie: ${widget.advancedSearchValues!.categoryName}' : ''}'
                        '${widget.advancedSearchValues!.publicationDate != null && (widget.advancedSearchValues!.categoryName != null || widget.advancedSearchValues!.editor != null || widget.advancedSearchValues!.authorName != null || widget.advancedSearchValues!.title != null) ? ', ' : ''}'
                        '${widget.advancedSearchValues!.publicationDate != null ? 'Date de publication: ${widget.advancedSearchValues!.publicationDate}' : ''}'
                    : widget.authorName != null
                        ? 'Auteur : ${widget.authorName}'
                        : widget.categoryName != null
                            ? 'Catégorie : ${widget.categoryName}'
                            : '');

    int total =
        _paginationResponse.total != null ? _paginationResponse.total! : 0;
    return CustomField(
      maxWidth: r.size(600),
      gap: r.size(4),
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      arrangement: FieldArrangement.row,
      children: [
        Flexible(
          child: CustomText(
            text: title,
            color: !isTop100 ? theme.accent : AppColors.colors.whiteSolid,
            backgroundColor: isTop100 ? theme.primary : null,
            padding: isTop100 ? r.symmetric(vertical: 8, horizontal: 34) : null,
            fontSize: r.size(24),
            fontWeight: FontWeight.bold,
            fontFamily:
                mainCategoryTranslation?.languageCode == 'ar' ? 'cairo' : null,
            lineHeight: 1,
          ),
        ),
        CustomText(
          text: isTop100 == true ? '' : '($total articles)',
          color: theme.accent,
          fontSize: r.size(16),
          fontWeight: FontWeight.normal,
          lineHeight: 1.3,
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required String name,
    Color? highlightedColor,
    required Function() onPressed,
  }) {
    return CustomButton(
      text: name,
      fontSize: r.size(14),
      fontWeight: FontWeight.bold,
      padding: r.symmetric(vertical: 2, horizontal: 12),
      borderRadius: BorderRadius.circular(r.size(2)),
      textColor: theme.accent,
      backgroundColor: highlightedColor ?? theme.thirdBackgroundColor,
      animationDuration: 200.ms,
      onHoverStyle: CustomButtonStyle(
        textColor: theme.accent.withOpacity(0.8),
      ),
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildFilterButtons({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      gap: r.size(12),
      mainAxisSize: MainAxisSize.min,
      arrangement: FieldArrangement.row,
      children: [
        _buildFilterButton(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          name: 'Nouveautés',
          highlightedColor:
              _boutiqueFilterOptionValue == BoutiqueFilterOption.newArrivals
                  ? theme.primary.withOpacity(0.4)
                  : null,
          onPressed: () {
            setState(() {
              if (_boutiqueFilterOptionValue !=
                  BoutiqueFilterOption.newArrivals) {
                _boutiqueFilterOptionValue = BoutiqueFilterOption.newArrivals;
                _getProductsEvent();
              } else {
                _boutiqueFilterOptionValue = BoutiqueFilterOption.none;
                _getProductsEvent();
              }
            });
          },
        ),
        _buildFilterButton(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          name: 'Précommandes',
          highlightedColor:
              _boutiqueFilterOptionValue == BoutiqueFilterOption.preorders
                  ? theme.primary.withOpacity(0.4)
                  : null,
          onPressed: () {
            setState(() {
              if (_boutiqueFilterOptionValue !=
                  BoutiqueFilterOption.preorders) {
                _boutiqueFilterOptionValue = BoutiqueFilterOption.preorders;
                _getProductsEvent();
              } else {
                _boutiqueFilterOptionValue = BoutiqueFilterOption.none;
                _getProductsEvent();
              }
            });
          },
        ),
        _buildFilterButton(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          name: 'Best-sellers',
          highlightedColor:
              _boutiqueFilterOptionValue == BoutiqueFilterOption.bestSellers
                  ? AppColors.colors.yellowHoneyGlow.withOpacity(0.4)
                  : null,
          onPressed: () {
            setState(() {
              if (_boutiqueFilterOptionValue !=
                  BoutiqueFilterOption.bestSellers) {
                _boutiqueFilterOptionValue = BoutiqueFilterOption.bestSellers;
                _getProductsEvent();
              } else {
                _boutiqueFilterOptionValue = BoutiqueFilterOption.none;
                _getProductsEvent();
              }
            });
          },
        ),
        if (_wishlistResponse != null &&
            _wishlistResponse!.items != null &&
            _wishlistResponse!.items!.isNotEmpty)
          _buildFilterButton(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
            name: 'Coups de coeur',
            highlightedColor:
                _boutiqueFilterOptionValue == BoutiqueFilterOption.favourites
                    ? AppColors.colors.redRouge.withOpacity(0.4)
                    : null,
            onPressed: () {
              setState(() {
                if (_boutiqueFilterOptionValue !=
                    BoutiqueFilterOption.favourites) {
                  _boutiqueFilterOptionValue = BoutiqueFilterOption.favourites;
                  _getProductsEvent();
                } else {
                  _boutiqueFilterOptionValue = BoutiqueFilterOption.none;
                  _getProductsEvent();
                }
              });
            },
          ),
      ],
    );
  }

  Widget _buildHeader({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      width: double.infinity,
      gap: r.size(20),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTitle(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          isTop100: widget.isTop100 == true,
        ),
        if (widget.isTop100 != true)
          _buildFilterButtons(
            theme: theme,
            ts: ts,
            isRtl: isRtl,
          )
      ],
    );
  }

  Widget _buildSortByButton(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required LayerLink link}) {
    return CustomField(
      gap: r.size(4),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      arrangement: FieldArrangement.row,
      children: [
        CustomText(
          text: 'Trier par :',
          fontSize: r.size(11),
          fontWeight: FontWeight.bold,
        ),
        CompositedTransformTarget(
          link: link,
          child: CustomButton(
            width: r.size(150),
            height: r.size(16),
            backgroundColor: theme.secondaryBackgroundColor,
            text: _boutiqueSortCriteriaValue.text,
            lineHeight: 1,
            border: Border.all(
                color: theme.accent.withOpacity(0.4), width: r.size(0.6)),
            borderRadius: BorderRadius.circular(r.size(2)),
            padding: r.symmetric(vertical: 2, horizontal: 8),
            fontSize: r.size(8),
            svgIconPath: AppPaths.vectors.triangleBottomIcon,
            iconColor: theme.accent.withOpacity(0.6),
            iconWidth: r.size(3),
            iconHeight: r.size(3),
            iconTextGap: r.size(3),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            iconPosition: CustomButtonIconPosition.right,
            onPressed: (position, size) {
              _boutiqueSidebarDropdown.show(
                  layerLink: link,
                  backgroundColor: theme.overlayBackgroundColor,
                  targetWidgetSize: size,
                  width: r.size(150),
                  dropdownAlignment: DropdownAlignment.center,
                  child: SortByDropdown(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    onPressed: (BoutiqueSortCriteria sortCriteria) {
                      setState(() {
                        _boutiqueSidebarDropdown.dismiss();
                        _boutiqueSortCriteriaValue = sortCriteria;
                        _getProductsEvent();
                      });
                    },
                  ));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductStockAction({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    bool isInCart = false,
    bool isInStock = false,
    bool isPreorder = false,
    required Function() onAddCartPressed,
  }) {
    return CustomField(
        width: r.size(160),
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: r.size(4),
        children: [
          CustomText(
            text: isInStock
                ? 'En stock'
                : isPreorder
                    ? 'Précommande'
                    : 'Bientôt en stock',
            textAlign: TextAlign.center,
            fontSize: r.size(12),
            fontWeight: FontWeight.bold,
          ),
          CustomButton(
            width: r.size(120),
            text: !isInCart ? 'Ajouter au panier' : 'Retirer du panier',
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            textColor: AppColors.colors.whiteSolid,
            backgroundColor: AppColors.colors.redRouge,
            padding: r.symmetric(
              vertical: 2,
            ),
            borderRadius: BorderRadius.circular(r.size(1.5)),
            onPressed: (position, size) {
              onAddCartPressed();
            },
          )
        ]);
  }

  Widget _buildProduct({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required ProductEntity book,
  }) {
    return CustomField(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProductWidget(
          width: r.size(160),
          height: r.size(240),
          productId: book.id,
          networkImageUrl: book.imageUrl,
          author: book.author,
          title: book.title,
          price: book.price,
          pricePromo: book.pricePromo,
          pricePromoPercentage: book.primaryCategoryPromoPercent,
          isBestSellers: book.isBestSeller,
          isNewArrival: book.isNewArrival,
          isActionsCardVisible: false,
          authorFontSize: r.size(11),
          titleFontSize: r.size(11),
          priceFontSize: r.size(12),
          onPressed: (productId, productName) {
            Beamer.of(context).beamToNamed(
              '${AppPaths.routes.bookOverviewScreen}?productId=$productId',
            );
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
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
        _buildProductStockAction(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          isInCart: (_cartResponse?.items?.any(
                (item) => item.productId == book.id,
              ) ??
              false),
          isInStock: book.stockCount != null && book.stockCount! > 0,
          isPreorder: book.isPreorder == true,
          onAddCartPressed: () {
            setState(() {
              final existingInCart = (_cartResponse?.items?.any(
                    (item) => item.productId == book.id,
                  ) ??
                  false);
              if (existingInCart && book.id != null) {
                RemoteEventsUtil.cartEvents.removeItemFromCart(
                  context,
                  productId: book.id!,
                  allQuantity: true,
                );
              } else if (book.id != null) {
                RemoteEventsUtil.cartEvents.addItemToCart(
                  context,
                  productId: book.id!,
                );
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildProductsListRow({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<ProductEntity> products,
  }) {
    return CustomField(
        gap: r.size(6),
        arrangement: FieldArrangement.row,
        children: [
          ...products.map((product) {
            return _buildProduct(
                theme: theme, ts: ts, isRtl: isRtl, book: product);
          }),
        ]);
  }

  Widget _buildProductsList({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<ProductEntity> products,
    required int itemsPerRow,
  }) {
    // Group products into rows
    List<List<ProductEntity>> productRows = [];
    for (int i = 0; i < products.length; i += itemsPerRow) {
      productRows.add(products.sublist(
        i,
        i + itemsPerRow > products.length ? products.length : i + itemsPerRow,
      ));
    }

    return CustomField(
      gap: r.size(20),
      children: [
        ...productRows.map((rowProducts) {
          bool isLastRow = rowProducts == productRows.last;
          return CustomField(
            gap: r.size(20),
            children: [
              _buildProductsListRow(
                theme: theme,
                ts: ts,
                isRtl: isRtl,
                products: rowProducts,
              ),
              if (!isLastRow)
                CustomLine(
                  color: theme.accent,
                  thickness: r.size(0.2),
                  size: double.infinity,
                  isVertical: false,
                ), // Add a divider after each row
            ],
          );
        }),
      ],
    );
  }

  Widget _buildResultNotFound({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      width: double.infinity,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: r.size(8),
      padding: r.symmetric(vertical: 80),
      backgroundColor: theme.secondaryBackgroundColor.withOpacity(0.7),
      borderRadius: r.size(2),
      isRtl: isRtl,
      children: [
        CustomDisplay(
          assetPath: AppPaths.vectors.noResultFound,
          width: r.size(100),
          height: r.size(100),
          isSvg: true,
        ),
        CustomText(
          text: ts.translate(
              'screens.home.header.searchbar.resultOverlay.NoResult'),
          fontSize: r.size(14),
          fontWeight: FontWeight.bold,
          color: theme.accent.withOpacity(0.4),
        ),
      ],
    );
  }

  Widget _buildBody({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return _productsResponse.isNotEmpty
        ? CustomField(
            gap: r.size(20),
            padding: r.symmetric(vertical: 10),
            mainAxisAlignment: MainAxisAlignment.start,
            isRtl: isRtl,
            children: [
                _buildSortByButton(
                    theme: theme,
                    ts: ts,
                    isRtl: isRtl,
                    link: _bodySortByDropdownLayerLink),
                _buildProductsList(
                  theme: theme,
                  ts: ts,
                  isRtl: isRtl,
                  products: _productsResponse,
                  itemsPerRow: 4,
                ),
                _buildFooter(theme: theme, ts: ts, isRtl: isRtl)
              ])
        : _buildResultNotFound(theme: theme, ts: ts, isRtl: isRtl);
  }

  Widget _buildPaginator({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return Paginator(
        theme: theme,
        isRtl: isRtl,
        currentPage: _paginationResponse.page ?? 1,
        totalPages: _paginationResponse.pages ?? 1,
        maxVisiblePages: 7,
        onPageChanged: (index) {
          _getProductsEvent(page: index);
        },
        r: r);
  }

  Widget _buildFooter({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomField(
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSortByButton(
          theme: theme,
          ts: ts,
          isRtl: isRtl,
          link: _footerSortByDropdownLayerLink,
        ),
        _buildPaginator(theme: theme, ts: ts, isRtl: isRtl)
      ],
    );
  }

  Widget _buildLargeDesktop(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
  ) {
    return CustomField(
        isRtl: language.isRtl,
        padding: r.symmetric(horizontal: 40, vertical: 14),
        gap: r.size(20),
        minHeight: r.size(200),
        children: [
          BreadCrumbs(
            theme: theme,
            isRtl: language.isRtl,
          ),
          _buildHeader(theme: theme, ts: ts, isRtl: language.isRtl),
          Padding(
            padding: r.symmetric(horizontal: 20),
            child: CustomShrinkingLine(
              color: theme.accent.withOpacity(0.8),
              thickness: r.size(1),
            ),
          ),
          IntrinsicHeight(
            child: CustomField(
              mainAxisSize: MainAxisSize.min,
              arrangement: FieldArrangement.row,
              gap: r.size(20),
              children: [
                BoutiqueSidebar(
                  filteringData: _filteringDataResponse,
                  theme: theme,
                  ts: ts,
                  isRtl: language.isRtl,
                  sections: _mainCategoryResponse?.subCategories ?? [],
                  featuredAuthors: _featuredAuthorsResponse,
                  filterByAvailability: _boutiqueFilterByAvailabilityValue,
                  filterByPublicationDate:
                      _boutiqueFilterByPublicationDateValue,
                  filterByFormat: _boutiqueFilterByFormatValue,
                  filterByPriceRange: _boutiqueFilterByPriceRangeValue,
                  onFilterAvailabiltyPressed:
                      (BoutiqueFilterByAvailability filterByAvailability) {
                    setState(() {
                      _boutiqueFilterByAvailabilityValue = filterByAvailability;
                      _getProductsEvent();
                    });
                  },
                  onFilterPublicationDatePressed:
                      (BoutiqueFilterByPublicationDate
                          filterByPublicationDate) {
                    setState(() {
                      _boutiqueFilterByPublicationDateValue =
                          filterByPublicationDate;
                      _getProductsEvent();
                    });
                  },
                  onFilterByFormatPressed:
                      (BoutiqueFilterByFormat filterByFormat) {
                    setState(() {
                      _boutiqueFilterByFormatValue = filterByFormat;
                      _getProductsEvent();
                    });
                  },
                  onFilterByPriceRangeChanged: (lowestPrice, highestPrice) {
                    setState(() {
                      _boutiqueFilterByPriceRangeValue =
                          BoutiqueFilterByPriceRange(
                        lowestPrice: lowestPrice,
                        highestPrice: highestPrice,
                      );
                      _getProductsEvent();
                    });
                  },
                ),
                CustomLine(
                  color: theme.accent,
                  thickness: r.size(0.2),
                  size: double.infinity,
                  isVertical: true,
                ),
                Expanded(
                  child: _buildBody(
                    theme: theme,
                    ts: ts,
                    isRtl: language.isRtl,
                  ),
                )
              ],
            ),
          )
        ]);
  }

  /* Widget _buildDesktop(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    DropdownOverlay pageLimitDropdown,
    DropdownOverlay sortByDropdown,
  ) {
    return CustomField(
        isRtl: language.isRtl,
        padding: r.symmetric(horizontal: 40, vertical: 14),
        gap: r.size(14),
        children: [
          _buildBreadCrumbs(
              theme: theme, ts: ts, language: language, isRtl: language.isRtl),
          CustomField(
              gap: r.size(20),
              mainAxisAlignment: MainAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                if (_subCategoriesResponse.isNotEmpty &&
                    !(widget.search != null ||
                        widget.orderByCreateDate != false ||
                        widget.orderBySales != false ||
                        widget.categoryPath == null))
                  _buildSubCategoryListController(
                      theme: theme,
                      ts: ts,
                      language: language,
                      isRtl: language.isRtl),
                if (_productsResponse.isNotEmpty)
                  _buildProductListController(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                      viewCount: 4,
                      pagination: _paginationResponse,
                      pageLimitDropdown: pageLimitDropdown,
                      sortByDropdown: sortByDropdown),
                if (_productsResponse.isNotEmpty)
                  _buildProductList(
                    theme: theme,
                    ts: ts,
                    isRtl: language.isRtl,
                    products: _productsResponse,
                    itemsPerRow: _viewIndex,
                  ),
                if (_productsResponse.isNotEmpty)
                  Paginator(
                      theme: theme,
                      isRtl: language.isRtl,
                      currentPage: _paginationResponse.page ?? 1,
                      totalPages: _paginationResponse.pages ?? 1,
                      maxVisiblePages: 5,
                      onPageChanged: (index) {
                        _getProductEvents(page: index);
                      },
                      r: r)
              ])
        ]);
  }

  Widget _buildTablet(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    DropdownOverlay pageLimitDropdown,
    DropdownOverlay sortByDropdown,
  ) {
    return CustomField(
        isRtl: language.isRtl,
        padding: r.symmetric(horizontal: 20, vertical: 14),
        gap: r.size(14),
        children: [
          _buildBreadCrumbs(
              theme: theme, ts: ts, language: language, isRtl: language.isRtl),
          CustomField(
              gap: r.size(20),
              mainAxisAlignment: MainAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                if (_subCategoriesResponse.isNotEmpty &&
                    !(widget.search != null ||
                        widget.orderByCreateDate != false ||
                        widget.orderBySales != false ||
                        widget.categoryPath == null))
                  _buildSubCategoryListController(
                      theme: theme,
                      ts: ts,
                      language: language,
                      isRtl: language.isRtl),
                if (_productsResponse.isNotEmpty)
                  _buildProductListController(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                      viewCount: 3,
                      pagination: _paginationResponse,
                      isPaginationSummaryHidden: true,
                      pageLimitDropdown: pageLimitDropdown,
                      sortByDropdown: sortByDropdown),
                if (_productsResponse.isNotEmpty)
                  _buildProductList(
                    theme: theme,
                    ts: ts,
                    isRtl: language.isRtl,
                    products: _productsResponse,
                    itemsPerRow: _viewIndex,
                  ),
                if (_productsResponse.isNotEmpty)
                  Paginator(
                      theme: theme,
                      isRtl: language.isRtl,
                      currentPage: _paginationResponse.page ?? 1,
                      totalPages: _paginationResponse.pages ?? 1,
                      maxVisiblePages: 3,
                      onPageChanged: (index) {
                        _getProductEvents(page: index);
                      },
                      r: r)
              ])
        ]);
  }

  Widget _buildMobile(
    BuildContext context,
    BaseTheme theme,
    TranslationService ts,
    LanguageModel language,
    DropdownOverlay pageLimitDropdown,
    DropdownOverlay sortByDropdown,
  ) {
    return CustomField(
        isRtl: language.isRtl,
        padding: r.symmetric(horizontal: 10, vertical: 14),
        gap: r.size(14),
        children: [
          _buildBreadCrumbs(
              theme: theme, ts: ts, language: language, isRtl: language.isRtl),
          CustomField(
              gap: r.size(20),
              mainAxisAlignment: MainAxisAlignment.center,
              isRtl: language.isRtl,
              children: [
                if (_subCategoriesResponse.isNotEmpty &&
                    !(widget.search != null ||
                        widget.orderByCreateDate != false ||
                        widget.orderBySales != false ||
                        widget.categoryPath == null))
                  _buildSubCategoryListController(
                      theme: theme,
                      ts: ts,
                      language: language,
                      isRtl: language.isRtl),
                if (_productsResponse.isNotEmpty)
                  _buildProductListController(
                      theme: theme,
                      ts: ts,
                      isRtl: language.isRtl,
                      viewCount: 1,
                      pagination: _paginationResponse,
                      isPaginationSummaryHidden: true,
                      isViewControllerHidden: true,
                      isLimitSelectorHidden: true,
                      pageLimitDropdown: pageLimitDropdown,
                      sortByDropdown: sortByDropdown),
                if (_productsResponse.isNotEmpty)
                  _buildProductList(
                    theme: theme,
                    ts: ts,
                    isRtl: language.isRtl,
                    products: _productsResponse,
                    itemsPerRow: _viewIndex,
                  ),
                if (_productsResponse.isNotEmpty)
                  Paginator(
                      theme: theme,
                      isRtl: language.isRtl,
                      currentPage: _paginationResponse.page ?? 1,
                      totalPages: _paginationResponse.pages ?? 1,
                      maxVisiblePages: 2,
                      onPageChanged: (index) {
                        _getProductEvents(page: index);
                      },
                      r: r)
              ])
        ]);
  }
*/
}
