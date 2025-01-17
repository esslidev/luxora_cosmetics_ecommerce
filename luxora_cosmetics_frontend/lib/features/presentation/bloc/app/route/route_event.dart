abstract class AppRouteEvent {
  const AppRouteEvent();
}

class ChangePath extends AppRouteEvent {
  final String newPath;

  const ChangePath(this.newPath);
}
