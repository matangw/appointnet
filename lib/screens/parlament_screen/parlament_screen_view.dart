import '../../models/event.dart';

abstract class ParlamentScreenView{

  void onFinishedLoading();
  void gotAllEvents(List<Event> events);
  void successFeedBack(String message);
  void startAddingUserToParlament();
  void finishedAddingUserToParlament();
  void onError(String error);
}