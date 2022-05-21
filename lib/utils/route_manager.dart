import 'package:appointnet/screens/login/login_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class RouteManager {
  static MaterialPageRoute _noScreen() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
            body: Container(
                child: Center(
                    ))));
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    StatefulWidget screen;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    switch (settings.name) {
      case LoginComponent.tag:
        screen = LoginComponent();
        return ScaleRoute(page: screen, routeSettings: settings);   /// page animation
      default:
        return _noScreen();
    }
  }
}
