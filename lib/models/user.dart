
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppointnetUser{

  String? id;
  String name;
  String phoneNumber;
  DateTime birthDate;
  String? imageUrl;


  AppointnetUser({required this.name,required this.phoneNumber, required this.birthDate, this.id,this.imageUrl}){
    id ??= FirebaseAuth.instance.currentUser?.uid as String;
  }


  factory AppointnetUser.fromJson(Map<String,dynamic> json){
   return AppointnetUser(
        name: json['name'],
        phoneNumber: json['phone_number'],
        birthDate: DateTime.parse(json['birth_date']),
        id: json['id'],
       imageUrl: json['image_url']?? ''
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'name': name,
      'birth_date': birthDate.toString(),
      'phone_number': phoneNumber,
      'id': id,
      'image_url': imageUrl
    };
  }


}