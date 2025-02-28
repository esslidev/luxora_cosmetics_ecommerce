import 'package:flutter/material.dart';
import 'package:luxora_cosmetics_frontend/core/constants/app_paths.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_display.dart';
import 'package:luxora_cosmetics_frontend/features/presentation/widgets/common/custom_field.dart';

import '../../../../../../core/util/responsive_screen_adapter.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';

class PromoVideos extends StatefulWidget {
  const PromoVideos({super.key});

  @override
  State<PromoVideos> createState() => _PromoVideosState();
}

class _PromoVideosState extends State<PromoVideos> {
  late ResponsiveSizeAdapter r;

  @override
  void initState() {
    r = ResponsiveSizeAdapter(context);
    super.initState();
  }

  //----------------------------------------------------------------------------------------------------//

  Widget _buildLoopingGifButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomDisplay(
          assetPath: AppPaths.animatedImages.promoVideosShortVideo,
          height: r.size(340),
          onPressed: () {},
        ),
        Align(
          alignment: Alignment.center,
          child: IgnorePointer(
            child: CustomDisplay(
              assetPath: AppPaths.vectors.promoVideosPlayButtonIcon,
              isSvg: true,
              height: r.size(40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoVideos(BuildContext context) {
    return CustomField(
      width: double.infinity,
      padding: r.symmetric(vertical: 60, horizontal: 20),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLoopingGifButton(),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreenAdapter(
      fallbackScreen: _buildPromoVideos(context),
    );
  }
}
