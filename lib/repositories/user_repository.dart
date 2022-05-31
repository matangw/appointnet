import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';

class UserRepository{

  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  Reference ref = FirebaseStorage.instance.ref('/AppointNet_users_photos');

  Future<bool> updateUser(AppointnetUser user)async{
    bool sucssess = true;
   await usersCollection.doc(auth.currentUser?.uid as String).set(
     user.toJson()
   ).catchError((error)=> sucssess = false);
   return sucssess;
  }


  Future<String> uploadPhoto(File file,AppointnetUser user) async {
    UploadTask uploadTask = ref.child("appointnet_${user.id}.jpg").putFile(file);
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  Future<AppointnetUser?> getUserData(String id)async{
    DocumentSnapshot<Object?> snap =await usersCollection.doc(id).get();
    if(snap.data() == null)
      {return null;}
    var data = snap.data();
    return AppointnetUser.fromJson(data as Map<String,dynamic>);

  }

  Future<AppointnetUser?> getUserByPhone(String phone)async{
    QuerySnapshot snap = await usersCollection.where('phone_number',isEqualTo: phone).get();
    if(snap.size==0){return null;}
    else{
      return AppointnetUser.fromJson(snap.docs[0].data() as Map<String,dynamic>);
    }
  }


}