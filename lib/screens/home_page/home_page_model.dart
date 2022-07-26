import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/models/user.dart';
import 'package:appointnet/repositories/event_repository.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/repositories/user_repository.dart';
import 'package:appointnet/screens/home_page/home_page_view.dart';
import 'package:appointnet/utils/shared_reffrencess_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageModel{

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  ///user data
  late AppointnetUser user;
  List<Parlament> userParlaments = [];
  List<Event> userUpcomingEvents = [];

  late SharedPreferences sh;

  HomePageView view;
  HomePageModel(this.view){
    getUserData();
  }

  Future<void> getUserData() async{
    sh = await SharedPreferences.getInstance();
    getUserUpcomingEvents();
    AppointnetUser? user = await UserRepository().getUserData(auth.currentUser?.uid as String);
    if(user== null){
      view.onError('[-] USER NOT FOUND');
    }
    else{
      print('[+] FOUND USER');
      await getUserParlaments();
      this.user = user;
      view.onFinishedLoading();

      /// listen for every parlament topic
      NotificationSettings notificationSettings = await messaging.requestPermission();
      print('Auth notification status: '+notificationSettings.authorizationStatus.toString());
      for(var p in userParlaments){
        messaging.subscribeToTopic(p.id as String);
        print('[!] Subscribed to ${p.id as String}');
      }
     messaging.subscribeToTopic(user.id as String);
    }
  }

  Future<void> getUserParlaments()async{
    userParlaments = await ParlamentsRepository().getParlmanetsForUser(auth.currentUser?.uid as String);
    SharedPreferencesUtils().setUserParlamentsNumber(userParlaments.length);
  }

  Future<void> getUserUpcomingEvents()async{
    List<Event> events =await EventRepository(parlamentId: 'noEnd').upcomingUserEvents();
    userUpcomingEvents = events;
    view.onGotAllEvents();

  }

  Future<void> checkForRefresh()async{
    print('[!] FUNCTION EXECUTED');
    bool? needRefresh = await SharedPreferences.getInstance().then((value) => value.getBool('home_screen_update'));
    if(needRefresh==true){
      print('[!] NEED TO REFRESH');
      getUserUpcomingEvents();
      sh.setBool('home_screen_update', false);
    }
  }

  Future<void> subscribeToParlaments()async{
    for(var p in userParlaments){
      messaging.subscribeToTopic(p.id as String);
      print('[!] Subscribed to ${p.id as String}');
    }
  }
 }