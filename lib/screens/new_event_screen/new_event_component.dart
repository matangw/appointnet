import 'package:appointnet/screens/new_event_screen/new_event_view.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewEventComponent extends StatefulWidget{
  @override
  State<NewEventComponent> createState() => _NewEventComponentState();
}

class _NewEventComponentState extends State<NewEventComponent> implements NewEventView{


  ///user input variables
  DateTime? date;
  TimeOfDay? time;
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              SizedBox(height: height*0.15,),
              titleWidget(height*0.3, width),
              dataRow(height*0.1, width*0.9, Icons.date_range, 'Date',datePickButton(height*0.06, width*0.25)),
              dataRow(height*0.1, width*0.9, Icons.timer, 'Time',timePickButton(height*0.06, width*0.25,localizations)),
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
          Positioned(
              top: height*0.2,
              left: width*0.05,
              child: WidgetUtils().customText(
                  'Add event for',
                  fontSize: height*0.1,fontWeight: FontWeight.bold,
                letterSpacing: width*0.015
              ),
          ),
          Positioned(top:0,right: width*0.05,child: Icon(Icons.event,size: height*0.4,color: MyColors().mainColor,)),
          Positioned(top:height*0.4,left:width*0.05,child: WidgetUtils().customText('PARLAMENT NAME',fontSize: height*0.15))
        ],
      ),
    );
  }

  Widget dataRow(double height,double width,IconData icon,String name,Widget pickButton){
    return Container(
      height: height,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: width*0.1,),
          Icon(icon,color: MyColors().mainColor,),
          SizedBox(width: width*0.05,),
          WidgetUtils().customText(name),
          Expanded(child: SizedBox(),),
          pickButton
        ],
      ),
    );
  }

  Widget datePickButton(double height,double width){
    return InkWell(
      onTap: ()=> showDatePicker(
          context: context, initialDate: DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
      ).then((value) => {date = value,onDataChanged()}),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.25),color: MyColors().mainColor),
        child: Center(
          child: WidgetUtils().customText(
             date==null? 'Pick date' : DateFormat.yMMMd().format(date as DateTime),
            color: Colors.white
          ),
        ),
      ),
    );
  }
  Widget timePickButton(double height,double width,MaterialLocalizations localizations){
    return InkWell(
      onTap: ()=> showTimePicker
        (
          context: context,
          initialTime: TimeOfDay(hour: 16, minute: 00),
      ).then((value) => {time = value, onDataChanged()}),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(height*0.25),color: MyColors().mainColor),
        child: Center(
          child: WidgetUtils().customText(
          time==null? 'Pick time' :localizations.formatTimeOfDay(time as TimeOfDay),
            color: Colors.white
        ),
        ),
      ),
    );
  }


  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onDataChanged() {
    setState(()=>null);
  }

  @override
  void onError() {
    // TODO: implement onError
  }

  @override
  void onSubmit() {
    // TODO: implement onSubmit
  }

}