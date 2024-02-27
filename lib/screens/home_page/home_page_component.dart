import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/models/user.dart';
import 'package:appointnet/screens/home_page/home_page_model.dart';
import 'package:appointnet/screens/home_page/home_page_view.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_component.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_component.dart';
import 'package:appointnet/screens/profile_screen/profile_screen_component.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePageComponent extends StatefulWidget {
  static const String tag = '/home_page';

  @override
  State<HomePageComponent> createState() => _HomePageComponentState();
}

class _HomePageComponentState extends State<HomePageComponent>
    implements HomePageView {
  /// user variables
  late AppointnetUser user;
  late List<Parlament> userParlaments;
  late List<Event> userUpcomingEvents = [];

  late HomePageModel model;

  ///loading bools
  bool isLoading = true;
  bool dataFetched = false;
  @override
  void initState() {
    model = HomePageModel(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!dataFetched) {
      model.getUserUpcomingEvents();
      dataFetched = true;
    }
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: MyColors().backgroundColor,
        floatingActionButton: myFloatingActionButton(),
        body: isLoading
            ? WidgetUtils().loadingWidget(height, width)
            : RefreshIndicator(
                onRefresh: () => model.getUserData(),
                child: ListView(children: [
                  Container(
                    height: height,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.07,
                        ),
                        profileContainer(height * 0.2, width),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        nextEventsContainer(height * 0.15, width),
                        parlamentContainer(height * 0.55, width)
                      ],
                    ),
                  ),
                ]),
              ),
      ),
    );
  }

  Widget profileContainer(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(ProfileScreenComponent.tag, arguments: user),
              child: CircleAvatar(
                radius: height * 0.3,
                backgroundColor: MyColors().mainColor,
                backgroundImage:
                    CachedNetworkImageProvider(user.imageUrl as String),
              )),
          SizedBox(
            height: height * 0.1,
          ),
          WidgetUtils().customText(user.name, fontWeight: FontWeight.bold)
        ],
      ),
    );
  }

  Widget nextEventsContainer(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          Container(
            height: height * 0.15,
            width: width,
            child: Row(
              children: [
                SizedBox(
                  width: width * 0.3,
                ),
                Container(
                  width: width * 0.4,
                  child: WidgetUtils().customText('My next event'),
                ),
                SizedBox(
                  width: width * 0.15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.1,
          ),
          Container(
            width: width,
            height: height * 0.75,
            child: Center(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: userUpcomingEvents.length,
                    itemBuilder: (context, index) =>
                        eventCricle(height, width, index))),
          )
        ],
      ),
    );
  }

  Widget eventCricle(double height, double width, int index) {
    return InkWell(
      onTap: () => eventPressed(model.userUpcomingEvents[index]),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
          userUpcomingEvents[index].parlamentImage,
        )),
      ),
    );
  }

  Widget parlamentContainer(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WidgetUtils().customText('PARLAMENTS', fontWeight: FontWeight.bold),
          Expanded(child: SizedBox()),
          Container(
            height: height * 0.95,
            width: width * 0.95,
            child: ListView(
              children: parlamentWidgetList(height * 0.15, width * 0.8),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> parlamentWidgetList(double tileHeight, double tileWidth) {
    List<Widget> result = [];
    for (var parlament in model.userParlaments) {
      result.add(parlamentListTile(tileHeight, tileWidth, parlament));
    }
    return result;
  }

  Widget parlamentListTile(double height, double width, Parlament parlament) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(ParlamentScreenComponent.tag, arguments: [parlament]).then(
              (value) => setState(() => dataFetched = false)),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height * 0.2)),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height * 0.2),
              color: Colors.white
              //gradient: LinearGradient(colors: [Colors.white,MyColors().mainBright], stops: [0.15,1],)
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.1,
              ),
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(parlament.imageUrl as String),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              WidgetUtils().customText(parlament.name,
                  fontWeight: FontWeight.bold, color: MyColors().textColor)
            ],
          ),
        ),
      ),
    );
  }

  SpeedDial myFloatingActionButton() {
    return SpeedDial(
      child: Icon(
        Icons.add,
        color: MyColors().mainColor,
      ),
      backgroundColor: Colors.white,
      overlayOpacity: 0.5,
      children: [
        SpeedDialChild(
            child: Icon(
              Icons.group,
              color: MyColors().mainBright,
            ),
            backgroundColor: Colors.white,
            label: ('parlament'),
            onTap: () =>
                Navigator.of(context).pushNamed(NewParlamentComponent.tag)),
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
      isLoading = false;
      user = model.user;
      userParlaments = model.userParlaments;
    });
    model.setLocalData();
  }

  @override
  void onGotAllEvents() {
    setState(() => userUpcomingEvents = model.userUpcomingEvents);
  }

  @override
  void eventPressed(Event event) {
    Parlament wantedParlament = model.userParlaments
        .firstWhere((element) => element.imageUrl == event.parlamentImage);
    Navigator.of(context).pushNamed(ParlamentScreenComponent.tag, arguments: [
      wantedParlament,
      event
    ]).then((value) => setState(() => dataFetched = false));
  }

  @override
  void gotLocalData() {
    setState(() {
      isLoading = false;
      user = model.user;
      userParlaments = model.userParlaments;
    });
  }
}
