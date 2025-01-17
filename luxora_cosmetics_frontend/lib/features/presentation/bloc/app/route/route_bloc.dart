import 'package:flutter_bloc/flutter_bloc.dart';

import 'route_event.dart';
import 'route_state.dart';

class AppRouteBloc extends Bloc<AppRouteEvent, AppRouteState> {
  AppRouteBloc() : super(const AppRouteInitial()) {
    on<ChangePath>(onChangePath);
  }

  void onChangePath(ChangePath event, Emitter<AppRouteState> emit) async {
    emit(const AppRouteInitial());
    emit(AppRoutePathChanged(event.newPath));
  }
}
