import 'dart:io';

import 'package:appointnet/models/parlament.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ParlamentsRepository{


  CollectionReference parlamentCollection = FirebaseFirestore.instance.collection('parlaments');
  FirebaseAuth auth = FirebaseAuth.instance;
  Reference ref = FirebaseStorage.instance.ref('/AppointNet_parlaments_photos');

  Future<bool> updateParlament(Parlament parlament)async{
    bool sucssess = true;
    await parlamentCollection.doc(parlament.id as String).set(
        parlament.toJson()
    ).catchError((error)=> sucssess = false);
    return sucssess;
  }

  Future<String> uploadPhoto(File file,Parlament parlament) async {
    UploadTask uploadTask = ref.child("appointnet_${parlament.id}.jpg").putFile(file);
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  Future<Parlament?> getUserData(String id)async{
    DocumentSnapshot<Object?> snap =await parlamentCollection.doc(id).get();
    if(snap.data() == null)
    {return null;}
    var data = snap.data();
    return Parlament.fromJson(data as Map<String,dynamic>);

  }


}