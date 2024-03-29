import '../../models/event.dart';

abstract class ParlamentScreenView{

  void onFinishedLoading();
  void onLocalDataLoad();
  void gotUpcomingEvents(List<Event> events);
  void successFeedBack(String message);
  void startAddingUserToParlament();
  void finishedAddingUserToParlament(bool success);
  void finishedLoadingUsers();
  void onError(String error);
  void deleteEvent(Event event);
}