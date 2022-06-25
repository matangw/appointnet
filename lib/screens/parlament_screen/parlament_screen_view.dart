import '../../models/event.dart';

abstract class ParlamentScreenView{

  void onFinishedLoading();
  void gotUpcomingEvents(List<Event> events);
  void successFeedBack(String message);
  void startAddingUserToParlament();
  void finishedAddingUserToParlament();
  void finishedLoadingUsers();
  void onError(String error);
}