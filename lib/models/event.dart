import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Event {
  String? id;
  DateTime date;
  TimeOfDay time;
  String location;
  String parlamentImage;
  List<String> attendingsIds;
  List<String> changesStatusIds;
  List<String> invitedIds;

  Event({
    required this.parlamentImage,
    required this.date,
    required this.time,
    required this.location,
    required this.attendingsIds,
    required this.invitedIds,
    required this.changesStatusIds,
    this.id,
  }) {
    id ??= Uuid().v4();
    date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toString(),
      'location': location,
      'attendings': attendingsIds,
      'invited': invitedIds,
      'changedStatus': changesStatusIds,
      'parlamentImage': parlamentImage
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        date: DateTime.parse(json['date']),
        time: TimeOfDay.fromDateTime(DateTime.parse(json['date'])),
        location: json['location'],
        changesStatusIds: json['changedStatus'] == null
            ? []
            : json['changedStatus']?.cast<String>(),
        attendingsIds: json['attendings'] == null
            ? []
            : json['attendings']?.cast<String>(),
        invitedIds:
            json['invited'] == null ? [] : json['invited']?.cast<String>(),
        parlamentImage: json['parlamentImage']);
  }
}
