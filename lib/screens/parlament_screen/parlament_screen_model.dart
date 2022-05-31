import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/repositories/event_repository.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_view.dart';

import '../../models/event.dart';

class ParlamentScreenModel{

  Parlament parlament;
  ParlamentScreenView view;
  ParlamentScreenModel(this.view,this.parlament){
    loadAllData();
  }



  Future<void> loadAllData()async{
    await getParlamentEvents(); //.catchError((error)=> view.onError(error.toString()));
    view.onFinishedLoading();
  }


  Future<void> getParlamentEvents()async{
    String parlamentId = parlament.id as String;
    List<Event> events = await EventRepository(parlamentId: parlamentId).getParlamentEvents();
    view.gotAllEvents(events);
  }

  Future<void> addNewUserToParlament(String phone)async{
    String? error = await ParlamentsRepository().addUserToParlamentUsingPhone(parlament, phone);
    if(error!=null){
      view.onError(error);
    }
  }
}