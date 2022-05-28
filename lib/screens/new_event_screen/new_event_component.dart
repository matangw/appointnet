import 'package:appointnet/utils/my_colors.dart';
import 'package:flutter/material.dart';

class NewEventComponent extends StatefulWidget{
  @override
  State<NewEventComponent> createState() => _NewEventComponentState();
}

class _NewEventComponentState extends State<NewEventComponent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            ],
          ),
        ),
      ),
    );
  }


  // TODO: DATE
  // TODO: TIME
  // TODO: LOCATION
  // TODO: BRINGINGS

}