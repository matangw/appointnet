import 'package:appointnet/models/user.dart';

abstract class HomePageView{
  void onFinishedLoading();
  void onError(String error);
}