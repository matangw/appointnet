import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/user.dart';

abstract class HomePageView{
  void onFinishedLoading();
  void onError(String error);
  void onGotAllEvents();
  void eventPressed(Event event);
  void gotLocalData();
}