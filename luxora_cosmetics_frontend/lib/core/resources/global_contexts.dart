import 'package:flutter/widgets.dart';

class GlobalContexts {
  BuildContext? homeContext;

  void setHomeContext(BuildContext context) {
    homeContext = context;
  }

  //you can add other contexts here if you're using nested beamer routing.
}
