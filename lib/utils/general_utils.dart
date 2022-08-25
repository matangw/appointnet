import 'dart:io';

import 'package:appointnet/models/user.dart';
import 'package:appointnet/screens/login/login_component.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralUtils{



  String? phoneValidationError(String userInput){
    if(userInput.length!=10 && userInput.length!=12){return 'Not in the correct length';}
    else if(userInput.startsWith('05')==false && userInput.startsWith('972')==false){return 'Not valid number';}
    if(int.tryParse(userInput)==null){
      return 'Insert only numbers';
    }
    return null;
  }

  String phoneTemplate(String userInput){
    if(userInput.length == 12){
      String phoneNumber = '+'+userInput;
      return phoneNumber;
    }
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

  openWhatsappGroup(String? link,dynamic view) async{
    if(link ==null){
      view.onError('No link for this group');
      return;
    }
    var whatsapp =link;
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(link)){
        await launch(link, forceSafariVC: false);
      }else{
        print('[!] WHATSAPP NOT INSTALLED');
      }

    }else{
      // android , web
      if( await canLaunch(link)){
        await launch(link);
      }else{
        print('[!] WHATSAPP NOT INSTALLED');

      }
    }
  }
  openWhatsappContact(String phoneNumber,dynamic view) async{
    var whatsapp =phoneNumber;
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
        await launch(whatappURL_ios, forceSafariVC: false);
      }else{
        view.onError('[!] WHATSAPP NOT INSTALLED');
      }

    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        view.onError('[!] WHATSAPP NOT INSTALLED');

      }
    }
  }


  Future<void> launchPhone(String phoneNumber) async{
    await launchUrl(Uri.parse('tel://$phoneNumber'));
  }

}