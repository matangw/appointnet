
import 'package:appointnet/utils/general_utils.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AddFriendComponent extends StatefulWidget{
  @override
  State<AddFriendComponent> createState() => _AddFriendComponentState();
}

class _AddFriendComponentState extends State<AddFriendComponent> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                titleWidget(height*0.15, width*0.8),
                SizedBox(height: height*0.01,),
                phoneField(height*0.1, width*0.7),
                SizedBox(height: height*0.1,),
                confarmationButton(height*0.1, width*0.5)
            ],
          )
        ),
      ),
    );
  }

  Widget titleWidget(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          Icon(Icons.person_add,color: MyColors().mainColor,size: height*0.5,),
          Text('ADD FREIND BY PHONE NUMBER',style: TextStyle(color: Colors.black),)
        ],
      ),
    );
  }

  Widget phoneField(double height,double width){
    return Container(
      padding: EdgeInsets.all(height*0.1),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height*0.25),
        color: Colors.white
      ),
      child: Center(
        child: TextField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: 'Phone number',
          ),
        ),
      ),
    );
  }

  Widget confarmationButton(double height,double width){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.25),color: MyColors().mainColor),
      child: Center(
        child: WidgetUtils().customText('ADD',color: Colors.white),
      )
    );
  }
}