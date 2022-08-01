import 'package:appointnet/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NotificationRepository{
  CollectionReference _notificationCollection = FirebaseFirestore.instance.collection('notifications');
  FirebaseAuth _auth = FirebaseAuth.instance;
  Reference _ref = FirebaseStorage.instance.ref('/AppointNet_parlaments_photos');

  Future<bool> createNotification(String topic,String title,String body)async{
      bool sucssess = true;
      Notification n = Notification(topic: topic, title: title, body: body);
      await _notificationCollection.add(
          n.toJson()
      ).catchError((error)=> sucssess = false);
      return sucssess;
  }
}