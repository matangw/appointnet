import 'package:appointnet/screens/add_friend_screen/add_friend_component.dart';
import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/login/login_component.dart';
import 'package:appointnet/screens/new_event_screen/new_event_component.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_component.dart';
import 'package:appointnet/screens/parlament_profile_screen/parlament_profile_component.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_component.dart';
import 'package:appointnet/screens/profile_screen/profile_screen_component.dart';
import 'package:appointnet/screens/splash_screen/splash_component.dart';
import 'package:appointnet/screens/update_details/update_details_component.dart';
import 'package:appointnet/utils/transitions/scale.dart';
import 'package:appointnet/utils/transitions/size.dart';
import 'package:appointnet/utils/transitions/slide_right.dart';
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
      case NewParlamentComponent.tag:
        screen = NewParlamentComponent();
        return ScaleRoute(page: screen, routeSettings: settings);
      case ParlamentScreenComponent.tag:
        screen = ParlamentScreenComponent();
        return ScaleRoute(page: screen, routeSettings: settings);
      case NewEventComponent.tag:
        screen = NewEventComponent();
        return SlideRightRoute(page: screen, routeSettings: settings);
      case SplashComponent.tag:
        screen = SplashComponent();
        return SlideRightRoute(page: screen, routeSettings: settings);
      case ProfileScreenComponent.tag:
        screen = ProfileScreenComponent();
        return SizeRoute(page: screen, routeSettings: settings);
      case ParlamentProfileComponent.tag:
        screen = ParlamentProfileComponent();
        return SlideRightRoute(page: screen,routeSettings: settings);
      default:
        return _noScreen();
    }
  }
}
