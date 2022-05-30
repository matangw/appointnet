import 'package:appointnet/main.dart';
import 'package:appointnet/screens/new_event_screen/new_event_component.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/parlament.dart';

class ParlamentScreenComponent extends StatefulWidget{

  static const String tag = 'parlament_screen_tag';
  @override
  State<ParlamentScreenComponent> createState() => _ParlamentScreenComponentState();
}

class _ParlamentScreenComponentState extends State<ParlamentScreenComponent> {

  ///controllers
  final PageController _eventController = PageController(initialPage: 0);

  ///modal variables
    late Parlament parlament;

  /// loading vars
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {

    if(isLoading){
     setState(() {
       parlament = ModalRoute.of(context)?.settings.arguments as Parlament;
       isLoading = false;
     });
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // TODO: implement build
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: isLoading? WidgetUtils().loadingWidget(height, width)
      :SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned(left: 0,right: 0,top: 0,child: titleWidget(height*0.35, width)),
              Positioned(left:0,right: 0,bottom: 0,child: bottomContainer(height*0.7, width)),
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

  Widget bottomContainer(double height,double width){
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
              children: [
                eventContainer(height*0.8, width*0.8),
                eventContainer(height*0.8, width*0.8),
              ],
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

  Widget eventContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetUtils().customText('Event at: 21/9/2000',color: Colors.black,fontWeight: FontWeight.bold),
          Container(
            height: height*0.8,
            width: width*0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dataRow(width,'Time',Icons.access_time, '8:30'),
                dataRow(width,'Location',Icons.location_on_rounded, 'kalay'),
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

}