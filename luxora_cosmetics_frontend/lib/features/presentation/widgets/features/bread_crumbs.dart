import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_paths.dart';
import '../../../../core/enums/widgets.dart';
import '../../../../core/resources/bread_crumb_model.dart';
import '../../../../core/util/app_events_util.dart';
import '../../../../core/util/responsive_size_adapter.dart';
import '../../bloc/app/bread_crumbs/bread_crumbs_bloc.dart';
import '../../bloc/app/bread_crumbs/bread_crumbs_state.dart';
import '../common/custom_button.dart';
import '../common/custom_display.dart';
import '../common/custom_field.dart';

class BreadCrumbs extends StatefulWidget {
  final BaseTheme theme;
  final double? fontSize;
  final bool isRtl;

  const BreadCrumbs({
    super.key,
    required this.theme,
    this.fontSize,
    required this.isRtl,
  });

  @override
  State<BreadCrumbs> createState() => _BreadCrumbsState();
}

class _BreadCrumbsState extends State<BreadCrumbs> {
  Widget _buildCustomButton({
    required ResponsiveSizeAdapter r,
    required String title,
    required double fontSize,
    Color? color,
    Color? onHoverColor,
    MouseCursor? cursor,
    VoidCallback? onPressed,
  }) {
    return CustomButton(
      text: title,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      textColor: color,
      cursor: cursor,
      onHoverStyle: CustomButtonStyle(textColor: onHoverColor),
      onPressed: (position, size) {
        if (onPressed != null) {
          onPressed();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveSizeAdapter r = ResponsiveSizeAdapter(context);

    return BlocBuilder<AppBreadCrumbsBloc, AppBreadCrumbsState>(
      builder: (context, breadCrumbsState) {
        List<BreadCrumbModel> breadCrumbs = breadCrumbsState.breadCrumbs ?? [];
        return breadCrumbs.isNotEmpty
            ? CustomField(
                crossAxisAlignment: CrossAxisAlignment.center,
                wrapHorizontalSpacing: r.size(6),
                wrapVerticalSpacing: r.size(6),
                isWrap: true,
                arrangement: FieldArrangement.row,
                isRtl: widget.isRtl,
                children: [
                  CustomDisplay(
                    assetPath: 'AppPaths.vectors.homeFillIcon',
                    isSvg: true,
                    width: r.size(8),
                    height: r.size(8),
                    cursor: SystemMouseCursors.click,
                    svgColor: widget.theme.accent.withValues(alpha: 0.7),
                    onTap: () {
                      Beamer.of(context)
                          .beamToNamed(AppPaths.routes.homePageScreen);
                    },
                  ),
                  CustomDisplay(
                    assetPath: !widget.isRtl
                        ? 'AppPaths.vectors.triangleRightIcon'
                        : 'AppPaths.vectors.triangleLeftIcon',
                    isSvg: true,
                    width: r.size(6),
                    height: r.size(6),
                    svgColor: widget.theme.accent.withValues(alpha: 0.3),
                  ),
                  ...breadCrumbs.asMap().entries.map((entry) {
                    int index = entry.key;
                    BreadCrumbModel breadCrumb = entry.value;
                    return CustomField(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      gap: r.size(6),
                      arrangement: FieldArrangement.row,
                      children: [
                        _buildCustomButton(
                          title: breadCrumb.name,
                          onPressed: () {
                            if ((breadCrumb.path != null) &&
                                index < (breadCrumbs.length - 1)) {
                              Beamer.of(context).beamToNamed(breadCrumb.path!);
                              AppEventsUtil.breadCrumbs.returnToBreadCrumb(
                                  context,
                                  id: breadCrumb.id);
                            }
                          },
                          cursor: ((breadCrumb.path != null) &&
                                  index < (breadCrumbs.length - 1))
                              ? SystemMouseCursors.click
                              : SystemMouseCursors.basic,
                          color: index == breadCrumbs.length - 1
                              ? widget.theme.secondary
                              : widget.theme.accent.withValues(alpha: 0.6),
                          onHoverColor: index == breadCrumbs.length - 1
                              ? widget.theme.primary
                              : widget.theme.accent.withValues(alpha: 0.8),
                          r: r,
                          fontSize: widget.fontSize ?? r.size(10),
                        ),
                        if (index < breadCrumbs.length - 1)
                          CustomDisplay(
                            assetPath: !widget.isRtl
                                ? 'AppPaths.vectors.triangleRightIcon'
                                : 'AppPaths.vectors.triangleLeftIcon',
                            isSvg: true,
                            width: r.size(6),
                            height: r.size(6),
                            svgColor:
                                widget.theme.accent.withValues(alpha: 0.3),
                          )
                      ],
                    );
                  })
                ],
              )
            : const SizedBox();
      },
    );
  }
}
