import 'package:equatable/equatable.dart';

abstract class AppRouteState extends Equatable {
  final String? path;
  const AppRouteState({this.path});

  @override
  List<Object> get props => [path ?? ''];
}

class AppRouteInitial extends AppRouteState {
  const AppRouteInitial();
}

class AppRoutePathChanged extends AppRouteState {
  const AppRoutePathChanged(String path) : super(path: path);
}
