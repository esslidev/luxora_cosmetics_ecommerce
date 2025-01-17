import 'package:equatable/equatable.dart';
import 'package:librairie_alfia/core/resources/bread_crumb_model.dart';

abstract class AppBreadCrumbsState extends Equatable {
  final List<BreadCrumbModel>? breadCrumbs;
  const AppBreadCrumbsState({this.breadCrumbs});

  @override
  List<Object?> get props => [breadCrumbs];
}

class AppBreadCrumbsInitial extends AppBreadCrumbsState {
  const AppBreadCrumbsInitial({super.breadCrumbs});
}

class AppBreadCrumbAdded extends AppBreadCrumbsState {
  const AppBreadCrumbAdded({required super.breadCrumbs});
}

class AppBreadCrumbReturned extends AppBreadCrumbsState {
  const AppBreadCrumbReturned({required super.breadCrumbs});
}

class AppBreadCrumbsCleared extends AppBreadCrumbsState {
  const AppBreadCrumbsCleared() : super(breadCrumbs: const []);
}
