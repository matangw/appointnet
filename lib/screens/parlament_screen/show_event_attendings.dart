import 'package:appointnet/models/event.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_view.dart';
import 'package:appointnet/utils/general_utils.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../utils/my_colors.dart';

class ShowEventAttendings extends StatefulWidget {
  static const String tag = '/show_event_attending';

  @override
  State<ShowEventAttendings> createState() => _ShowEventAttendingsState();
}

class _ShowEventAttendingsState extends State<ShowEventAttendings>
    implements ParlamentScreenView {
  bool needToGetEvent = true;

  late Event event;
  late List<AppointnetUser> members;

  @override
  Widget build(BuildContext context) {
    if (needToGetEvent) {
      List<dynamic> arguments =
          ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      event = arguments[0];
      members = arguments[1];
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.1,
                  ),
                  WidgetUtils().goBackButton(width, height * 0.05, context),
                ],
              ),
              SizedBox(
                height: height * 0.07,
              ),
              attendingContainer(height * 0.4, width * 0.9),
              notAttendingContainer(height * 0.4, width * 0.9)
            ],
          ),
        ),
      ),
    );
  }

  Widget attendingContainer(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetUtils().customText('Attendings'),
          Divider(
            height: height * 0.1,
          ),
          Container(
            height: height * 0.7,
            child: ListView(
              children: attendingListCreation(height * 0.17, width),
            ),
          )
        ],
      ),
    );
  }

  Widget notAttendingContainer(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetUtils().customText('Not Attending'),
          Divider(
            height: height * 0.1,
          ),
          Container(
            height: height * 0.7,
            child: ListView(
              children: notAttendingListCreation(height * 0.2, width),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> attendingListCreation(double tileHeight, double tileWidth) {
    List<Widget> result = [];
    for (var attend in event.attendingsIds) {
      result.add(memeberListTile(tileHeight, tileWidth,
          members.firstWhere((element) => element.id == attend), true));
    }
    return result;
  }

  List<Widget> notAttendingListCreation(double tileHeight, double tileWidth) {
    List<Widget> result = [];
    for (var member in members) {
      if (event.attendingsIds.contains(member.id) == false) {
        result.add(memeberListTile(tileHeight, tileWidth,
            members.firstWhere((element) => element.id == member.id), false));
      }
    }
    return result;
  }

  Widget memeberListTile(
      double height, double width, AppointnetUser member, bool isAttending) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.1),
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.25),
          color: isAttending ? MyColors().mainBright : Colors.red[300]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width * 0.1,
          ),
          CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(member.imageUrl as String),
          ),
          SizedBox(
            width: width * 0.05,
          ),
          Text(member.name),
          Expanded(child: SizedBox()),
          InkWell(
              onTap: () => GeneralUtils().launchPhone(member.phoneNumber),
              child: Icon(
                Icons.phone,
                color: Colors.white,
              )),
          SizedBox(
            width: width * 0.03,
          ),
          InkWell(
              onTap: () =>
                  GeneralUtils().openWhatsappContact(member.phoneNumber, this),
              child: Icon(
                Icons.sms,
                color: Colors.white,
              )),
          SizedBox(
            width: width * 0.1,
          )
        ],
      ),
    );
  }

  @override
  void finishedAddingUserToParlament(bool success) {
    // TODO: implement finishedAddingUserToParlament
  }

  @override
  void finishedLoadingUsers() {
    // TODO: implement finishedLoadingUsers
  }

  @override
  void gotUpcomingEvents(List<Event> events) {
    // TODO: implement gotUpcomingEvents
  }

  @override
  void onError(String error) {
    // TODO: implement onError
  }

  @override
  void onFinishedLoading() {
    // TODO: implement onFinishedLoading
  }

  @override
  void startAddingUserToParlament() {
    // TODO: implement startAddingUserToParlament
  }

  @override
  void successFeedBack(String message) {
    // TODO: implement successFeedBack
  }

  @override
  void deleteEvent(Event event) {
    // TODO: implement deleteEvent
  }

  @override
  void onLocalDataLoad() {
    // TODO: implement onLocalDataLoad
  }
}
