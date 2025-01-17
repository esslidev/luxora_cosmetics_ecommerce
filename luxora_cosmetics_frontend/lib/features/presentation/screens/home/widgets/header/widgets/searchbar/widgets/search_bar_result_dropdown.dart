import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/features/data/models/author.dart';
import 'package:librairie_alfia/features/domain/entities/author.dart';
import 'package:librairie_alfia/features/domain/entities/category.dart';

import '../../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../../../core/constants/app_paths.dart';
import '../../../../../../../../../core/enums/notification_type.dart';
import '../../../../../../../../../core/resources/bread_crumb_model.dart';
import '../../../../../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../../../../../core/util/app_events_util.dart';
import '../../../../../../../../../core/util/remote_events_util.dart';
import '../../../../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../../../../core/util/translation_service.dart';
import '../../../../../../../../data/models/category_translation.dart';
import '../../../../../../../../domain/entities/pagination.dart';
import '../../../../../../../../domain/entities/product.dart';
import '../../../../../../../bloc/app/theme/theme_bloc.dart';
import '../../../../../../../bloc/app/theme/theme_state.dart';
import '../../../../../../../bloc/remote/author/author_bloc.dart';
import '../../../../../../../bloc/remote/author/author_state.dart';
import '../../../../../../../bloc/remote/category/category_bloc.dart';
import '../../../../../../../bloc/remote/category/category_state.dart';
import '../../../../../../../bloc/remote/product/product_bloc.dart';
import '../../../../../../../bloc/remote/product/product_state.dart';
import '../../../../../../../widgets/common/custom_button.dart';
import '../../../../../../../widgets/common/custom_display.dart';
import '../../../../../../../widgets/common/custom_field.dart';
import '../../../../../../../widgets/common/custom_text.dart';
import '../../../../../../../widgets/features/product.dart';
import 'search_bar_advanced_dropdown.dart';

class SearchbarResultDropdown extends StatefulWidget {
  final BaseTheme theme;
  final TranslationService ts;
  final bool isRtl;
  final String? searchValue;
  final AdvancedSearchValues? advancedSearchValues;
  final Function(
      bool isBooksLoading, bool isAuthorsLoading, bool isThemesLoading) onLoad;
  final Function(int productId, String productName) onProductPressed;
  final Function(AuthorModel author) onAuthorPressed;
  final Function(int categoryNumber, String catergoryName) onThemePressed;
  final Function() onShowAllPressed;
  const SearchbarResultDropdown({
    super.key,
    required this.theme,
    required this.ts,
    required this.isRtl,
    this.searchValue,
    this.advancedSearchValues,
    required this.onLoad,
    required this.onProductPressed,
    required this.onAuthorPressed,
    required this.onThemePressed,
    required this.onShowAllPressed,
  });

  @override
  State<SearchbarResultDropdown> createState() =>
      _SearchbarResultDropdownState();
}

class _SearchbarResultDropdownState extends State<SearchbarResultDropdown> {
  late ResponsiveSizeAdapter r;

  List<ProductEntity> _searchedBooksResponse = [];
  PaginationEntity _paginationResponse = const PaginationEntity(
    limit: 24,
    total: 0,
    page: 1,
    pages: 1,
  );
  List<AuthorEntity> _searchedAuthorsResponse = [];
  List<CategoryEntity> _searchedThemesResponse = [];

  final ScrollController scrollSearchResultController = ScrollController();

  bool _isBooksResponseLoading = false;
  bool _isAuthorsResponseLoading = false;
  bool _isthemesResponseLoading = false;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.searchValue != null) {
        RemoteEventsUtil.productEvents.getSearchedProducts(
          context,
          search: widget.searchValue,
        );
        RemoteEventsUtil.authorEvents.getSearchedAuthors(
          context,
          search: widget.searchValue,
        );
      } else if (widget.advancedSearchValues != null) {
        RemoteEventsUtil.productEvents.getSearchedProducts(context,
            title: widget.advancedSearchValues?.title,
            authorName: widget.advancedSearchValues?.authorName,
            editor: widget.advancedSearchValues?.editor,
            categoryName: widget.advancedSearchValues?.categoryName,
            publicationDate: widget.advancedSearchValues?.publicationDate);
        if (widget.advancedSearchValues?.authorName != null) {
          RemoteEventsUtil.authorEvents.getSearchedAuthors(
            context,
            search: widget.advancedSearchValues!.authorName,
          );
        }
      }
    });
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

  //---------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, themeState) {
      return MultiBlocListener(
        listeners: [
          BlocListener<RemoteProductBloc, RemoteProductState>(
            listener: (context, state) {
              if (state is RemoteProductsLoading) {
                if (state.searchedProductsLoading == true) {
                  setState(() {
                    _isBooksResponseLoading = true;
                    widget.onLoad(
                      _isBooksResponseLoading,
                      _isAuthorsResponseLoading,
                      _isthemesResponseLoading,
                    );
                  });
                }
              }
              if (state is RemoteProductsLoaded) {
                if (state.searchedProducts != null) {
                  setState(() {
                    _isBooksResponseLoading = false;
                    _searchedBooksResponse = state.searchedProducts!;
                    _paginationResponse = state.pagination!;

                    // Extract category numbers from the _searchedBooksResponse
                    final categoryNumbers = _searchedBooksResponse
                        .map((product) => product.primaryCategoryNumber)
                        .where(
                            (number) => number != null) // Exclude null values
                        .toSet() // Remove duplicates
                        .join('_'); // Join with underscores

                    RemoteEventsUtil.categoryEvents.getSearchMainCategories(
                        context,
                        categoryNumbers: categoryNumbers);
                    widget.onLoad(
                      _isBooksResponseLoading,
                      _isAuthorsResponseLoading,
                      _isthemesResponseLoading,
                    );
                  });
                }
              }

              if (state is RemoteProductError) {
                _isBooksResponseLoading = false;
                widget.onLoad(
                  _isBooksResponseLoading,
                  _isAuthorsResponseLoading,
                  _isthemesResponseLoading,
                );
                AppEventsUtil.liteNotifications.addLiteNotification(context,
                    notification: LiteNotificationModel(
                      notificationTitle: state.error?.response?.data["error"],
                      notificationMessage:
                          state.error?.response?.data["message"],
                      notificationType: NotificationType.error,
                    ));
              }
            },
          ),
          BlocListener<RemoteAuthorBloc, RemoteAuthorState>(
            listener: (context, state) {
              if (state is RemoteAuthorsLoading) {
                if (state.searchedAuthorsLoading == true) {
                  setState(() {
                    _isAuthorsResponseLoading = true;
                    widget.onLoad(
                      _isBooksResponseLoading,
                      _isAuthorsResponseLoading,
                      _isthemesResponseLoading,
                    );
                  });
                }
              }
              if (state is RemoteAuthorsLoaded) {
                if (state.searchedAuthors != null) {
                  setState(() {
                    _isAuthorsResponseLoading = false;
                    _searchedAuthorsResponse = state.searchedAuthors!;
                    widget.onLoad(
                      _isBooksResponseLoading,
                      _isAuthorsResponseLoading,
                      _isthemesResponseLoading,
                    );
                  });
                }
              }

              if (state is RemoteAuthorError) {
                _isAuthorsResponseLoading = false;
                widget.onLoad(
                  _isBooksResponseLoading,
                  _isAuthorsResponseLoading,
                  _isthemesResponseLoading,
                );
                AppEventsUtil.liteNotifications.addLiteNotification(context,
                    notification: LiteNotificationModel(
                      notificationTitle: state.error?.response?.data["error"],
                      notificationMessage:
                          state.error?.response?.data["message"],
                      notificationType: NotificationType.error,
                    ));
              }
            },
          ),
          BlocListener<RemoteCategoryBloc, RemoteCategoryState>(
            listener: (context, state) {
              if (state is RemoteMainCategoriesLoading) {
                if (state.searchMainCategoriesLoading == true) {
                  setState(() {
                    _isthemesResponseLoading = true;
                    widget.onLoad(
                      _isBooksResponseLoading,
                      _isAuthorsResponseLoading,
                      _isthemesResponseLoading,
                    );
                  });
                }
              }
              if (state is RemoteMainCategoriesLoaded) {
                if (state.searchMainCategories != null) {
                  setState(() {
                    _searchedThemesResponse = state.searchMainCategories!;
                    _isthemesResponseLoading = false;
                    widget.onLoad(
                      _isBooksResponseLoading,
                      _isAuthorsResponseLoading,
                      _isthemesResponseLoading,
                    );
                  });
                }
              }

              if (state is RemoteCategoryError) {
                _isthemesResponseLoading = false;
                widget.onLoad(
                  _isBooksResponseLoading,
                  _isAuthorsResponseLoading,
                  _isthemesResponseLoading,
                );
                AppEventsUtil.liteNotifications.addLiteNotification(context,
                    notification: LiteNotificationModel(
                      notificationTitle: state.error?.response?.data["error"],
                      notificationMessage:
                          state.error?.response?.data["message"],
                      notificationType: NotificationType.error,
                    ));
              }
            },
          ),
        ],
        child: ResponsiveScreenAdapter(
          fallbackScreen: _buildSearchbarResultDropdown(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            books: _searchedBooksResponse,
            authors: _searchedAuthorsResponse,
            themes: _searchedThemesResponse,
            itemsPerRow: 5,
          ),
          screenDesktop: _buildSearchbarResultDropdown(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            books: _searchedBooksResponse,
            authors: _searchedAuthorsResponse,
            themes: _searchedThemesResponse,
            itemsPerRow: 4,
          ),
          screenTablet: _buildSearchbarResultDropdown(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            books: _searchedBooksResponse,
            authors: _searchedAuthorsResponse,
            themes: _searchedThemesResponse,
            itemsPerRow: 4,
          ),
          screenMobile: _buildSearchbarResultDropdown(
            theme: widget.theme,
            ts: widget.ts,
            isRtl: widget.isRtl,
            books: _searchedBooksResponse,
            authors: _searchedAuthorsResponse,
            themes: _searchedThemesResponse,
            itemsPerRow: 3,
          ),
        ),
      );
    });
  }

  //---------------------------------------------------------------//

  Widget _buildTitle({
    required BaseTheme theme,
    required TranslationService ts,
    required String title,
  }) {
    return CustomText(
      text: title,
      backgroundColor: theme.secondaryBackgroundColor,
      width: double.infinity,
      fontSize: r.size(10),
      fontWeight: FontWeight.bold,
      padding: EdgeInsets.symmetric(vertical: r.size(4), horizontal: r.size(8)),
    );
  }

  Widget _buildBooksList({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<ProductEntity> books,
    required int itemsPerRow,
  }) {
    return CustomField(
      mainAxisAlignment: MainAxisAlignment.center,
      padding: r.symmetric(vertical: 8),
      arrangement: FieldArrangement.row,
      children: books.take(itemsPerRow).map((book) {
        return Expanded(
          flex: 1,
          child: ProductWidget(
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
            isPriceVisible: false,
            width: r.size(84),
            height: r.size(120),
            authorFontSize: r.size(7),
            titleFontSize: r.size(7),
            borderOnHover: true,
            isOfferBadgeVisible: false,
            onPressed: (productId, productName) {
              widget.onProductPressed(productId, productName);
            },
            onAuthorPressed: (author) {
              widget.onAuthorPressed(author);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAuthorButton({
    required BaseTheme theme,
    required String name,
    required String searchValue,
  }) {
    List<TextSpan> textSpans = [];

    for (int i = 0; i < name.length; i++) {
      String character = name[i].toLowerCase();

      bool isMatch = searchValue.contains(character);

      textSpans.add(
        TextSpan(
          text: character,
          style: TextStyle(
            fontSize: r.size(10),
            fontWeight: FontWeight.bold,
            color: theme.accent,
            backgroundColor: isMatch ? theme.third.withOpacity(0.4) : null,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }

  Widget _buildAuthorList({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<AuthorEntity> authors,
    required String searchValue,
  }) {
    return IntrinsicHeight(
      child: CustomField(
        maxHeight: r.size(120),
        children: [
          Expanded(
            child: RawScrollbar(
              thumbColor: theme.primary.withOpacity(0.4),
              radius: Radius.circular(r.size(10)),
              thickness: r.size(5),
              thumbVisibility: true,
              controller: scrollSearchResultController,
              child: SingleChildScrollView(
                child: CustomField(
                    gap: r.size(8),
                    width: double.infinity,
                    padding: r.symmetric(vertical: 8, horizontal: 8),
                    children: [
                      ...authors.map((author) {
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              widget.onAuthorPressed(AuthorModel(
                                  firstName: author.firstName,
                                  lastName: author.lastName));
                              Beamer.of(context).beamToNamed(
                                  '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
                              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                                  breadCrumb: BreadCrumbModel(
                                      name:
                                          'Auteur: ${author.firstName} ${author.lastName}',
                                      path:
                                          '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
                            },
                            child: _buildAuthorButton(
                                theme: theme,
                                name: '${author.firstName} ${author.lastName}'
                                    .toLowerCase(),
                                searchValue: searchValue),
                          ),
                        );
                      }),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeList({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<CategoryEntity> themes,
  }) {
    return IntrinsicHeight(
      child: CustomField(
        maxHeight: r.size(120),
        children: [
          Expanded(
            child: RawScrollbar(
              thumbColor: theme.primary.withOpacity(0.4),
              radius: Radius.circular(r.size(10)),
              thickness: r.size(5),
              thumbVisibility: true,
              controller: scrollSearchResultController,
              child: SingleChildScrollView(
                child: CustomField(
                    gap: r.size(4),
                    width: double.infinity,
                    padding: r.symmetric(vertical: 4, horizontal: 8),
                    children: [
                      ...themes.map((theme) {
                        CategoryTranslationModel? themeTranslation =
                            getCategoryTranslation(
                                translations: theme.translations);
                        return CustomButton(
                          text: themeTranslation?.name ?? '',
                          fontSize: r.size(12),
                          fontWeight: FontWeight.bold,
                          fontFamily: themeTranslation?.languageCode == 'ar'
                              ? 'cairo'
                              : null,
                          onPressed: (position, size) {
                            if (theme.categoryNumber != null) {
                              widget.onThemePressed(theme.categoryNumber!,
                                  themeTranslation?.name ?? '');
                            }
                          },
                        );
                      }),
                    ]),
              ),
            ),
          ),
        ],
      ),
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
      padding: r.symmetric(vertical: 12),
      isRtl: isRtl,
      children: [
        CustomDisplay(
          assetPath: AppPaths.vectors.noSearchResultFound,
          width: r.size(60),
          height: r.size(60),
          isSvg: true,
        ),
        CustomText(
          text: ts.translate(
              'screens.home.header.searchbar.resultOverlay.NoResult'),
          fontSize: r.size(10),
          fontWeight: FontWeight.bold,
          color: theme.accent.withOpacity(0.4),
        ),
      ],
    );
  }

  Widget _buildSeeAllButton({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
  }) {
    return CustomButton(
      useIntrinsicWidth: false,
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
        backgroundColor: theme.secondaryBackgroundColor,
      ),
      padding: r.symmetric(vertical: 2),
      text: ts.translate(
          'screens.home.header.searchbar.resultOverlay.seeAllResult'),
      border: Border(
          top: BorderSide(
              color: theme.accent.withOpacity(0.4), width: r.size(0.6))),
      fontSize: r.size(11),
      fontWeight: FontWeight.w800,
      onPressed: (position, size) {
        widget.onShowAllPressed();
      },
    );
  }

  Widget _buildSearchbarResultDropdown({
    required BaseTheme theme,
    required TranslationService ts,
    required bool isRtl,
    required List<ProductEntity> books,
    required List<AuthorEntity> authors,
    required List<CategoryEntity> themes,
    required int itemsPerRow,
  }) {
    return IntrinsicHeight(
      child: CustomField(
        maxHeight: r.screenHeight - r.size(60),
        children: [
          Expanded(
            child: RawScrollbar(
              thumbColor: theme.primary.withOpacity(0.4),
              radius: Radius.circular(r.size(10)),
              thickness: r.size(5),
              thumbVisibility: true,
              controller: scrollSearchResultController,
              child: SingleChildScrollView(
                child: CustomField(
                    width: double.infinity,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    isRtl: isRtl,
                    gap: r.size(4),
                    padding: r.all(4),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTitle(
                        theme: theme,
                        ts: ts,
                        title:
                            '${ts.translate('screens.home.header.searchbar.resultOverlay.articles')} (${_paginationResponse.total})',
                      ),
                      if (books.isEmpty)
                        _buildResultNotFound(
                          theme: theme,
                          ts: ts,
                          isRtl: isRtl,
                        )
                      else
                        _buildBooksList(
                          theme: theme,
                          ts: ts,
                          isRtl: isRtl,
                          books: books,
                          itemsPerRow: itemsPerRow,
                        ),
                      _buildTitle(
                        theme: theme,
                        ts: ts,
                        title:
                            '${ts.translate('screens.home.header.searchbar.resultOverlay.authors')} (${authors.length})',
                      ),
                      if (authors.isEmpty)
                        _buildResultNotFound(
                          theme: theme,
                          ts: ts,
                          isRtl: isRtl,
                        )
                      else
                        _buildAuthorList(
                          theme: theme,
                          ts: ts,
                          isRtl: isRtl,
                          authors: authors,
                          searchValue: widget.searchValue ??
                              widget.advancedSearchValues?.authorName ??
                              '',
                        ),
                      _buildTitle(
                        theme: theme,
                        ts: ts,
                        title:
                            '${ts.translate('screens.home.header.searchbar.resultOverlay.themes')} (${themes.length})',
                      ),
                      if (themes.isEmpty)
                        _buildResultNotFound(
                          theme: theme,
                          ts: ts,
                          isRtl: isRtl,
                        )
                      else
                        _buildThemeList(
                          theme: theme,
                          ts: ts,
                          isRtl: isRtl,
                          themes: themes,
                        ),
                      if (books.isNotEmpty)
                        Center(
                          child: _buildSeeAllButton(
                            theme: theme,
                            ts: ts,
                            isRtl: isRtl,
                          ),
                        ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
