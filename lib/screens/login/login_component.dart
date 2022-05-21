import 'package:appointnet/screens/login/login_model.dart';
import 'package:appointnet/screens/login/login_view.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:firebase_auth_platform_interface/src/providers/phone_auth.dart';
import 'package:flutter/material.dart';

class LoginComponent extends StatefulWidget{


  @override
  State<LoginComponent> createState() => _LoginComponentState();


  static const String tag = '/login';
}

class _LoginComponentState extends State<LoginComponent> implements LoginView{

  late LoginModel model;

  bool showAlertDialoge = false;
  
  
  //text field controller
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  
  @override
  void initState() {
    model = LoginModel(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height-appBar().preferredSize.height-MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              title(height*0.2, width*0.6, 'welcome'),
              SizedBox(height: height*0.1,),
              bottomContainer(height*0.6, width),

            ],
          ),
        ),
      ),

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
        gradient: LinearGradient(colors: [MyColors().mainBright,MyColors().mainColor], stops: [0.5,1]),
      ),
      child: Center(
        child: Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width*0.1),),
      ),
    );
  }

  Widget bottomContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey[400]?? Colors.blue,spreadRadius: 4,blurRadius: 8,offset: Offset.fromDirection(5,5))
        ],
        color: MyColors().mainColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(width*0.2),topRight: Radius.circular(width*0.2))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          phoneField(height*0.2, width*0.8),
          submitButton(height*0.2, width*0.4)
        ],
      ),
    );
  }

  Widget phoneField(double height,double width){

    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width*0.05)
      ),
      child: Row(
        children: [
          Text('phone number: '),
          Container(
            width: width*0.5,
            child: TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: const InputDecoration(
                  hintText:  'write here'
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget submitButton(double height,double width){
    return InkWell(
      onTap: ()=> model.getCode(phoneController.text),
      child: WidgetUtils().submitButton(height, width)
    );
  }

  AlertDialog userCodeDialog(){
    return AlertDialog(
      title: Text('INSERT CODE HERE'),
      content: TextField(
        controller: codeController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(hintText: '123456'),
      ),
      actions: [
        InkWell(
          onTap: ()=>model.loginTry(codeController.text),
          child: Container(
            color: MyColors().mainColor,
            child:const  Text('log in'),
          ),
        )
      ],
    );
  }

  @override
  void loginFailed(String? error) {
    String e = error as String;
    print('[-] ERROR: '+ e);
  }

  @override
  void loginSucsses(PhoneAuthCredential cred) {
    print('[+] LOGIN SUCCSESSFUL WITH: '+cred.smsCode.toString());
  }

  @override
  void gotCode() {
    showDialog(context: context, builder:(_)=>userCodeDialog());
  }
}