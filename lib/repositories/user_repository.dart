import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user.dart';

class UserRepository{

  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> updateUser(AppointnetUser user)async{
    bool sucssess = true;
   await usersCollection.doc(auth.currentUser?.uid as String).update(
     user.toJson()
   ).catchError((error)=> sucssess = false);
   return sucssess;
  }


}