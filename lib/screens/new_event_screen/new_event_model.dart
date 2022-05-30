import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/repositories/event_repository.dart';
import 'package:appointnet/screens/new_event_screen/new_event_view.dart';
import 'package:flutter/material.dart';

class NewEventModel{

  NewEventView view;
  late Parlament parlament;

  NewEventModel(this.view);

  String? submitError(DateTime? dateTime,TimeOfDay? timeOfDay,String location){
    if(dateTime==null){return 'Please choose a date.';}
    else if(timeOfDay==null) {return 'Please choose a time';}
    else if(location.isEmpty) { return 'Please enter a location';}
  }

  Future<void> uploadEvent(DateTime dateTime,TimeOfDay timeOfDay,String location)async{
    Event event = Event(date: dateTime, time: timeOfDay, location: location, attendingsIds: [],invitedIds: parlament.usersId);
    view.startedUploading();
    bool success = await EventRepository(parlamentId:parlament.id as String).updateEvent(event).catchError((error)=>print(error));
    if(success){
      print('[+] UPLOAD SUCCESSFUL');
      view.onComplete();
    }
    else
      {view.onError('Something went wrong');}
  }


}