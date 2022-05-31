import 'package:appointnet/main.dart';
import 'package:appointnet/models/event.dart';
import 'package:appointnet/screens/new_event_screen/new_event_component.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_model.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_view.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../../models/parlament.dart';
import '../../utils/general_utils.dart';

class ParlamentScreenComponent extends StatefulWidget{

  static const String tag = 'parlament_screen_tag';
  @override
  State<ParlamentScreenComponent> createState() => _ParlamentScreenComponentState();
}

class _ParlamentScreenComponentState extends State<ParlamentScreenComponent> implements ParlamentScreenView {

  late ParlamentScreenModel model;

  ///controllers
  final PageController _eventController = PageController(initialPage: 0);

  ///modal variables
    late Parlament parlament;
    bool needParlament = true;

  /// loading vars
  bool isLoading = true;
  List<Event> events = [];

  TextEditingController phoneController = TextEditingController();




  @override
  Widget build(BuildContext context) {


    if(needParlament){
     setState(() {
       parlament = ModalRoute.of(context)?.settings.arguments as Parlament;
       needParlament = false;
       model = ParlamentScreenModel(this,parlament);
     });
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    // TODO: implement build
    return Scaffold(
      floatingActionButton: myActionButton(height, width),
      backgroundColor: MyColors().backgroundColor,
      body: isLoading? WidgetUtils().loadingWidget(height*0.6, width*0.8)
      :SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned(left: 0,right: 0,top: 0,child: titleWidget(height*0.35, width)),
              Positioned(left:0,right: 0,bottom: 0,child: bottomContainer(height*0.7, width,localizations)),
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
      child: Stack(
        children: [
          Positioned(child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: MyColors().mainDark,
                image: DecorationImage(image: NetworkImage(parlament.imageUrl as String),fit: BoxFit.fitWidth)
            ),)),
          Positioned(
              left:0,right: 0,bottom: height*0.25,
              child: Center(
                child: Container(
                  height: height*0.25,
                  width: width*0.6,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height*0.5)),
                    child: Center(
                        child: WidgetUtils().customText(
                            parlament.name,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: MyColors().mainColor,
                            fontSize: height*0.08)),
              ),
                ),))
        ],
      ),
    );
  }

  Widget bottomContainer(double height,double width,MaterialLocalizations localizations){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.08),color: MyColors().backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: height*0.05,),
          Container(
            height: height*0.7,
            width: width,
            child: PageView(
              controller: _eventController,
              scrollDirection: Axis.horizontal,
              children: eventContainerList(height*0.8, width*0.9, localizations),
            ),
          ),
          SizedBox(height: height*0.025,),
          Divider(color: MyColors().mainBright,thickness: 1,),
          SizedBox(height: height*0.025,),
          newEventButton(height*0.1, width*0.6)
        ],
      ),
    );
  }

  List<Widget> eventContainerList(double height,double width,MaterialLocalizations localizations){
    List<Widget> result = [];
    if(events.isEmpty){return [];}
    for(var e in events){
      result.add(eventContainer(height, width, e, localizations));
    }
    return result;
  }

  Widget eventContainer(double height,double width,Event event,MaterialLocalizations localizations){
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetUtils().customText('Event at: '+DateFormat.yMMMd().format(event.date),color: Colors.black,fontWeight: FontWeight.bold),
          Container(
            height: height*0.8,
            width: width*0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dataRow(width,'Time',Icons.access_time, localizations.formatTimeOfDay(event.time)),
                dataRow(width,'Location',Icons.location_on_rounded, event.location),
                dataRow(width,'Attending',Icons.group, '()()() +5 more'),
                dataRow(width,'Bringings',Icons.shopping_bag, '3/8'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height*0.1,width: width*0.4,
                    decoration:BoxDecoration(color: MyColors().mainBright,borderRadius: BorderRadius.circular(height*0.25)) ,
                      child: Center(child:WidgetUtils().customText('Coming',color: Colors.white)),
                  )
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dataRow(double width,String name,IconData icon,String data){
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
              WidgetUtils().customText(data,fontWeight: FontWeight.bold)
            ],
          )
        ],
      ),
    );
  }

  Widget newEventButton(double height,double width){
    return InkWell(
      onTap: ()=> Navigator.pushNamed(context, NewEventComponent.tag,arguments: parlament),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: MyColors().mainColor,
          borderRadius: BorderRadius.circular(height*0.5),
        ),
        child: Center(child: WidgetUtils().customText('NEW EVENT',color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
  }

 FloatingActionButton myActionButton(double height,double width){
    return FloatingActionButton(
      onPressed: ()=>showDialog(context: context, builder: (_)=>myAlertDialog(height, width)),
      backgroundColor: MyColors().mainColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add,color: Colors.white,)
        ],
      ),
    );
 }

 AlertDialog myAlertDialog(double height,double width){
    return AlertDialog(
      title: WidgetUtils().customText('Insert user phone number.'),
      content: Container(
        width: width*0.6,
        child: TextField(
          controller: phoneController,
          decoration: InputDecoration(hintText: '1234567890'),
        ),
      ),
    actions: [
      InkWell(
        onTap: ()=> {
          model.addNewUserToParlament(phoneController.text),
          phoneController.text = '',

        },
        child: Container(
          height: height*0.08,
          width: width*0.4,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.04),color: MyColors().mainColor),
          child: Center(
            child: WidgetUtils().customText('ADD',color: Colors.white),
          ),
        ),
      )
    ],
    );
 }

  @override
  void gotAllEvents(List<Event> events) {
    this.events = events;
  }

  @override
  void onError(String error) {
    GeneralUtils().errorSnackBar(error, context);
  }

  @override
  void onFinishedLoading() {
    setState(()=> isLoading = false);
  }

  @override
  void successFeedBack(String message) {
   GeneralUtils().successSnackBar(message, context);
  }

  @override
  void addingUserToParlament() {
    Navigator.of(context).pop();
  }

  @override
  void finishedAddingUserToParlament() {
    setState(()=> isLoading =false);
  }

  @override
  void startAddingUserToParlament() {
    setState(()=> isLoading =true);
  }

}