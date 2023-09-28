import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/repositories/event_repository.dart';
import 'package:appointnet/repositories/notification_repository.dart';
import 'package:appointnet/screens/new_event_screen/new_event_view.dart';
import 'package:flutter/material.dart';

class NewEventModel {
  NewEventView view;
  late Parlament parlament;

  NewEventModel(this.view);

  String? submitError(
      DateTime? dateTime, TimeOfDay? timeOfDay, String location) {
    if (dateTime == null) {
      return 'Please choose a date.';
    } else if (timeOfDay == null) {
      return 'Please choose a time';
    } else if (location.isEmpty) {
      return 'Please enter a location';
    }
    return null;
  }

  Future<void> uploadEvent(
      DateTime dateTime, TimeOfDay timeOfDay, String location) async {
    Event event = Event(
        parlamentImage: parlament.imageUrl as String,
        date: dateTime,
        time: timeOfDay,
        location: location,
        attendingsIds: [],
        changesStatusIds: [],
        invitedIds: parlament.usersId);
    view.startedUploading();
    bool success = await EventRepository(parlamentId: parlament.id as String)
        .updateEvent(event)
        .catchError((error) => false);
    if (success) {
      print('[+] UPLOAD SUCCESSFUL');
      NotificationRepository().createNotification(parlament.id as String,
          parlament.name, 'New event added for ${parlament.name}!');
      view.onComplete();
    } else {
      view.onError('Something went wrong');
    }
  }
}
