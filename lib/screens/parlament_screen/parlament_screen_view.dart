import '../../models/event.dart';

abstract class ParlamentScreenView{

  void onFinishedLoading();
  void gotAllEvents(List<Event> events);
  void onError(String error);
}