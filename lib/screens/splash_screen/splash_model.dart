import 'package:appointnet/screens/login/login_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class SplashModel{


  FirebaseAuth auth = FirebaseAuth.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');

  String correctRoute = '';

  SplashModel(){
    print('user phone number is '+ auth.currentUser!.phoneNumber.toString());
    setStartingRoute();
  }

  Future<void> setStartingRoute()async{
    getCorrectRoute();
  }

  Future<void> getCorrectRoute()async{
    if(auth.currentUser == null){
      print('need to go to the login screen /////////////////////////');
      correctRoute = LoginComponent.tag;
    }
    else{
      bool isExist = await checkIfUserExist();
      if(!isExist){
        // TODO: push to update details screen
        print('need to update details');

      }
      else{
        // TODO: push to home screen
        print('need to gome to home screen');
      }
    }
  }

  Future<bool> checkIfUserExist() async{
    QuerySnapshot snapshot = await usersRef.where('phone_number',isEqualTo: auth.currentUser!.phoneNumber as String).get();
    if(snapshot.size==0){
      return false;
    }
    else{
      return true;
    }
  }


}