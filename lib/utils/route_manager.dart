import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/login/login_component.dart';
import 'package:appointnet/screens/update_details/update_details_component.dart';
import 'package:appointnet/utils/transitions/scale.dart';
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
      case UpdateDetailsComponent.tag:
        screen = UpdateDetailsComponent();
        return ScaleRoute(page: screen, routeSettings: settings);
      case HomePageComponent.tag:
        screen = HomePageComponent();
        return ScaleRoute(page: screen, routeSettings: settings);   /// page animation/// page animation
      default:
        return _noScreen();
    }
  }
}
