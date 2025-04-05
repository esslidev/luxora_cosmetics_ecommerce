import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_colors.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/core/enums/widgets.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_button.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_text.dart';

import '../../../../../../../core/util/app_util.dart';
import '../../../../../../../core/util/responsive_size_adapter.dart';

class JoinUsGridItem {
  final String imagePath;
  final String instagramUrl;

  const JoinUsGridItem({required this.imagePath, required this.instagramUrl});
}

class JoinUsGrid extends StatefulWidget {
  final List<JoinUsGridItem> items;
  const JoinUsGrid({super.key, required this.items});

  @override
  State<JoinUsGrid> createState() => _JoinUsGridState();
}

class _JoinUsGridState extends State<JoinUsGrid> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
  }

  Widget _buildJoinUs({required JoinUsGridItem item}) {
    ValueNotifier<bool> isHoveredNotifier = ValueNotifier(false);
    return MouseRegion(
      onEnter: (event) {
        isHoveredNotifier.value = true;
      },
      onExit: (event) {
        isHoveredNotifier.value = false;
      },
      child: Stack(
        children: [
          CustomDisplay(
            assetPath: item.imagePath,
            fit: BoxFit.fill,
            width: r.size(140),
            height: r.size(140),
          ),
          ValueListenableBuilder(
            valueListenable: isHoveredNotifier,
            builder: (BuildContext context, bool isHovered, Widget? child) {
              return ClipRect(
                child: CustomField(
                      backgroundColor: AppColors.light.primary,
                      width: r.size(140),
                      height: r.size(140),
                      padding: r.all(4),
                      gap: r.size(8),
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomDisplay(
                          assetPath: AppPaths.vectors.instagramIcon,
                          svgColor: AppColors.colors.white,
                          isSvg: true,
                          width: r.size(20),
                          height: r.size(20),
                        ),
                        CustomText(
                          text:
                              'Rejoignez-nous et bénéficiez de tous les services que nous proposons.',
                          fontSize: r.size(8),
                          color: AppColors.colors.white,
                          textAlign: TextAlign.center,
                        ),
                        CustomButton(
                          width: r.size(24),
                          height: r.size(24),
                          svgIconPath: AppPaths.vectors.arrowToRightIcon,
                          iconWidth: r.size(12),
                          borderRadius: BorderRadius.circular(r.size(15)),
                          animationDuration: 200.ms,
                          onHoverStyle: CustomButtonStyle(
                            backgroundColor: AppColors.colors.lostInSadness,
                          ),
                          onPressed: (position, size) {
                            AppUtil.launchURL(item.instagramUrl);
                          },
                        ),
                      ],
                    )
                    .animate(target: isHovered == true ? 1 : 0)
                    .slideY(duration: 350.ms, curve: Curves.easeOut, begin: -1),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomField(
      mainAxisSize: MainAxisSize.min,
      gap: r.size(16),
      arrangement: FieldArrangement.row,
      children: [
        ...widget.items.map((item) {
          return _buildJoinUs(item: item);
        }),
      ],
    );
  }
}
