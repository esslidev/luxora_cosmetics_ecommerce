import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/enums/widgets.dart';
import '../../../../../../core/resources/global_contexts.dart';

import '../../../../../../core/resources/lite_notification_bar_model.dart';
import '../../../../../../core/util/app_events_util.dart';
import '../../../../../../core/util/responsive_size_adapter.dart';
import '../../../../../../locator.dart';
import '../../../../bloc/app/lite_notification/lite_notifications_bloc.dart';
import '../../../../bloc/app/lite_notification/lite_notifications_state.dart';
import '../../../../widgets/common/custom_button.dart';
import '../../../../widgets/common/custom_field.dart';
import '../../../../widgets/common/custom_text.dart';
import 'widgets/notification_bar.dart';

class LiteNotificationsWidget extends StatefulWidget {
  const LiteNotificationsWidget({super.key});

  @override
  State<LiteNotificationsWidget> createState() =>
      _LiteNotificationsWidgetState();
}

class _LiteNotificationsWidgetState extends State<LiteNotificationsWidget> {
  late ResponsiveSizeAdapter r;
  late BuildContext? homeContext;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    r = ResponsiveSizeAdapter(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeContext = locator<GlobalContexts>().homeContext;
    });
  }

  //----------------------------------------------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLiteNotificationsBloc, AppLiteNotificationsState>(
      builder: (context, liteNotificationsState) {
        return liteNotificationsState.liteNotifications != null &&
                liteNotificationsState.liteNotifications!.isNotEmpty
            ? _buildLiteNotifications(
                context: context,
                liteNotifications:
                    liteNotificationsState.liteNotifications ?? [],
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildHeader() {
    return CustomField(
      padding: r.symmetric(vertical: 4, horizontal: 4),
      arrangement: FieldArrangement.row,
      backgroundColor: AppColors.light.backgroundSecondary,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomField(
          gap: r.size(6),
          crossAxisAlignment: CrossAxisAlignment.center,
          arrangement: FieldArrangement.row,
          children: [
            CustomText(
              text: 'Notifications',
              fontSize: r.size(10),
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        CustomButton(
          text: 'Clear all',
          fontSize: r.size(8),
          padding: r.symmetric(vertical: 2, horizontal: 4),
          backgroundColor: AppColors.light.backgroundSecondary,
          borderRadius: BorderRadius.circular(r.size(1)),
          onPressed: (position, size) {
            AppEventsUtil.liteNotifications.clearLiteNotifications(context);
          },
        ),
      ],
    );
  }

  Widget _buildLiteNotifications({
    required BuildContext context,
    required List<LiteNotificationModel> liteNotifications,
  }) {
    return CustomField(
      width: r.size(200),
      gap: r.size(4),
      padding: r.all(4),
      borderRadius: r.size(3),
      borderWidth: r.size(1),
      borderColor: AppColors.light.accent.withValues(alpha: .4),
      shadowOffset: Offset(r.size(2), r.size(2)),
      shadowBlurRadius: 4,
      shadowColor: AppColors.light.accent.withValues(alpha: .2),
      backgroundColor: AppColors.light.backgroundPrimary,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: r.size(200), // Maximum height
          ),
          child: RawScrollbar(
            thumbColor: AppColors.light.primary.withValues(alpha: .4),
            radius: Radius.circular(r.size(10)),
            thickness: r.size(5),
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: liteNotifications.length,
              reverse: true,
              shrinkWrap: true, // Ensure it respects the constraints
              itemBuilder: (context, index) {
                final liteNotification = liteNotifications[index];
                return Padding(
                  padding: r.symmetric(vertical: r.size(1)),
                  child: NotificationBar(
                    key: ValueKey(liteNotification.id),
                    liteNotification: liteNotification,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
