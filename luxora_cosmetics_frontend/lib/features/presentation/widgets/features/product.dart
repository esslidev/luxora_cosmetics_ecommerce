import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/app_util.dart';
import '../../../../core/util/responsive_size_adapter.dart';

import '../common/custom_button.dart';
import '../common/custom_display.dart';
import '../common/custom_field.dart';
import '../common/custom_text.dart';

class ProductWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double? pricePromo;
  final bool isNewArrival;
  final bool isBestSellers;
  final bool isOnWishlist;
  final bool isOnCart;
  // action callbacks
  final Function() onPressed;
  final Function()? onWishlistPressed;
  final Function()? onCartPressed;

  const ProductWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.pricePromo,
    this.isNewArrival = false,
    this.isBestSellers = false,
    this.isOnWishlist = false,
    this.isOnCart = false,
    required this.onPressed,
    this.onWishlistPressed,
    this.onCartPressed,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late ResponsiveSizeAdapter r;

  ValueNotifier<bool> isHoveredNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildActionButton({
    required String svgPath,
    bool isActive = true,
    required Function() onPressed,
    required Function() onHoverEnter,
    required Function() onHoverExit,
  }) {
    return CustomButton(
      width: r.size(24),
      height: r.size(24),
      svgIconPath: svgPath,
      iconWidth: r.size(10),
      iconHeight: r.size(10),
      iconColor: AppColors.light.secondary,
      border: Border.all(color: AppColors.light.primary, width: r.size(1)),
      borderRadius: BorderRadius.circular(r.size(15)),
      animationDuration: 300.ms,
      onHoverStyle: CustomButtonStyle(
        iconColor: AppColors.colors.white,
        backgroundColor: AppColors.light.primary,
      ),
      onHoverEnter: (position, size) {
        onHoverEnter();
      },
      onHoverExit: () {
        onHoverExit();
      },
      onPressed: (position, size) {
        onPressed();
      },
    );
  }

  Widget _buildActionButtons({
    required Function() onHoverEnter,
    required Function() onHoverExit,
  }) {
    return CustomField(
      mainAxisSize: MainAxisSize.min,
      gap: r.size(2),
      children: [
        _buildActionButton(
          svgPath: AppPaths.vectors.cartIcon,
          isActive: widget.isOnCart,
          onHoverEnter: () {
            onHoverEnter();
          },
          onHoverExit: () {
            onHoverExit();
          },
          onPressed: () {
            if (widget.onCartPressed != null) {
              widget.onCartPressed!();
            }
          },
        ),
        _buildActionButton(
          svgPath: AppPaths.vectors.wishlistIcon,
          isActive: widget.isOnWishlist,
          onHoverEnter: () {
            onHoverEnter();
          },
          onHoverExit: () {
            onHoverExit();
          },
          onPressed: () {
            if (widget.onWishlistPressed != null) {
              widget.onWishlistPressed!();
            }
          },
        ),
      ],
    );
  }

  Widget _buildOfferTag() {
    return widget.isNewArrival == true || widget.isBestSellers == true
        ? IgnorePointer(
          ignoring: true,
          child: CustomText(
            backgroundColor:
                widget.isBestSellers == true
                    ? AppColors.colors.peachOfMind.withValues(alpha: .2)
                    : AppColors.light.backgroundSecondary,
            text:
                widget.isBestSellers == true
                    ? 'Meilleure Vente'
                    : widget.isNewArrival == true
                    ? 'Nouvelle Arrivée'
                    : '',
            fontSize: r.size(8),
            borderRadius: r.size(1),
            fontWeight: FontWeight.w600,
            color: AppColors.light.accent.withValues(alpha: .6),
            padding: r.symmetric(horizontal: 6, vertical: 2),
          ),
        )
        : const SizedBox();
  }

  /* Widget _buildNoCover({
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
*/
  Widget _buildProduct(BuildContext context) {
    return CustomField(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      width: r.size(180),
      gap: r.size(8),
      children: [
        ValueListenableBuilder(
          valueListenable: isHoveredNotifier,
          builder: (BuildContext context, bool isHovered, Widget? child) {
            return ClipRect(
              child: Stack(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (event) {
                      isHoveredNotifier.value = true;
                    },
                    onExit: (event) {
                      isHoveredNotifier.value = false;
                    },
                    child: GestureDetector(
                      onTap: () {
                        widget.onPressed();
                      },
                      child: CustomField(
                        width: r.size(180),
                        height: r.size(180),
                        backgroundColor: AppColors.colors.white,
                        children: [
                          IgnorePointer(
                            child: CustomDisplay(
                                  assetPath: widget.imageUrl,
                                  width: r.size(180),
                                  height: r.size(180),
                                )
                                .animate(target: isHovered == true ? 1 : 0)
                                .scaleXY(
                                  duration: 250.ms,
                                  curve: Curves.easeOut,
                                  begin: 1,
                                  end: 1.1,
                                )
                                .rotate(
                                  duration: 250.ms,
                                  curve: Curves.easeOut,
                                  begin: 1,
                                  end: 1.02,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: r.size(4),
                    left: r.size(4),
                    child: _buildOfferTag()
                        .animate(target: isHovered == true ? 1 : 0)
                        .fadeIn(
                          duration: 250.ms,
                          curve: Curves.easeOut,
                          begin: 0,
                        ),
                  ),
                  Positioned(
                    bottom: r.size(8),
                    right: r.size(8),
                    child: _buildActionButtons(
                          onHoverEnter: () {
                            isHoveredNotifier.value = true;
                          },
                          onHoverExit: () {
                            isHoveredNotifier.value = false;
                          },
                        )
                        .animate(target: isHovered == true ? 1 : 0)
                        .slideY(
                          duration: 400.ms,
                          curve: Curves.easeOut,
                          begin: 1.5,
                          end: 0,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
        CustomField(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          gap: r.size(6),
          padding: r.symmetric(horizontal: 4),
          children: [
            CustomText(
              text: widget.name,
              fontFamily: 'recoleta',
              fontSize: r.size(11),
              lineHeight: 1.1,
              textAlign: TextAlign.center,
              color: AppColors.light.accent,
            ),
            CustomField(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              gap: r.size(3),
              arrangement: FieldArrangement.row,
              children: [
                CustomText(
                  text:
                      '${AppUtil.formatToTwoDecimalPlaces(widget.pricePromo ?? widget.price).toString().replaceAll('.', ',')} Dhs',
                  fontSize: r.size(8),
                  color: AppColors.light.accent.withValues(alpha: .6),
                  fontWeight: FontWeight.w600,
                  lineHeight: 1,
                ),
                if (widget.pricePromo != null)
                  CustomText(
                    text:
                        '${AppUtil.formatToTwoDecimalPlaces(widget.price).toString().replaceAll('.', ',')} Dhs',
                    fontSize: r.size(7),
                    fontWeight: FontWeight.w600,
                    lineHeight: 0.6,
                    color: AppColors.light.secondary,
                    textDecoration: TextDecoration.lineThrough,
                    textDecorationStyle: TextDecorationStyle.solid,
                    textDecorationColor: AppColors.light.secondary,
                    textDecorationThickness: r.size(0.8),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /* Widget _buildProduct({
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
*/
  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return _buildProduct(context);
  }
}
