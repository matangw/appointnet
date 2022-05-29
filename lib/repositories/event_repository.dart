import 'package:appointnet/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventRepository{

  String parlamentId;
  late CollectionReference _eventCollection;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EventRepository({required this.parlamentId}){
    _eventCollection = FirebaseFirestore.instance.collection('parlaments').doc(parlamentId).collection('events');
  }

  Future<bool> updateEvent(Event event)async{
    bool sucssess = true;
    await _eventCollection.doc(event.id as String).set(
        event.toJson()
    ).catchError((error)=> sucssess = false);
    return sucssess;
  }

  Future<Event?> getEventData(String id)async{
    DocumentSnapshot<Object?> snap =await _eventCollection.doc(id).get();
    if(snap.data() == null)
    {return null;}
    var data = snap.data();
    return Event.fromJson(data as Map<String,dynamic>);
  }



}