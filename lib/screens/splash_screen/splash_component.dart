import 'package:appointnet/screens/splash_screen/splash_model.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class SplashComponent extends StatefulWidget {
  @override
  State<SplashComponent> createState() => _SplashComponentState();
}

class _SplashComponentState extends State<SplashComponent> {

  SplashModel model =  SplashModel();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) => Navigator.of(context).pushNamed(model.correctRoute));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Center(
            child: mainWidget(height*0.3, width*0.5),
          ),
        ),
      ),
    );
  }


  PreferredSizeWidget myAppBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget mainWidget(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.group,color: MyColors().mainColor,size: height*0.3,),
          WidgetUtils().customText('appointnet',maxLines: 10,color: MyColors().mainColor,fontSize: height*0.1)
        ],
      ),
    );
  }
}