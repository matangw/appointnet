import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/user.dart';
import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/new_event_screen/new_event_component.dart';
import 'package:appointnet/screens/parlament_profile_screen/parlament_profile_component.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_model.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_view.dart';
import 'package:appointnet/screens/parlament_screen/show_event_attendings.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    bool needToJumpToCertinEvent = false;

  /// loading vars
  bool isLoading = true;
  bool isLoadingUsers = true;
  List<Event> events = [];
  Event? eventToJump;

  TextEditingController phoneController = TextEditingController();




  @override
  Widget build(BuildContext context) {


    if(needParlament){
     setState(() {
       List<dynamic> arguments = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
       parlament = arguments[0];
       if(arguments.length>1)
       {
         needToJumpToCertinEvent = true;
         eventToJump = arguments[1];
       }
       needParlament = false;
       model = ParlamentScreenModel(this,parlament);
     });
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if(needToJumpToCertinEvent && !isLoading ){
      int pageToJump = events.indexWhere((event) => event.id==eventToJump?.id);
          print('[!] NEED TO JUMP TO EVENT : '+pageToJump.toString());
          Future.delayed(Duration(milliseconds: 500)).then((value) =>
              _eventController.animateToPage(pageToJump,curve: Curves.easeInOut,duration: Duration(milliseconds: 500)));

    }

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
              Positioned(
                left: height*0.03,
                top: height*0.05,
                child: InkWell(
                    child: WidgetUtils().goBackButton(width, height*0.05, context)
                ),),
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
                image: DecorationImage(image: CachedNetworkImageProvider(parlament.imageUrl as String),fit: BoxFit.fitWidth)
            ),)),
          Positioned(
              left:0,right: 0,bottom: height*0.25,
              child: Center(
                child: Container(
                  height: height*0.25,
                  width: width*0.6,
                  child: InkWell(
                    onTap: ()=>Navigator.of(context).pushNamed(ParlamentProfileComponent.tag,
                      arguments: [model.parlamentUsers,parlament]
                    ),
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
                  ),
                ),)),

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
            child: events.isEmpty?
            WidgetUtils().noDataWidget(height: height*0.5, width: width*0.3, icon: Icons.group, text: 'No events')
            :PageView(
              controller: _eventController,
              scrollDirection: Axis.horizontal,
              children: eventContainerList(height*0.8, width*0.95, localizations),
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
                dataRow(
                    width,'Attending',Icons.group, '()()() +5 more',
                    usersComingWidget: eventComingWidget(height*0.1, width*0.2, event)
                ),
                //dataRow(width,'Bringings',Icons.shopping_bag, '3/8'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    parlament.managerId==FirebaseAuth.instance.currentUser?.uid ?
                    InkWell(
                      onTap:()=>showDialog(context: context,
                          builder:(context)=> deleteEventDialog(height,width,event)),
                      child: CircleAvatar(
                        radius: width*0.05,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.delete,color: Colors.white,),
                      ),
                    )
                        : SizedBox(width: width*0.1,),
                    SizedBox(width: width*0.1,),
                    InkWell(
                      onTap:()=> model.isUserAttending(event)?model.cancelAttend(event) : model.confirmAttend(event),
                      child: Container(
                        height: height*0.1,width: width*0.4,
                      decoration:BoxDecoration(
                          color:model.isUserAttending(event)? MyColors().mainBright : Colors.white,
                          borderRadius: BorderRadius.circular(height*0.25)) ,
                        child: Center(
                            child:WidgetUtils().customText(
                                model.isUserAttending(event)? 'Coming' : 'Not coming',
                                color: model.isUserAttending(event)? Colors.white : Colors.red)
                        ),
                  ),
                    ),
                    SizedBox(width: width*0.05,),
                    InkWell(
                      onTap: ()=> model.addEventToCalendar(event),
                      child: CircleAvatar(
                        radius: width*0.05,
                        backgroundColor: MyColors().buttonColor,
                        child: Icon(Icons.event,color: Colors.white,),
                      ),
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

  Widget eventComingWidget(double height,double width,Event event){
    List<AppointnetUser> usersComing =isLoadingUsers? [] :  model.comingToEventUserList(event);
    return InkWell(
      onTap: ()=> Navigator.pushNamed(context, ShowEventAttendings.tag,arguments:[event,model.parlamentUsers]),
      child: Container(
        height: height,
        width: width,
        child: isLoadingUsers? Center(child: CircularProgressIndicator(color: MyColors().mainColor,),) :
        Row(
          children: [
            Container(
              width: width*0.6,
              child: Stack(
                children: [
                  Positioned(
                    bottom: height*0.1,
                    left: width*0.4,
                      child: usersComing.length>2?CircleAvatar(radius: height*0.3,backgroundImage: CachedNetworkImageProvider(usersComing[2].imageUrl as String),)
                          : Container()
                  ),
                  Positioned(
                      bottom: height*0.1,
                      left: width*0.2,
                      child: usersComing.length>1 ? CircleAvatar(radius: height*0.3,backgroundImage: CachedNetworkImageProvider(usersComing[1].imageUrl as String),)
                          :Container()
                  ),
                  Positioned(
                      bottom: height*0.1,
                      left: 0,
                      child:usersComing.isNotEmpty? CircleAvatar(
                        radius: height*0.3,backgroundImage: CachedNetworkImageProvider(usersComing[0].imageUrl as String),)
                          :Container()
                  ),
                ],
              ),
            ),
            model.comingToEventUserList(event).length>3?WidgetUtils().customText('  +'+ model.comingToEventUserList(event).length.toString())
                :Container()
          ],
        ),
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
      onPressed: ()=> model.addUserFromContacts(),
          //showDialog(context: context, builder: (_)=>myAlertDialog(height, width)),
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
          keyboardType: TextInputType.phone,
          controller: phoneController,
          decoration: InputDecoration(hintText: 'Example: 050-1234567'),
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
  AlertDialog deleteEventDialog(double height,double width,event){
    return AlertDialog(
      title: WidgetUtils().customText('Are you sure you want to delete the event?',maxLines: 5),
      actions: [
        InkWell(
          onTap: ()=> {
            model.deleteEvent(event),
            Navigator.pop(context)
          },
          child: Container(
            height: height*0.1,
            width: width*0.4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.04),color: Colors.red),
            child: Center(
              child: WidgetUtils().customText('DELETE',color: Colors.white),
            ),
          ),
        )
      ],
    );
  }


  @override
  void gotUpcomingEvents(List<Event> events) {
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
    setState(()=> null);
   GeneralUtils().successSnackBar(message, context);
  }

  @override
  void addingUserToParlament() {
    Navigator.of(context).pop();
  }

  @override
  void finishedAddingUserToParlament(bool success) {
    if(success){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: WidgetUtils().customText('User added successfully!',color: Colors.white),
            backgroundColor: MyColors().mainBright,
          )
      );
    }
    setState(()=> isLoading =false);
  }

  @override
  void startAddingUserToParlament() {
    Navigator.of(context).pop();
    setState(()=> isLoading =true);
  }

  @override
  void finishedLoadingUsers() {
    print('[!] NEED TO STOP LOADING');
   setState(()=>isLoadingUsers = false);
  }

  @override
  void deleteEvent(Event event) {
    events.remove(event);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: WidgetUtils().customText('Event deleted succsessfuly',color: Colors.white),
            backgroundColor: MyColors().mainBright,
        )
    );
    setState(()=>{null});
  }

}