import 'package:appointnet/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository {
  CollectionReference _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<bool> createNotification(
      String topic, String title, String body) async {
    bool sucssess = true;
    Notification n = Notification(topic: topic, title: title, body: body);
    await _notificationCollection.add(n.toJson());
    return sucssess;
  }
}
