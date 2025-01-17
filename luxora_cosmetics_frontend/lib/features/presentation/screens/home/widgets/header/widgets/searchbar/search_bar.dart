import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:librairie_alfia/features/data/models/author.dart';

import '../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../../core/constants/app_paths.dart';
import '../../../../../../../../core/enums/widgets.dart';
import '../../../../../../../../core/resources/bread_crumb_model.dart';
import '../../../../../../../../core/resources/global_contexts.dart';
import '../../../../../../../../core/util/app_events_util.dart';
import '../../../../../../../../core/util/app_util.dart';
import '../../../../../../../../core/util/custom_timer.dart';
import '../../../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../../../core/util/translation_service.dart';
import '../../../../../../../../locator.dart';

import '../../../../../../overlays/dropdown/dropdown.dart';
import '../../../../../../widgets/common/custom_button.dart';
import '../../../../../../widgets/common/custom_field.dart';
import '../../../../../../widgets/common/custom_text_field.dart';
import 'widgets/search_bar_advanced_dropdown.dart';
import 'widgets/search_bar_result_dropdown.dart';

class SearchBarWidget extends StatefulWidget {
  final BaseTheme theme;
  final TranslationService ts;
  final bool isRtl;
  final double width;
  final bool isCompact;
  const SearchBarWidget({
    super.key,
    required this.theme,
    required this.ts,
    this.isRtl = false,
    required this.width,
    this.isCompact = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  final GlobalKey _searchbarKey = GlobalKey();
  bool _isSearchbarLoading = false;
  CustomTimer? _searchbarDelayTimer;
  String? _searchValue;
  AdvancedSearchValues? _advancedSearchValues;

  final LayerLink _searchbarDropdownLayerLink = LayerLink();

  late DropdownOverlay _searchAdvancedDropdown;
  late DropdownOverlay _searchResultDropdown;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    homeContext = locator<GlobalContexts>().homeContext;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchAdvancedDropdown = _buildSearchDropdown();
      _searchResultDropdown = _buildSearchDropdown();
    });
  }

  void _showSearchbarResult() {
    _searchResultDropdown.show(
        layerLink: _searchbarDropdownLayerLink,
        backgroundColor: widget.theme.overlayBackgroundColor,
        borderColor: widget.theme.accent.withOpacity(0.4),
        shadowColor: widget.theme.shadowColor,
        targetWidgetSize: AppUtil.getSizeByGlobalKey(_searchbarKey),
        width: AppUtil.getSizeByGlobalKey(_searchbarKey).width,
        dropdownAlignment: DropdownAlignment.center,
        forceRefresh: true,
        child: SearchbarResultDropdown(
          theme: widget.theme,
          ts: widget.ts,
          isRtl: widget.isRtl,
          searchValue: _searchValue,
          advancedSearchValues: _advancedSearchValues,
          onLoad: (isBooksLoading, isAuthorsLoading, isThemesLoading) {
            setState(() {
              _isSearchbarLoading =
                  isBooksLoading || isAuthorsLoading || isThemesLoading;
            });
          },
          onProductPressed: (productId, productName) {
            _searchResultDropdown.dismiss();
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.bookOverviewScreen}?productId=$productId');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: productName,
                    path:
                        '${AppPaths.routes.bookOverviewScreen}?productId=$productId'));
          },
          onShowAllPressed: () {
            _searchResultDropdown.dismiss();
            if (_searchValue != null && _searchValue!.trim().isNotEmpty) {
              Beamer.of(context).beamToNamed(
                  '${AppPaths.routes.boutiqueScreen}?searchValue=$_searchValue');
              AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                  breadCrumb: BreadCrumbModel(
                      name: 'Résultats de recherche pour : $_searchValue',
                      path:
                          '${AppPaths.routes.boutiqueScreen}?searchValue=$_searchValue'));
            } else if (_advancedSearchValues != null) {
              //advanced search routing...
              List<String> queryParams = [];
              if (_advancedSearchValues!.title != null) {
                queryParams
                    .add('advancedSearchTitle=${_advancedSearchValues!.title}');
              }
              if (_advancedSearchValues!.authorName != null) {
                queryParams.add(
                    'advancedSearchAuthor=${_advancedSearchValues!.authorName}');
              }
              if (_advancedSearchValues!.editor != null) {
                queryParams.add(
                    'advancedSearchEditor=${_advancedSearchValues!.editor}');
              }
              if (_advancedSearchValues!.categoryName != null) {
                queryParams.add(
                    'advancedSearchCategory=${_advancedSearchValues!.categoryName}');
              }
              if (_advancedSearchValues!.publicationDate != null) {
                queryParams.add(
                    'advancedSearchPublicationDate=${_advancedSearchValues!.publicationDate}');
              }

// If there are any query parameters, join them with '&'
              if (queryParams.isNotEmpty) {
                final queryString = queryParams.join('&');
                // Beams to the boutiqueScreen with the query parameters
                Beamer.of(context).beamToNamed(
                    '${AppPaths.routes.boutiqueScreen}?$queryString');
                AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                    breadCrumb: BreadCrumbModel(
                        name: 'Résultats de recherche avancée',
                        path:
                            '${AppPaths.routes.boutiqueScreen}?$queryString'));
              }
            }
          },
          onAuthorPressed: (AuthorModel author) {
            _searchResultDropdown.dismiss();
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: 'Auteur: ${author.firstName} ${author.lastName}',
                    path:
                        '${AppPaths.routes.boutiqueScreen}?authorName=${author.firstName} ${author.lastName}'));
          },
          onThemePressed: (categoryNumber, categoryName) {
            _searchResultDropdown.dismiss();
            Beamer.of(context).beamToNamed(
                '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=$categoryNumber');
            AppEventsUtil.breadCrumbs.addBreadCrumb(context,
                breadCrumb: BreadCrumbModel(
                    name: categoryName,
                    path:
                        '${AppPaths.routes.boutiqueScreen}?mainCategoryNumber=$categoryNumber'));
          },
        ));
  }

  //------------------------------------------------------------//

  DropdownOverlay _buildSearchDropdown() {
    return DropdownOverlay(
      context: context,
      borderRadius: Radius.circular(r.size(2)),
      borderWidth: r.size(1),
      margin: EdgeInsets.only(top: r.size(2)),
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSearchbar(
      theme: widget.theme,
      ts: widget.ts,
      isRtl: widget.isRtl,
      key: _searchbarKey,
      link: _searchbarDropdownLayerLink,
      width: widget.width,
      isCompact: widget.isCompact,
    );
  }

  //--------------------------------------------------------------//

  Widget _buildSearchbar(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required Key key,
      required LayerLink link,
      required double width,
      double? height,
      bool isCompact = false}) {
    return CompositedTransformTarget(
      link: link,
      child: CustomField(
          key: key,
          arrangement: FieldArrangement.row,
          isRtl: isRtl,
          width: width,
          height: height,
          children: [
            if (!isCompact)
              CustomButton(
                height: r.size(26),
                text: ts.translate(
                    'screens.home.header.searchbar.advancedButtonText'),
                fontSize: r.size(8),
                padding: r.symmetric(horizontal: 12),
                svgIconPath: AppPaths.vectors.triangleBottomIcon,
                iconPosition: CustomButtonIconPosition.right,
                iconHeight: r.size(4),
                iconTextGap: r.size(4),
                iconColor: theme.bodyText,
                borderRadius: BorderRadius.only(
                  topLeft: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                  bottomLeft: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                  topRight: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                  bottomRight: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                ),
                backgroundColor: theme.searchbarAdvancedBackgroundColor,
                fontWeight: FontWeight.bold,
                textColor: theme.bodyText,
                border: Border(
                    top: BorderSide(color: theme.accent, width: r.size(1)),
                    left: !isRtl
                        ? BorderSide(color: theme.accent, width: r.size(1))
                        : BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(color: theme.accent, width: r.size(1))),
                onPressed: (position, size) {
                  _searchAdvancedDropdown.show(
                      layerLink: _searchbarDropdownLayerLink,
                      backgroundColor: theme.overlayBackgroundColor,
                      borderColor: theme.accent.withOpacity(0.4),
                      shadowColor: theme.shadowColor,
                      targetWidgetSize:
                          AppUtil.getSizeByGlobalKey(_searchbarKey),
                      width: AppUtil.getSizeByGlobalKey(_searchbarKey).width,
                      dropdownAlignment: DropdownAlignment.start,
                      child: SearchbarAdvancedDropdown(
                        theme: theme,
                        ts: ts,
                        isRtl: isRtl,
                        onSubmitPressed: (AdvancedSearchValues searchValues) {
                          _searchAdvancedDropdown.dismiss();
                          _searchValue = null;
                          _advancedSearchValues = searchValues;
                          _showSearchbarResult();
                        },
                      ));
                },
              ),
            Expanded(
              child: CustomTextField(
                height: r.size(26),
                hintText:
                    ts.translate('screens.home.header.searchbar.hintText'),
                fontSize: r.size(10),
                padding: r.symmetric(horizontal: 8),
                onChanged: (value, position, size) {
                  if (value.trim().isNotEmpty) {
                    _searchbarDelayTimer?.stop();
                    // Initialize or restart the timer
                    _searchbarDelayTimer = CustomTimer(
                      onTimerStop: () {
                        _searchValue = value;
                        _advancedSearchValues = null;
                        _showSearchbarResult();
                      },
                    );
                    _searchbarDelayTimer!.start(duration: 1400.ms);
                  } else {
                    _searchResultDropdown.dismiss();
                    _searchbarDelayTimer?.stop();
                  }
                },
                borderRadius: isCompact
                    ? BorderRadius.only(
                        topRight:
                            isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                        bottomRight:
                            isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                        topLeft:
                            !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                        bottomLeft:
                            !isRtl ? Radius.circular(r.size(4)) : Radius.zero)
                    : null,
                border: !isCompact
                    ? Border.symmetric(
                        horizontal:
                            BorderSide(color: theme.accent, width: r.size(1)),
                      )
                    : Border(
                        top: BorderSide(color: theme.accent, width: r.size(1)),
                        right: isRtl
                            ? BorderSide(color: theme.accent, width: r.size(1))
                            : BorderSide.none,
                        left: !isRtl
                            ? BorderSide(color: theme.accent, width: r.size(1))
                            : BorderSide.none,
                        bottom:
                            BorderSide(color: theme.accent, width: r.size(1))),
              ),
            ),
            if (!_isSearchbarLoading)
              CustomButton(
                width: r.size(26),
                height: r.size(26),
                svgIconPath: AppPaths.vectors.searchIcon,
                iconColor: theme.searchbarIconColor,
                iconHeight: r.size(10),
                backgroundColor: theme.accent,
                border: Border(
                    top: BorderSide(color: theme.accent, width: r.size(1)),
                    right: !isRtl
                        ? BorderSide(color: theme.accent, width: r.size(1))
                        : BorderSide.none,
                    left: isRtl
                        ? BorderSide(color: theme.accent, width: r.size(1))
                        : BorderSide.none,
                    bottom: BorderSide(color: theme.accent, width: r.size(1))),
                borderRadius: BorderRadius.only(
                    topRight: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                    bottomRight:
                        !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                    topLeft: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                    bottomLeft:
                        isRtl ? Radius.circular(r.size(4)) : Radius.zero),
                onPressed: (position, size) {
                  if (!_searchResultDropdown.isShown() &&
                      _searchValue != null) {
                    _showSearchbarResult();
                  }
                },
              )
            else
              Container(
                width: r.size(26),
                height: r.size(26),
                padding: r.all(8),
                decoration: BoxDecoration(
                  color: theme.accent,
                  border: Border(
                    top: BorderSide(color: theme.accent, width: r.size(1)),
                    right: !isRtl
                        ? BorderSide(color: theme.accent, width: r.size(1))
                        : BorderSide.none,
                    left: isRtl
                        ? BorderSide(color: theme.accent, width: r.size(1))
                        : BorderSide.none,
                    bottom: BorderSide(color: theme.accent, width: r.size(1)),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                    bottomRight:
                        !isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                    topLeft: isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                    bottomLeft:
                        isRtl ? Radius.circular(r.size(4)) : Radius.zero,
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.searchbarIconColor,
                    ),
                    strokeWidth: r.size(1.5),
                  ),
                ),
              )
          ]),
    );
  }
}
