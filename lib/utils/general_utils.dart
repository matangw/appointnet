import 'package:appointnet/models/user.dart';
import 'package:appointnet/screens/login/login_component.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GeneralUtils{



  String? phoneValidationError(String userInput){
    if(userInput.length!=10){return 'Not in the correct length';}
    else if(userInput.startsWith('05')==false){return 'Not valid number';}
    if(int.tryParse(userInput)==null){
      return 'Insert only numbers';
    }
    return null;
  }

  String phoneTemplate(String userInput){
    userInput = userInput.substring(1);
    String phoneNumber = '+972'+userInput;
    return phoneNumber;
  }

  String reversePhoneTemplate(String templatedPhoned){
    templatedPhoned = templatedPhoned.substring(4);
    templatedPhoned = '0'+templatedPhoned;
    return templatedPhoned;
  }

  void errorSnackBar(String error,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.white,content: WidgetUtils().customText(error,color: Colors.red)));
  }

  void successSnackBar(String error,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.white,content: WidgetUtils().customText(error,color: MyColors().mainColor)));
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(LoginComponent.tag, (Route<dynamic> route) => false);

  }

  int ageCalculator(AppointnetUser user){
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - user.birthDate.year;
    int month1 = currentDate.month;
    int month2 = user.birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = user.birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}