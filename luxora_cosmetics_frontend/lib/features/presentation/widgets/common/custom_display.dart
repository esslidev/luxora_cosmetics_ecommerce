import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';

class CustomDisplay extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isSvg;
  final bool isNetwork;
  final double borderWidth;
  final Color borderColor;
  final EdgeInsets borderPadding;
  final EdgeInsetsGeometry margin;
  final bool inFront;
  final VoidCallback? onTap;
  final Color? svgColor;
  final MouseCursor? cursor;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const CustomDisplay({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.isSvg = false,
    this.isNetwork = false,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.borderPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.inFront = false,
    this.onTap,
    this.svgColor,
    this.cursor,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);
    final double effectiveWidth = width ?? 100;
    final double effectiveHeight = height ?? 100;

    final borderSizeWidth =
        effectiveWidth + borderPadding.left + borderPadding.right;
    final borderSizeHeight =
        effectiveHeight + borderPadding.top + borderPadding.bottom;

    return MouseRegion(
      cursor: cursor ?? SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (!inFront)
              Container(
                margin: margin,
                width: borderSizeWidth,
                height: borderSizeHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth,
                  ),
                ),
              ),
            _buildImageWidget(r),
            if (inFront)
              Positioned(
                top: -borderPadding.top,
                left: -borderPadding.left,
                child: Container(
                  width: borderSizeWidth,
                  height: borderSizeHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor,
                      width: borderWidth,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(ResponsiveSizeAdapter r) {
    if (isSvg) {
      return isNetwork
          ? SvgPicture.network(
              assetPath,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              colorFilter: svgColor != null
                  ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                  : null,
              placeholderBuilder: (context) =>
                  loadingWidget ?? const SizedBox(),
            )
          : SvgPicture.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              colorFilter: svgColor != null
                  ? ColorFilter.mode(svgColor!, BlendMode.srcIn)
                  : null,
              placeholderBuilder: (context) =>
                  loadingWidget ?? const SizedBox(),
            );
    } else {
      return isNetwork
          ? Image.network(
              assetPath,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return loadingWidget ?? const SizedBox();
              },
              errorBuilder: (context, error, stackTrace) =>
                  errorWidget ??
                  Icon(Icons.error,
                      size: r.size(40), color: AppColors.light.errorColor),
            )
          : Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit ?? BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  errorWidget ??
                  Icon(Icons.error,
                      size: r.size(40), color: AppColors.light.errorColor),
            );
    }
  }
}
