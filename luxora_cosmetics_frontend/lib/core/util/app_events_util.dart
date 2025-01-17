import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/presentation/bloc/app/bread_crumbs/bread_crumbs_bloc.dart';
import '../../features/presentation/bloc/app/bread_crumbs/bread_crumbs_event.dart';
import '../../features/presentation/bloc/app/lite_notification/lite_notifications_bloc.dart';
import '../../features/presentation/bloc/app/lite_notification/lite_notifications_event.dart';
import '../../features/presentation/bloc/app/route/route_bloc.dart';
import '../../features/presentation/bloc/app/route/route_event.dart';
import '../resources/bread_crumb_model.dart';
import '../resources/lite_notification_bar_model.dart';

class AppEventsUtil {
  static RouteEvents get routeEvents => RouteEvents();
  static LiteNotificationsEvents get liteNotifications =>
      LiteNotificationsEvents();
  static BreadCrumbsEvents get breadCrumbs => BreadCrumbsEvents();
}

class RouteEvents {
  void changePath(BuildContext context, String newPath) {
    context.read<AppRouteBloc>().add(ChangePath(newPath));
  }
}

class LiteNotificationsEvents {
  void addLiteNotification(BuildContext context,
      {required LiteNotificationModel notification}) {
    context
        .read<AppLiteNotificationsBloc>()
        .add(AddLiteNotification(notification: notification));
  }

  void removeLiteNotification(BuildContext context, {required String id}) {
    context
        .read<AppLiteNotificationsBloc>()
        .add(RemoveLiteNotification(id: id));
  }

  void clearLiteNotifications(BuildContext context) {
    context
        .read<AppLiteNotificationsBloc>()
        .add(const ClearLiteNotifications());
  }
}

class BreadCrumbsEvents {
  void addBreadCrumb(BuildContext context,
      {required BreadCrumbModel breadCrumb}) {
    context
        .read<AppBreadCrumbsBloc>()
        .add(AddBreadCrumb(breadCrumb: breadCrumb));
  }

  void returnToBreadCrumb(BuildContext context, {required String id}) {
    context.read<AppBreadCrumbsBloc>().add(ReturnToBreadCrumb(id: id));
  }

  void clearBreadCrumbs(BuildContext context) {
    context.read<AppBreadCrumbsBloc>().add(const ClearBreadCrumbs());
  }
}
