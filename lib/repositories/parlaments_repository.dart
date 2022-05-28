import 'dart:io';

import 'package:appointnet/models/parlament.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ParlamentsRepository{


  CollectionReference _parlamentCollection = FirebaseFirestore.instance.collection('parlaments');
  FirebaseAuth _auth = FirebaseAuth.instance;
  Reference _ref = FirebaseStorage.instance.ref('/AppointNet_parlaments_photos');

  Future<bool> updateParlament(Parlament parlament)async{
    bool sucssess = true;
    await _parlamentCollection.doc(parlament.id as String).set(
        parlament.toJson()
    ).catchError((error)=> sucssess = false);
    return sucssess;
  }

  Future<String> uploadPhoto(File file,Parlament parlament) async {
    UploadTask uploadTask = _ref.child("appointnet_${parlament.id}.jpg").putFile(file);
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  Future<Parlament?> getParlamentData(String id)async{
    DocumentSnapshot<Object?> snap =await _parlamentCollection.doc(id).get();
    if(snap.data() == null)
    {return null;}
    var data = snap.data();
    return Parlament.fromJson(data as Map<String,dynamic>);
  }
  
  Future<List<Parlament>> getParlmanetsForUser(String userId)async{
    List<Parlament> result= [];
    QuerySnapshot snap = await _parlamentCollection.where('users_id',arrayContains: userId).get();
    if(snap.size==0){
      return [];
    }
    for(var doc in snap.docs){
      result.add(Parlament.fromJson(doc.data() as Map<String,dynamic>));
    }
    return result;
  }


}