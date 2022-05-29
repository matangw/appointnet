import 'package:appointnet/models/parlament.dart';
import 'package:uuid/uuid.dart';

class Event{

  String? id;
  DateTime date;
  String location;
  List<String> attendingsIds;

  Event({required this.date,required this.location,required this.attendingsIds, this.id,}){
    id??= Uuid().v4();
    attendingsIds??= [];
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'date': date,
      'location': location,
      'attendings': attendingsIds
    };
  }


  factory Event.fromJson(Map<String,dynamic> json){
    return Event(
        id: json['id'],
        date: DateTime.parse(json['date']),
        location: json['location'],
        attendingsIds: json['attendings'] == null ? [] : json['attendings']?.cast<String>(),
    );
  }

}