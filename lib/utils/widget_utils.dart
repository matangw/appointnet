import 'package:flutter/material.dart';

import 'my_colors.dart';

class WidgetUtils{


  Widget customText(String text,{Color? color,FontWeight? fontWeight,TextAlign? align,double? fontSize,int? maxLines,TextOverflow? overflow,double? letterSpacing}){
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines?? 1,
      textAlign: align?? TextAlign.center,
      style: TextStyle(
        color: color?? MyColors().textColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: letterSpacing
      ),
    );
  }

  Widget submitButton(double height,double width,{Color? color}){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color?? Colors.white,
          borderRadius: BorderRadius.circular(width*0.05)
      ),
      child: Center(
        child: Text('SUBMIT',style: TextStyle(color: color==null? MyColors().mainColor : Colors.white),),
      ),
    );
  }

  Widget loadingWidget(double height,double width){
    return SizedBox(
      height: height,
      width: width,
      child:  Center(
        child: CircularProgressIndicator(color: MyColors().mainColor,),
      ),
    );
  }

  Widget bottomButton(double width,double height,Widget child){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height*0.5),
          color: MyColors().mainColor
      ),
      child: Center(child: child),
    );
  }
}