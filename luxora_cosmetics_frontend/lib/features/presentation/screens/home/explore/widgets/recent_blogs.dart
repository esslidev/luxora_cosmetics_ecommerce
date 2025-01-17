import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librairie_alfia/core/constants/app_paths.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_button.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_display.dart';
import 'package:librairie_alfia/features/presentation/widgets/common/custom_shrinking_line.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/resources/language_model.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../core/util/translation_service.dart';
import '../../../../bloc/app/language/translation_bloc.dart';
import '../../../../bloc/app/language/translation_state.dart';
import '../../../../bloc/app/theme/theme_bloc.dart';
import '../../../../bloc/app/theme/theme_state.dart';
import '../../../../widgets/common/custom_field.dart';
import '../../../../widgets/common/custom_text.dart';

class RecentBlogsWidget extends StatefulWidget {
  const RecentBlogsWidget({super.key});

  @override
  State<RecentBlogsWidget> createState() => _AuthorOfMonthWidgetState();
}

class _AuthorOfMonthWidgetState extends State<RecentBlogsWidget> {
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
              return _buildRecentBlogs(
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

  Widget _buildRecentBlogCard(
      {required BaseTheme theme,
      required TranslationService ts,
      required bool isRtl,
      required String blogAssetNetwork,
      required String title,
      required String nameLatin,
      required String nameArabic,
      required String date,
      required String topicBrief}) {
    return CustomField(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        backgroundColor: theme.secondaryBackgroundColor,
        width: r.size(260),
        mainAxisSize: MainAxisSize.min,
        isRtl: isRtl,
        children: [
          CustomDisplay(
            assetPath: blogAssetNetwork,
            width: double.infinity,
            height: r.size(150),
            fit: BoxFit.cover,
          ),
          CustomField(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: r.all(16),
            gap: r.size(10),
            isRtl: isRtl,
            children: [
              CustomField(
                isRtl: isRtl,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                gap: r.size(6),
                children: [
                  CustomText(
                    text: title,
                    fontFamily: 'cairo',
                    fontSize: r.size(16),
                    fontWeight: FontWeight.bold,
                    textDirection: TextDirection.rtl,
                  ),
                  CustomField(
                      arrangement: FieldArrangement.row,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      gap: r.size(4),
                      children: [
                        CustomText(
                          text: date,
                          fontFamily: 'cairo',
                          fontSize: r.size(8),
                          fontWeight: FontWeight.bold,
                          textDirection: TextDirection.rtl,
                        ),
                        CustomShrinkingLine(
                          size: r.size(10),
                          thickness: r.size(1),
                          color: theme.accent.withOpacity(0.8),
                          isVertical: true,
                        ),
                        CustomText(
                          text: '$nameArabic - $nameLatin',
                          fontFamily: 'cairo',
                          fontSize: r.size(10),
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                          textDirection: TextDirection.rtl,
                        ),
                      ])
                ],
              ),
              CustomText(
                text: topicBrief,
                fontFamily: 'cairo',
                selectable: true,
                fontSize: r.size(10),
                textAlign: TextAlign.justify,
                lineHeight: 2,
                fontWeight: FontWeight.w600,
                textDirection: TextDirection.rtl,
              ),
              CustomButton(
                text: ts.translate('screens.explore.recentBlogs.readMore'),
                textColor: AppColors.colors.blueYankees,
                fontSize: r.size(12),
                fontWeight: FontWeight.bold,
                backgroundColor: AppColors.colors.yellowHoneyGlow,
                padding: EdgeInsets.symmetric(
                    vertical: r.size(4), horizontal: r.size(10)),
                borderRadius: BorderRadius.circular(r.size(4)),
              )
            ],
          ),
        ]);
  }

  Widget _buildRecentBlogs(BuildContext context, BaseTheme theme,
      TranslationService ts, LanguageModel language) {
    return CustomField(
      width: double.infinity,
      gap: r.size(20),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      isRtl: language.isRtl,
      children: [
        CustomField(
          mainAxisSize: MainAxisSize.min,
          gap: r.size(4),
          isRtl: language.isRtl,
          arrangement: FieldArrangement.row,
          children: [
            CustomText(
              text: ts.translate('screens.explore.recentBlogs.title1'),
              fontSize: r.size(20),
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: ts.translate('screens.explore.recentBlogs.title2'),
              fontSize: r.size(20),
              fontWeight: FontWeight.bold,
              color: AppColors.colors.yellowHoneyGlow,
            ),
          ],
        ),
        CustomField(
            arrangement: FieldArrangement.row,
            isRtl: language.isRtl,
            width: double.infinity,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            isWrap: true,
            wrapHorizontalSpacing: r.size(14),
            wrapVerticalSpacing: r.size(14),
            children: [
              _buildRecentBlogCard(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
                blogAssetNetwork: AppPaths.images.post1Example,
                title: 'البيبليوثرابيا - العلاج بالقراءة',
                nameLatin: 'OUHSINE HAJAR',
                nameArabic: 'هاجر أوحسين',
                date: '30/12/2021',
                topicBrief:
                    'كما يقال القراءة من أكثر العمليات الطبيعية في هذاالكون. نتواصل كل يوم مع بعضنا البعض، فلما ال نعتبرالقراءة كذلك عملية تواصل مع شخص آخر غير متواجدأمامنا. عملية أعمق بكثير ...',
              ),
              _buildRecentBlogCard(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
                blogAssetNetwork: AppPaths.images.post2Example,
                title: 'البيبليوثرابيا - العلاج بالقراءة',
                nameLatin: 'OUHSINE HAJAR',
                nameArabic: 'هاجر أوحسين',
                date: '30/12/2021',
                topicBrief:
                    'كما يقال القراءة من أكثر العمليات الطبيعية في هذاالكون. نتواصل كل يوم مع بعضنا البعض، فلما ال نعتبرالقراءة كذلك عملية تواصل مع شخص آخر غير متواجدأمامنا. عملية أعمق بكثير ...',
              ),
              _buildRecentBlogCard(
                theme: theme,
                ts: ts,
                isRtl: language.isRtl,
                blogAssetNetwork: AppPaths.images.post3Example,
                title: 'البيبليوثرابيا - العلاج بالقراءة',
                nameLatin: 'OUHSINE HAJAR',
                nameArabic: 'هاجر أوحسين',
                date: '30/12/2021',
                topicBrief:
                    'كما يقال القراءة من أكثر العمليات الطبيعية في هذاالكون. نتواصل كل يوم مع بعضنا البعض، فلما ال نعتبرالقراءة كذلك عملية تواصل مع شخص آخر غير متواجدأمامنا. عملية أعمق بكثير ...',
              ),
            ])
      ],
    );
  }
}
