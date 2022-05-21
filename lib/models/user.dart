
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppointnetUser{

  String? id;
  String name;
  String phoneNumber;
  DateTime birthDate;


  AppointnetUser({required this.name,required this.phoneNumber, required this.birthDate, this.id}){
    id ??= FirebaseAuth.instance.currentUser?.uid as String;
  }


  factory AppointnetUser.fromJson(Map<String,dynamic> json){
   return AppointnetUser(
        name: json['name'],
        phoneNumber: json['phone_number'],
        birthDate: json['birth_date'],
        id: json['id']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'name': name,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'id': id
    };
  }


}