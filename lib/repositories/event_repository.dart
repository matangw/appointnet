import 'package:appointnet/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventRepository{

  String parlamentId;
  late CollectionReference _eventCollection;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Query groupCollecion =FirebaseFirestore.instance.collectionGroup('events');


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

  Future<List<Event>> getParlamentEvents() async{
    List<Event> result = [];
    QuerySnapshot snap = await _eventCollection.orderBy('date',descending: false).get();
    if(snap.size==0){
      return [];
    }
    else{
      for(var doc in snap.docs){
        result.add(Event.fromJson(doc.data() as Map<String,dynamic>));
      }
    }
    return result;
  }

  Future<List<Event>> upcomingUserEvents() async{
    List<Event> result = [];
    String userId = _auth.currentUser?.uid as String;
    QuerySnapshot snap = await groupCollecion.where('invited',arrayContains: userId).orderBy('date').limit(5).get();
    if(snap.size==0){
      print('[-] NO UPCOMING EVENTS FOUNDED');
      return [];
    }
    print('[+] FOUND '+snap.size.toString() +' IN COLLECTION GROUP');
    for(var event in snap.docs){
      result.add(Event.fromJson(event.data() as Map<String,dynamic>));
    }
    return result;
  }



}