import 'package:appointnet/main.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/models/user.dart';
import 'package:appointnet/screens/home_page/home_page_model.dart';
import 'package:appointnet/screens/home_page/home_page_view.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_component.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePageComponent extends StatefulWidget{

  static const String tag= '/home_page';

  @override
  State<HomePageComponent> createState() => _HomePageComponentState();
}

class _HomePageComponentState extends State<HomePageComponent> implements HomePageView {

  /// user variables
  late AppointnetUser user;
  late List<Parlament> userParlaments;


  late HomePageModel model;

  ///loading bools
  bool isLoading = true;

  @override
  void initState() {
    model = HomePageModel(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height- MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      floatingActionButton: myFloatingActionButton(),
      body: isLoading? WidgetUtils().loadingWidget(height, width)
      :SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height*0.07,),
                profileContainer(height*0.2, width),
                SizedBox(height: height*0.03,),
                nextEventsContainer(height*0.15, width),
                parlamentContainer(height*0.55, width)
            ],
          ),
        ),
      ),

    );
  }


  Widget profileContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: height*0.3,backgroundColor: MyColors().mainColor,backgroundImage: NetworkImage(user.imageUrl as String),),
          SizedBox(height: height*0.1,),
          WidgetUtils().customText(user.name,fontWeight: FontWeight.bold)
        ],
      ),
    );
  }

  Widget nextEventsContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          Container(
            height: height*0.15,
            width: width,
            child: Center(child: Text('my next events')),
          ),
          SizedBox(height: height*0.1,),
          Container(
            width: width,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(backgroundColor: Colors.black,radius: height*0.4*0.5,),
                  CircleAvatar(backgroundColor: Colors.black,radius: height*0.4*0.5,),
                  CircleAvatar(backgroundColor: Colors.black,radius: height*0.4*0.5,),
                  CircleAvatar(backgroundColor: Colors.black,radius: height*0.4*0.5,),
                  CircleAvatar(backgroundColor: Colors.black,radius: height*0.4*0.5,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget parlamentContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetUtils().customText('PARLAMENTS',fontWeight: FontWeight.bold),
          Expanded(child: SizedBox()),
          Container(
            height: height*0.95,
            width: width*0.95,
            child: ListView(
              children: parlamentWidgetList(height*0.15, width*0.8),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> parlamentWidgetList(double tileHeight,double tileWidth){
    List<Widget> result = [];
    for(var parlament in model.userParlaments){
      result.add(parlamentListTile(tileHeight, tileWidth,parlament));
    }
    return result;
  }

  Widget parlamentListTile(double height,double width,Parlament parlament){
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height*0.2)),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height*0.2),
            gradient: LinearGradient(colors: [MyColors().mainColor,MyColors().mainBright],stops: [0.5,1])
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: width*0.1,),
            CircleAvatar(backgroundImage: NetworkImage(parlament.imageUrl as String),),
            SizedBox(width: width*0.05,),
            WidgetUtils().customText(parlament.name,fontWeight: FontWeight.bold,color: Colors.white)
          ],

        ),
      ),
    );
  }

  SpeedDial myFloatingActionButton(){
    return SpeedDial(
      child: Icon(Icons.add,color: MyColors().mainColor,),
      backgroundColor: Colors.white,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
          child: Icon(Icons.group,color: MyColors().mainBright,),
          backgroundColor: Colors.white,
          label: ('parlament'),
          onTap: ()=>Navigator.of(context).pushNamed(NewParlamentComponent.tag)
        ),
        SpeedDialChild(
          child: Icon(Icons.person,color: MyColors().mainDark,),
          backgroundColor: Colors.white,
          label: ('friend'),
        )
      ],
    );
  }

  @override
  void onError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }


  @override
  void onFinishedLoading() {
    setState(() {
      setState(() {
        print('SETTING NEW STATE');
      });
      isLoading = false;
      user = model.user;
      userParlaments = model.userParlaments;
    });
  }


}