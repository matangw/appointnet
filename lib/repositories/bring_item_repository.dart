import 'package:appointnet/models/bring_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BringItemRepository{

  String eventId;
  String parlamentId;
  late CollectionReference _itemCollection;

  BringItemRepository({required this.eventId,required this.parlamentId}){
    _itemCollection = FirebaseFirestore.instance.collection('parlaments').doc(parlamentId).collection('events')
        .doc(eventId).collection('bring_items');
  }


  Future<bool> updateBringItem(BringItem bringItem)async{
    bool sucssess = true;
    await _itemCollection.doc(bringItem.id as String).set(
        bringItem.toJson()
    ).catchError((error)=> sucssess = false);
    return sucssess;
  }

  

}