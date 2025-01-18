import '../../../../../core/resources/bread_crumb_model.dart';

abstract class AppBreadCrumbsEvent {
  const AppBreadCrumbsEvent();
}

class AddBreadCrumb extends AppBreadCrumbsEvent {
  final BreadCrumbModel breadCrumb;
  const AddBreadCrumb({required this.breadCrumb});
}

class ReturnToBreadCrumb extends AppBreadCrumbsEvent {
  final String id;

  const ReturnToBreadCrumb({required this.id});
}

class ClearBreadCrumbs extends AppBreadCrumbsEvent {
  const ClearBreadCrumbs();
}
