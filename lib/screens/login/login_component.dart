import 'package:flutter/material.dart';

class LoginComponent extends StatefulWidget{


  @override
  State<LoginComponent> createState() => _LoginComponentState();


  static const String loginTag = '/login';
}

class _LoginComponentState extends State<LoginComponent> {

  //text field controller
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: appBar(),

    );
  }
  PreferredSizeWidget appBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }


  Widget title(double height,double width, String text){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [Colors.lightBlue,Colors.blue], stops: [0.5,1]),
      ),
      child: Center(
        child: Text('LOG IN',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width*0.1),),
      ),
    );
  }

  Widget phoneField(double height,double width){

    return Container(
      height: height,
      width: width,
      child: Row(
        children: [
          Text('phone number: '),
          TextField(
            decoration: InputDecoration(


            ),
          )
        ],
      ),
    );
  }
}