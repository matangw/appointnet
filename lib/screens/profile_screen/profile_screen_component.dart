import 'package:appointnet/models/user.dart';
import 'package:appointnet/screens/profile_screen/profile_screen_model.dart';
import 'package:appointnet/screens/profile_screen/profile_screen_view.dart';
import 'package:appointnet/utils/general_utils.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/shared_reffrencess_utils.dart';

class ProfileScreenComponent extends StatefulWidget{

  static const String tag = '/profile_screen';

  @override
  State<ProfileScreenComponent> createState() => _ProfileScreenComponentState();
}

class _ProfileScreenComponentState extends State<ProfileScreenComponent> implements ProfileScreenView{

  bool loadingUser = true;
  late AppointnetUser user;

  late ProfileScreenModel model;

  ///user shared data
  int numberOfParlaments = 0;

  SharedPreferencesUtils sh = SharedPreferencesUtils();

  void initState() {
    model = ProfileScreenModel(this);
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if(loadingUser){
      setState(()=> {
        user = ModalRoute.of(context)?.settings.arguments as AppointnetUser,
        loadingUser = false
      });
    }

    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                SizedBox(height: height*0.1,),
              titleWidget(height*0.2, width),
              SizedBox(height: height*0.05,),
              bottomContainer(height*0.4, width*0.8),
              Expanded(child: SizedBox()),
              logOutButton(height*0.1, width*0.6),
              SizedBox(height: height*0.1,)
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget(double height,double width){
    return Container(
      height: height,
      width: width,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width*0.05,),
          CircleAvatar(
            radius: height*0.3,backgroundColor: MyColors().mainColor,
            backgroundImage:NetworkImage(user.imageUrl as String),
          ),
          SizedBox(width: width*0.1,),
         // WidgetUtils().customText(user.name)
        ],
      ),
    );
  }

  Widget bottomContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          dataRow(width, 'Name', Icons.person, user.name),
          dataRow(width, 'Phone number', Icons.phone,GeneralUtils().reversePhoneTemplate(user.phoneNumber)),
          dataRow(width, 'Parlaments', Icons.group,numberOfParlaments==0?'no data' : numberOfParlaments.toString()),
          dataRow(width, 'Age', Icons.calendar_month,GeneralUtils().ageCalculator(user).toString()),
        ],
      ),
    );

  }

  Widget dataRow(double width,String name,IconData icon,String data,{Widget? usersComingWidget}){
    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width*0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon,color: MyColors().mainBright,),
                SizedBox(width: width*0.03,),
                WidgetUtils().customText(name)
              ],
            ),
          ),
          Row(
            children: [
              usersComingWidget?? WidgetUtils().customText(data,fontWeight: FontWeight.bold)
            ],
          )
        ],
      ),
    );
  }

  Widget logOutButton(double height,double width){
    return InkWell(
      onTap: ()=> GeneralUtils().signOut(context),
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(height*0.5)
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.logout,color: Colors.red,),
              SizedBox(width: width*0.1,),
              WidgetUtils().customText('LOG OUT')
            ],
          )
      ),
    );
  }

  @override
  void gotSharedData(int numberOfParlaments) {
    setState(()=>{
      this.numberOfParlaments =   numberOfParlaments
    });
  }

  @override
  void onError() {
    // TODO: implement onError
  }
}

