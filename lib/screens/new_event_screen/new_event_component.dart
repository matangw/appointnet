import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/new_event_screen/new_event_model.dart';
import 'package:appointnet/screens/new_event_screen/new_event_view.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEventComponent extends StatefulWidget {
  static const String tag = 'new_event_screen';
  @override
  State<NewEventComponent> createState() => _NewEventComponentState();
}

class _NewEventComponentState extends State<NewEventComponent>
    implements NewEventView {
  late NewEventModel model;

  late Parlament parlament;

  ///loading bools
  bool needToFetchedData = true;
  bool loading = false;

  ///user input variables
  DateTime? date;
  TimeOfDay? time;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    model = NewEventModel(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (needToFetchedData) {
      setState(() => {
            parlament = ModalRoute.of(context)?.settings.arguments as Parlament,
            needToFetchedData = false,
            model.parlament = parlament
          });
    }
    final localizations = MaterialLocalizations.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: loading
          ? WidgetUtils().loadingWidget(height, width)
          : SingleChildScrollView(
              child: Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        WidgetUtils()
                            .goBackButton(width * 0.2, height * 0.05, context)
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    titleWidget(height * 0.3, width),
                    dataRow(height * 0.1, width * 0.9, Icons.date_range, 'Date',
                        datePickButton(height * 0.06, width * 0.25)),
                    dataRow(
                        height * 0.1,
                        width * 0.9,
                        Icons.timer,
                        'Time',
                        timePickButton(
                            height * 0.06, width * 0.25, localizations)),
                    dataRow(height * 0.1, width * 0.9, Icons.location_on,
                        'Location', locationField(height * 0.06, width * 0.4)),
                    Expanded(child: SizedBox()),
                    confirmButton(height * 0.1, width * 0.6, localizations),
                    SizedBox(
                      height: height * 0.05,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget titleWidget(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          Positioned(
            top: height * 0.2,
            left: width * 0.05,
            child: WidgetUtils().customText('Add event for',
                fontSize: height * 0.1,
                fontWeight: FontWeight.bold,
                letterSpacing: width * 0.015),
          ),
          Positioned(
              top: 0,
              right: width * 0.05,
              child: Icon(
                Icons.event,
                size: height * 0.4,
                color: MyColors().mainColor,
              )),
          Positioned(
              top: height * 0.4,
              left: width * 0.05,
              child: WidgetUtils()
                  .customText(parlament.name, fontSize: height * 0.15))
        ],
      ),
    );
  }

  Widget dataRow(double height, double width, IconData icon, String name,
      Widget pickButton) {
    return Container(
      height: height,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.1,
          ),
          Icon(
            icon,
            color: MyColors().mainColor,
          ),
          SizedBox(
            width: width * 0.05,
          ),
          WidgetUtils().customText(name),
          Expanded(
            child: SizedBox(),
          ),
          pickButton
        ],
      ),
    );
  }

  Widget datePickButton(double height, double width) {
    return InkWell(
      onTap: () => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      ).then((value) => {date = value, onDataChanged()}),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.25),
            color: MyColors().mainColor),
        child: Center(
          child: WidgetUtils().customText(
              date == null
                  ? 'Pick date'
                  : DateFormat.yMMMd().format(date as DateTime),
              color: Colors.white),
        ),
      ),
    );
  }

  Widget timePickButton(
      double height, double width, MaterialLocalizations localizations) {
    return InkWell(
      onTap: () => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 16, minute: 00),
      ).then((value) => {time = value, onDataChanged()}),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.25),
            color: MyColors().mainColor),
        child: Center(
          child: WidgetUtils().customText(
              time == null
                  ? 'Pick time'
                  : localizations.formatTimeOfDay(time as TimeOfDay),
              color: Colors.white),
        ),
      ),
    );
  }

  Widget locationField(double height, double width) {
    return Container(
      height: height,
      width: width,
      child: Center(
        child: TextField(
          controller: locationController,
          decoration: InputDecoration(hintText: 'Location'),
        ),
      ),
    );
  }

  Widget confirmButton(
      double height, double width, MaterialLocalizations localizations) {
    return InkWell(
      onTap: () => onSubmit(height, width, localizations),
      child: WidgetUtils().bottomButton(width, height,
          WidgetUtils().customText('CONFIRM', color: Colors.white)),
    );
  }

  Widget myAlertDialog(
      double height, double width, MaterialLocalizations localizations) {
    return AlertDialog(
      title: Text(
        'Are you sure you want to add event for ' +
            'parlament name, at ' +
            DateFormat.yMMMd().format(date as DateTime) +
            ' - ' +
            localizations.formatTimeOfDay(time as TimeOfDay) +
            ' in ' +
            locationController.text +
            '?',
      ),
      actions: [
        InkWell(
          onTap: () => model.uploadEvent(
              date as DateTime, time as TimeOfDay, locationController.text),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.1, vertical: height * 0.1),
            color: MyColors().mainColor,
            child: WidgetUtils().customText('YES', color: Colors.white),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.1, vertical: height * 0.1),
            color: Colors.red,
            child: WidgetUtils().customText('NO', color: Colors.white),
          ),
        )
      ],
    );
  }

  void onSubmit(
      double height, double width, MaterialLocalizations localizations) {
    String? error = model.submitError(date, time, locationController.text);
    if (error == null) {
      showDialog(
          context: context,
          builder: (_) => myAlertDialog(height, width, localizations));
    } else {
      onError(error);
    }
  }

  @override
  void onComplete() {
    Navigator.of(context).popAndPushNamed(HomePageComponent.tag);
  }

  @override
  void onDataChanged() {
    setState(() => null);
  }

  @override
  void onError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: WidgetUtils().customText(error, color: Colors.red)));
  }

  @override
  void startedUploading() {
    setState(() => loading = true);
  }
}
