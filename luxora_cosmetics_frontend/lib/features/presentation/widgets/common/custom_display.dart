import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import 'custom_field.dart';

class CustomDisplay extends StatefulWidget {
  final String assetPath;
  final bool isSvg;
  final Color? svgColor;
  final bool isNetwork;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final BoxFit? fit;
  final Border? border;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Function()? onPressed;
  final Function()? onHoverEnter;
  final Function()? onHoverExit;
  final Widget? placeholderWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const CustomDisplay({
    super.key,
    required this.assetPath,
    this.isSvg = false,
    this.svgColor,
    this.isNetwork = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.fit,
    this.border,
    this.borderRadius = BorderRadius.zero,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.onPressed,
    this.onHoverEnter,
    this.onHoverExit,
    this.placeholderWidget,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<CustomDisplay> createState() => _CustomDisplayState();
}

class _CustomDisplayState extends State<CustomDisplay> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  Widget _buildCustomDisplay() {
    return widget.isSvg
        ? widget.isNetwork
            ? SvgPicture.network(
              widget.assetPath,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.contain,
              colorFilter:
                  widget.svgColor != null
                      ? ColorFilter.mode(widget.svgColor!, BlendMode.srcIn)
                      : null,
              placeholderBuilder:
                  widget.loadingWidget != null
                      ? (context) => widget.loadingWidget!
                      : null,
            )
            : SvgPicture.asset(
              widget.assetPath,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.contain,
              colorFilter:
                  widget.svgColor != null
                      ? ColorFilter.mode(widget.svgColor!, BlendMode.srcIn)
                      : null,
              placeholderBuilder:
                  widget.placeholderWidget != null
                      ? (context) => widget.placeholderWidget!
                      : null,
            )
        : widget.isNetwork
        ? Image.network(
          widget.assetPath,
          width: widget.width,
          height: widget.height,
          fit: widget.fit ?? BoxFit.contain,
          loadingBuilder:
              widget.loadingWidget != null
                  ? (context, child, loadingProgress) => widget.loadingWidget!
                  : null,
          errorBuilder:
              (context, error, stackTrace) =>
                  widget.errorWidget ??
                  Icon(
                    Icons.error,
                    size: r.size(40),
                    color: AppColors.light.error,
                  ),
        )
        : Image.asset(
          widget.assetPath,
          width: widget.width,
          height: widget.height,
          fit: widget.fit ?? BoxFit.contain,
          errorBuilder:
              (context, error, stackTrace) =>
                  widget.errorWidget ??
                  Icon(
                    Icons.error,
                    size: r.size(40),
                    color: AppColors.light.error,
                  ),
        );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      onEnter: (event) {
        if (widget.onHoverEnter != null) {
          widget.onHoverEnter!();
        }
      },
      onExit: (event) {
        if (widget.onHoverExit != null) {
          widget.onHoverExit!();
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onPressed != null) {
            widget.onPressed!();
          }
        },
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: CustomField(
            mainAxisSize: MainAxisSize.min,
            backgroundColor: widget.backgroundColor,
            padding: widget.padding,
            margin: widget.margin,
            border: widget.border,
            children: [_buildCustomDisplay()],
          ),
        ),
      ),
    );
  }
}
