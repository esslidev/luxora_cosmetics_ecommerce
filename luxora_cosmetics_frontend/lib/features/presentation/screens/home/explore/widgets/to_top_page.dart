import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/util/app_util.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_paths.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/resources/language_model.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';
import '../../../../bloc/app/language/translation_bloc.dart';
import '../../../../bloc/app/language/translation_state.dart';
import '../../../../bloc/app/theme/theme_bloc.dart';
import '../../../../bloc/app/theme/theme_state.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_field.dart';

class ToTopPageWidget extends StatefulWidget {
  const ToTopPageWidget({super.key});

  @override
  State<ToTopPageWidget> createState() => _ToTopPageWidgetState();
}

class _ToTopPageWidgetState extends State<ToTopPageWidget> {
  late ResponsiveSizeAdapter r;

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
              return _buildToTopPage(
                  context,
                  themeState.theme,
                  translationState.translationService!,
                  translationState.language!);
            }
            return const SizedBox();
          },
        );
      },
    );
  }

  Widget _buildToTopPage(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      mainAxisSize: MainAxisSize.max,
      backgroundColor: theme.primary,
      arrangement: FieldArrangement.row,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: r.symmetric(vertical: 6),
      isRtl: language.isRtl,
      children: [
        Flexible(
          child: CustomButton(
            useIntrinsicWidth: false,
            svgIconPath: AppPaths.vectors.triangleTopIcon,
            iconColor: AppColors.colors.whiteSolid,
            iconHeight: r.size(8),
            text: ts.translate('screens.explore.toTopPage.topPage'),
            fontSize: r.size(14),
            letterSpacing: r.size(1),
            fontWeight: FontWeight.bold,
            textColor: AppColors.colors.whiteSolid,
            onPressed: (position, size) {
              AppUtil.scrollToTop(context);
            },
          ),
        ),
      ],
    );
  }
}
