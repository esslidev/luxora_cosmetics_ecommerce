import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/bread_crumb_model.dart';
import 'bread_crumbs_event.dart';
import 'bread_crumbs_state.dart';

class AppBreadCrumbsBloc
    extends Bloc<AppBreadCrumbsEvent, AppBreadCrumbsState> {
  AppBreadCrumbsBloc() : super(const AppBreadCrumbsInitial(breadCrumbs: [])) {
    on<AddBreadCrumb>(_onAddBreadCrumb);
    on<ReturnToBreadCrumb>(_onReturnToBreadCrumb);
    on<ClearBreadCrumbs>(_onClearBreadCrumbs);
  }

  void _onAddBreadCrumb(
      AddBreadCrumb event, Emitter<AppBreadCrumbsState> emit) {
    final List<BreadCrumbModel> updatedList = List.of(state.breadCrumbs ?? []);

    // Check if the last breadcrumb's name and path are the same as the new one
    if (updatedList.isEmpty ||
        updatedList.last.name != event.breadCrumb.name ||
        updatedList.last.path != event.breadCrumb.path) {
      updatedList.add(event.breadCrumb);
      emit(AppBreadCrumbAdded(breadCrumbs: updatedList));
    }
  }

  void _onReturnToBreadCrumb(
      ReturnToBreadCrumb event, Emitter<AppBreadCrumbsState> emit) {
    final List<BreadCrumbModel> updatedList = List.of(state.breadCrumbs ?? []);

    final targetIndex =
        updatedList.indexWhere((breadCrumb) => breadCrumb.id == event.id);

    if (targetIndex != -1) {
      updatedList.removeRange(targetIndex + 1, updatedList.length);
      emit(AppBreadCrumbReturned(breadCrumbs: updatedList));
    }
  }

  void _onClearBreadCrumbs(
      ClearBreadCrumbs event, Emitter<AppBreadCrumbsState> emit) {
    emit(const AppBreadCrumbsCleared());
  }
}
