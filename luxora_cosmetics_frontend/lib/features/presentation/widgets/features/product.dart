import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/core/enums/widgets.dart';
import 'package:librairie_alfia/core/resources/language_model.dart';
import 'package:librairie_alfia/features/data/models/author.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_line.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/resources/currency_model.dart';
import '../../../../core/util/app_util.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../../../core/util/translation_service.dart';
import '../../bloc/app/currency/currency_bloc.dart';
import '../../bloc/app/currency/currency_state.dart';
import '../../bloc/app/language/translation_bloc.dart';
import '../../bloc/app/language/translation_state.dart';
import '../../bloc/app/theme/theme_bloc.dart';
import '../../bloc/app/theme/theme_state.dart';
import '../common/custom_button.dart';
import '../common/custom_display.dart';
import '../common/custom_field.dart';
import '../common/custom_text.dart';

class ProductWidget extends StatefulWidget {
  final int? productId;
  final String? networkImageUrl;
  final AuthorModel? author;
  final String? title;
  final double? titleMaxWidth;
  final double? price;
  final double? pricePromo;
  final double? pricePromoPercentage;
  final bool? isNewArrival;
  final bool? isBestSellers;
  final bool? isOnWishlist;
  final bool? isOnCart;
  final bool isHorizontal;
  final bool borderOnHover;
  final double? offerBadgeSize;
  final double? offerBadgeFontSize;
  final bool isOfferBadgeVisible;
  final bool isActionsCardVisible;
  final bool isPriceVisible;

  // New font size parameters
  final double? coverWidth;
  final double? authorFontSize;
  final double? titleFontSize;
  final double? priceFontSize;

  // New width and height parameters
  final double? width;
  final double? height;

  // action callbacks
  final Function(
    int productId,
    String productName,
  )? onPressed;
  final Function(int productId)? onWishlistPressed;
  final Function(int productId)? onCartPressed;
  final Function(int productId)? onPurchasePressed;
  final Function(AuthorModel author)? onAuthorPressed;

  const ProductWidget(
      {super.key,
      this.productId,
      this.networkImageUrl,
      this.author,
      this.title,
      this.titleMaxWidth,
      this.price,
      this.pricePromo,
      this.pricePromoPercentage,
      this.isNewArrival = false,
      this.isBestSellers = false,
      this.isOnWishlist = false,
      this.isOnCart = false,
      this.isHorizontal = false,
      this.borderOnHover = false,
      this.coverWidth,
      this.authorFontSize,
      this.titleFontSize,
      this.priceFontSize,
      this.width,
      this.height,
      this.offerBadgeSize,
      this.offerBadgeFontSize,
      this.isOfferBadgeVisible = true,
      this.isActionsCardVisible = true,
      this.isPriceVisible = true,
      this.onWishlistPressed,
      this.onCartPressed,
      this.onPressed,
      this.onPurchasePressed,
      this.onAuthorPressed});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ResponsiveSizeAdapter r;
  bool _toggleActionsWidget = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, themeState) {
      return BlocBuilder<AppTranslationBloc, AppTranslationState>(
          builder: (context, translationState) {
        if (translationState.translationService != null &&
            translationState.language != null) {
          return BlocBuilder<AppCurrencyBloc, AppCurrencyState>(
              builder: (context, currencyState) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                setState(() {
                  _toggleActionsWidget = true;
                  _isHovered = true;
                });
              },
              onExit: (event) {
                setState(() {
                  _toggleActionsWidget = false;
                  _isHovered = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  if (widget.productId != null && widget.onPressed != null) {
                    widget.onPressed!(widget.productId!, widget.title!);
                  }
                },
                onDoubleTap: () {
                  setState(() {
                    if (_toggleActionsWidget != true) {
                      setState(() {
                        _toggleActionsWidget = true;
                      });
                    } else {
                      setState(() {
                        _toggleActionsWidget = false;
                      });
                    }
                  });
                },
                child: _buildProduct(
                  context: context,
                  theme: themeState.theme,
                  ts: translationState.translationService!,
                  language: translationState.language!,
                  currency: currencyState.currency,
                  coverWidth: widget.coverWidth,
                ),
              ),
            );
          });
        }
        return const SizedBox();
      });
    });
  }

  Widget _buildProductActionCardButton({
    required String svgIconPath,
    required BaseTheme theme,
    Color? iconColor,
    Color? onHoverIconColor,
    Function? onPressed,
  }) {
    return CustomButton(
      svgIconPath: svgIconPath,
      width: r.size(18),
      iconColor: iconColor ?? theme.accent,
      padding: r.symmetric(vertical: 4, horizontal: 4),
      onHoverStyle: CustomButtonStyle(iconColor: onHoverIconColor),
      onPressed: (position, size) {
        if (onPressed != null) {
          onPressed();
        }
      },
    );
  }

  Widget _buildProductActionsCard({
    required BaseTheme theme,
    required bool isRtl,
    int? productId,
    bool isVisible = true,
    bool? isOnWishlist = true,
    bool? isOnCart = true,
  }) {
    return isVisible
        ? CustomField(
            mainAxisSize: MainAxisSize.min,
            margin: r.only(top: 4, left: isRtl ? 8 : 0, right: !isRtl ? 8 : 0),
            backgroundColor: theme.thirdBackgroundColor,
            padding: r.all(2),
            borderRadius: r.size(2),
            shadowColor: theme.shadowColor,
            shadowOffset: Offset(r.size(2), r.size(2)),
            arrangement: FieldArrangement.row,
            isRtl: isRtl,
            gap: r.size(2),
            height: r.size(20),
            children: [
              _buildProductActionCardButton(
                  theme: theme,
                  svgIconPath: AppPaths.vectors.heartIcon,
                  iconColor: isOnWishlist == true
                      ? AppColors.colors.redRouge
                      : theme.accent,
                  onHoverIconColor: isOnWishlist == true
                      ? AppColors.colors.redRouge.withOpacity(0.8)
                      : theme.accent.withOpacity(0.8),
                  onPressed: () {
                    if (widget.productId != null &&
                        widget.onWishlistPressed != null) {
                      widget.onWishlistPressed!(widget.productId!);
                    }
                  }),
              CustomLine(
                thickness: 1,
                isVertical: true,
                size: r.size(24),
                color: theme.accent.withOpacity(0.2),
              ),
              _buildProductActionCardButton(
                  theme: theme,
                  svgIconPath: AppPaths.vectors.cartFillIcon,
                  iconColor: isOnCart == true ? theme.primary : theme.accent,
                  onHoverIconColor: isOnCart == true
                      ? theme.primary.withOpacity(0.8)
                      : theme.accent.withOpacity(0.8),
                  onPressed: () {
                    if (widget.productId != null &&
                        widget.onCartPressed != null) {
                      widget.onCartPressed!(widget.productId!);
                    }
                  }),
              CustomLine(
                thickness: 1,
                isVertical: true,
                size: r.size(24),
                color: theme.accent.withOpacity(0.2),
              ),
              _buildProductActionCardButton(
                  theme: theme,
                  svgIconPath: AppPaths.vectors.purchaseFillIcon,
                  onHoverIconColor: AppColors.colors.yellowHoneyGlow,
                  onPressed: () {
                    if (widget.productId != null &&
                        widget.onPurchasePressed != null) {
                      widget.onPurchasePressed!(widget.productId!);
                    }
                  }),
              CustomLine(
                thickness: 1,
                isVertical: true,
                size: r.size(24),
                color: theme.accent.withOpacity(0.2),
              ),
              _buildProductActionCardButton(
                  theme: theme,
                  svgIconPath: AppPaths.vectors.eyeFillIcon,
                  iconColor: theme.accent,
                  onHoverIconColor: theme.accent.withOpacity(0.8),
                  onPressed: () {
                    if (widget.productId != null && widget.onPressed != null) {
                      widget.onPressed!(widget.productId!, widget.title!);
                    }
                  }),
            ],
          )
        : const SizedBox();
  }

  Widget _buildProductOfferBadge(
      {required TranslationService ts,
      required bool isRtl,
      double? size,
      double? fontSize,
      bool isVisible = true,
      double discount = 0,
      bool? isNewArrival,
      bool? isBestSellers}) {
    return isVisible &&
            (discount != 0 || isNewArrival == true || isBestSellers == true)
        ? IgnorePointer(
            ignoring: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomField(
                mainAxisSize: MainAxisSize.min,
                margin:
                    r.only(top: 4, left: !isRtl ? 4 : 0, right: isRtl ? 4 : 0),
                isRtl: isRtl,
                width: size ?? r.size(54),
                height: size ?? r.size(54),
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomDisplay(
                        assetPath: AppPaths.vectors.badge,
                        width: size ?? r.size(54),
                        height: size ?? r.size(54),
                        isSvg: true,
                        svgColor: discount != 0
                            ? AppColors.colors.redRouge
                            : isBestSellers == true
                                ? AppColors.colors.yellowHoneyGlow
                                : AppColors.colors.greenSwagger,
                      ),
                      CustomText(
                        text: discount != 0
                            ? AppUtil.getDiscountBadge(ts, discount)
                            : isBestSellers == true
                                ? ts.translate(
                                    'widgets.product.offerBadge.bestSellers')
                                : isNewArrival == true
                                    ? ts.translate(
                                        'widgets.product.offerBadge.newArrivals')
                                    : '',
                        fontSize: fontSize ?? r.size(8),
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w900,
                        color: AppColors.colors.whiteSolid,
                        padding: r.symmetric(horizontal: 4),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildNoCover({
    required BaseTheme theme,
    required TranslationService ts,
    double? coverWidth,
  }) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: CustomField(
        width: r.size(200),
        height: r.size(300),
        padding: r.all(14),
        backgroundColor: theme.secondaryBackgroundColor,
        gap: r.size(12),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomDisplay(
            assetPath: AppPaths.vectors.noCover,
            svgColor: theme.primary.withOpacity(0.6),
            isSvg: true,
            height: r.size(120), // Original size; FittedBox will scale it
            cursor: SystemMouseCursors.click,
          ),
          CustomField(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: ts.translate('widgets.product.noCover'),
                fontSize: r.size(18),
                color: theme.primary.withOpacity(0.6),
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
              CustomText(
                text: ts.translate('*400 x 600px'),
                fontSize: r.size(12),
                color: theme.primary.withOpacity(0.6),
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProduct({
    required BuildContext context,
    required BaseTheme theme,
    required TranslationService ts,
    required LanguageModel language,
    required CurrencyModel currency,
    double? coverWidth,
  }) {
    return CustomField(
        width: widget.width,
        height: widget.height,
        isRtl: language.isRtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: EdgeInsets.symmetric(horizontal: r.size(4)),
        gap: r.size(4),
        borderColor: _isHovered == true && widget.borderOnHover == true
            ? theme.primary.withOpacity(0.6)
            : null,
        borderWidth: r.size(2),
        borderRadius: r.size(2),
        arrangement: widget.isHorizontal == false
            ? FieldArrangement.column
            : FieldArrangement.row,
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomDisplay(
                  assetPath: widget.networkImageUrl!,
                  isNetwork: true,
                  width: coverWidth ?? double.infinity,
                  cursor: SystemMouseCursors.click,
                  loadingWidget: Container(
                    height: double.infinity,
                    width: coverWidth ?? double.infinity,
                    color: theme.secondaryBackgroundColor,
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .shimmer(
                          delay: 200.ms,
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                          color: theme.accent.withOpacity(0.2)),
                  errorWidget: _buildNoCover(
                      theme: theme, ts: ts, coverWidth: coverWidth),
                ),
                Align(
                    alignment: !language.isRtl
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: _buildProductOfferBadge(
                        isVisible: widget.isOfferBadgeVisible,
                        ts: ts,
                        size: widget.offerBadgeSize,
                        fontSize: widget.offerBadgeFontSize,
                        isRtl: language.isRtl,
                        isBestSellers: widget.isBestSellers,
                        isNewArrival: widget.isNewArrival,
                        discount: widget.price != null
                            ? (widget.pricePromo != null
                                ? AppUtil.calculateDiscount(
                                    widget.price!, widget.pricePromo!)
                                : (widget.pricePromoPercentage != null
                                    ? AppUtil.calculateDiscount(
                                        widget.price!,
                                        AppUtil.calculatePricePromo(
                                            widget.price!,
                                            widget.pricePromoPercentage!),
                                      )
                                    : 0))
                            : 0)),
                Align(
                        alignment: !language.isRtl
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: _buildProductActionsCard(
                          theme: theme,
                          isRtl: language.isRtl,
                          isVisible: widget.isActionsCardVisible,
                          productId: widget.productId,
                          isOnCart: widget.isOnCart,
                          isOnWishlist: widget.isOnWishlist,
                        )).animate(target: _toggleActionsWidget ? 1 : 0).fade(
                      duration: 300.ms,
                      curve: Curves.easeInOut,
                      begin: 0,
                      end: 1,
                    ),
              ],
            ),
          ),
          CustomField(
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: r.symmetric(horizontal: 4),
            isRtl: language.isRtl,
            children: [
              CustomButton(
                text: widget.author != null
                    ? '${widget.author!.firstName} ${widget.author!.lastName}'
                    : 'Anonymous Author',
                fontSize: widget.authorFontSize ?? r.size(12),
                fontWeight: FontWeight.bold,
                textColor: theme.accent,
                onHoverStyle: CustomButtonStyle(
                  textColor: theme.accent,
                ),
                onPressed: (position, size) {
                  if (widget.author != null && widget.onAuthorPressed != null) {
                    widget.onAuthorPressed!(widget.author!);
                  }
                },
              ),
              CustomText(
                maxWidth: widget.titleMaxWidth,
                text: widget.title ?? 'Title Not Provided',
                fontSize: widget.titleFontSize ?? r.size(12),
                color: theme.secondary,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              if (widget.isPriceVisible)
                CustomField(
                  mainAxisSize: MainAxisSize.min,
                  arrangement: FieldArrangement.row,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  gap: r.size(2),
                  children: [
                    CustomText(
                      text:
                          '${AppUtil.formatToTwoDecimalPlaces(widget.pricePromo ?? AppUtil.calculatePricePromo(widget.price ?? 0.0, widget.pricePromoPercentage ?? 0.0)).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
                      fontSize: widget.priceFontSize ?? r.size(14),
                      color: AppColors.colors.redRouge,
                      fontWeight: FontWeight.w900,
                    ),
                    if (widget.pricePromo != null ||
                        widget.pricePromoPercentage != null)
                      CustomText(
                        text:
                            '${AppUtil.formatToTwoDecimalPlaces(widget.price ?? 0.0).toString().replaceAll('.', ',')} ${AppUtil.returnTranslatedSymbol(ts, currency.code) ?? currency.symbol}',
                        textDecoration: TextDecoration.lineThrough,
                        textDecorationStyle: TextDecorationStyle.solid,
                        fontSize: widget.priceFontSize != null
                            ? (widget.priceFontSize! - r.size(4))
                            : r.size(8),
                        color: theme.accent,
                        textDecorationColor: theme.accent,
                        textDecorationThickness: r.size(0.8),
                        fontWeight: FontWeight.w900,
                      ),
                  ],
                ),
            ],
          ),
        ]);
  }
}
