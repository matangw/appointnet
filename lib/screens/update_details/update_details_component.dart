import 'dart:convert';
//import 'package:intl/intl.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class UpdateDetailsComponent extends StatefulWidget{

  static const String tag ='/updateDetails';

  @override
  State<UpdateDetailsComponent> createState() => _UpdateDetailsComponentState();
}

class _UpdateDetailsComponentState extends State<UpdateDetailsComponent> {

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            titleWidget(width*0.05),
            SizedBox(height: height*0.05,),
            imageContainer(width*0.3),
            SizedBox(height: height*0.05,),
            textFieldWidget(height*0.1, width*0.8, nameController, 'Name:', Icons.person),
            SizedBox(height: height*0.02,),
            datePickerWidget(height*0.1, width*0.8),
            SizedBox(height: height*0.05,),
            submitButton(height*0.1, width*0.4),
            SizedBox(height: height*0.05)
            ///TODO: date controller

          ],

        ),
      ),
    ),
    );
  }
  
  Widget titleWidget(double fontSize){
    return Container(
      child: Center(
        child: WidgetUtils().customText(
          'REGISTER',
          color: MyColors().mainColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget imageContainer(double radius){
    return Container(
      decoration: BoxDecoration(
        color: MyColors().mainColor,
        borderRadius: BorderRadius.circular(radius*0.1)
      ),
      padding: EdgeInsets.all(radius*0.1),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: Icon(Icons.image,size: radius*0.8,),
      ),
    );
  }

  Widget textFieldWidget(double height,double width,TextEditingController controller, String name, IconData icon){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical:height*0.05),
      decoration: BoxDecoration(
        color: MyColors().mainColor,
        borderRadius: BorderRadius.circular(height*0.1)
      ),
      child: Card(
        elevation: 10,
        child: Container(
              padding: EdgeInsets.symmetric(vertical: height*0.1,horizontal: width*0.02),
          height: height,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,color: MyColors().mainColor,),
              SizedBox(width: width*0.05,),
              WidgetUtils().customText(name,color: MyColors().mainColor,fontWeight: FontWeight.bold),
              SizedBox(width: width*0.05,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.02),
                width: width*0.6,
                height: height,
                child: Center(
                  child: TextField(
                    controller: nameController,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget datePickerWidget(double height,double width,){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical:height*0.05),
      decoration: BoxDecoration(
          color: MyColors().mainColor,
          borderRadius: BorderRadius.circular(height*0.1)
      ),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height*0.1,horizontal: width*0.02),
          height: height,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.date_range,color: MyColors().mainColor,),
              SizedBox(width: width*0.05,),
              WidgetUtils().customText('Pick your birth date:',color: MyColors().mainColor,fontWeight: FontWeight.bold),
              SizedBox(width: width*0.08,),
              Container(
                width: width*0.33,
                decoration: BoxDecoration(
                  color: MyColors().mainColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child:  InkWell(
                      child: WidgetUtils().customText(
                          //dateController.selectedDate!=null?
                            //DateFormat.yMMMd().format(dateController.selectedDate as DateTime) : 4
                          'PICK',
                          color:Colors.white))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget submitButton(double height,double width,){
    return InkWell(
      child: Container(
        color: MyColors().mainColor,
          child: WidgetUtils().submitButton(height, width,color: MyColors().mainColor)),
    );
  }
}