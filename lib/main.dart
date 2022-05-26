import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/login/login_component.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_component.dart';
import 'package:appointnet/screens/splash_screen/splash_component.dart';
import 'package:appointnet/screens/update_details/update_details_component.dart';
import 'package:appointnet/utils/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(),
      home: SplashComponent(),
        onGenerateRoute: RouteManager.generateRoute
    );
  }
}
