import 'package:appointnet/utils/widget_utils.dart';
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
    userInput.substring(1);
    String phoneNumber = '+972'+userInput;
    return phoneNumber;
  }

  void errorSnackBar(String error,BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.white,content: WidgetUtils().customText(error,color: Colors.red)));
  }
}