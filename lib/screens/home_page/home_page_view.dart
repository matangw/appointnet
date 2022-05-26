import 'package:appointnet/models/user.dart';

abstract class HomePageView{

  void onFinishedLoading(AppointnetUser user);
  void onError(String error);
}