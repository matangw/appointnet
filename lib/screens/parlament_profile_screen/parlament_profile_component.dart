import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/parlament_profile_screen/parlament_profile_model.dart';
import 'package:appointnet/screens/parlament_profile_screen/parlament_profile_view.dart';
import 'package:appointnet/utils/general_utils.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:appointnet/models/user.dart';


import '../../utils/widget_utils.dart';

class ParlamentProfileComponent extends StatefulWidget{

  static const String tag= '/parlament_profile_screen';

  @override
  State<ParlamentProfileComponent> createState() => _ParlamentProfileComponentState();
}

class _ParlamentProfileComponentState extends State<ParlamentProfileComponent> implements ParlamentProfileView{

  bool needLoading = true;

  late ParlamentProfileModel model;
  
  late List<AppointnetUser> members;
  late Parlament parlament;

  int eventNumber = 0;
  
  @override
  Widget build(BuildContext context) {
    if(needLoading){
      List<dynamic> arguments = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      members =arguments[0];
      parlament = arguments[1];
      model = ParlamentProfileModel(parlament,this);
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      backgroundColor: MyColors().backgroundColor,
      body: Container(
        height: height,
        width: width,
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleWidget(height*0.3, width),
              detailsContainer(height*0.3, width),
              memebersContainer(height*0.55, width*0.95),
              exitGroupButton(height*0.15,width,height*0.1, width*0.6)
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
                  child: InkWell(
                    onTap: ()=>Navigator.of(context).pushNamed(ParlamentProfileComponent.tag),
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
                ),))
        ],
      ),
    );
  }
  
  Widget detailsContainer(double height,double width){
    return Container(
        height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          dataRow(width*0.9, 'Members', Icons.group,  members.length.toString()),
          dataRow(width*0.9, 'Events', Icons.event, eventNumber.toString()),
        Container(
          width: width*0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width*0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.whatsapp_sharp,color: MyColors().mainBright,),
                    SizedBox(width: width*0.03,),
                    WidgetUtils().customText('whatsapp link')
                  ],
                ),
              ),
              SizedBox(width: width*0.25,),
              /// todo: whatssapp link does not work
              InkWell(
                onTap: ()=>model.openWhatsappGroup(parlament.whatsappLink),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MyColors().mainBright,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: width*0.03,),
                  child: Center(
                    child: WidgetUtils().customText('Link',color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        )
      ]
    ));
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
          SizedBox(width: width*0.3,),
          WidgetUtils().customText(data)
        ],
      ),
    );
  }


  Widget memebersContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      child: ListView(
        children: memberListTileCreation(height*0.17, width),
      ),
    );
  }

  List<Widget> memberListTileCreation(double tileHeight,double tileWidth){
    List<Widget> result = [];
    for(var member in members){
      result.add(memeberListTile(tileHeight, tileWidth,member));
    }
    return result;
  }
  
  Widget memeberListTile(double height,double width,AppointnetUser member){
    return Container(
      margin: EdgeInsets.symmetric(vertical: height*0.1),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height*0.25),
        color: MyColors().mainBright
         ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: width*0.1,),
          CircleAvatar(backgroundImage: NetworkImage(member.imageUrl as String),),
          SizedBox(width: width*0.05,),
          Text(member.name),
          Expanded(child: SizedBox()),
          InkWell(
              onTap: ()=> model.launchPhone(member.phoneNumber),
              child: Icon(Icons.phone,color: Colors.white,)
          ),
          SizedBox(width: width*0.03,),
          InkWell(
            onTap: ()=> model.openWhatsappContact(member.phoneNumber),
              child: Icon(Icons.whatsapp,color: Colors.white,)
          ),
          SizedBox(width: width*0.1,)
        ],
      ),
    );
  }
  
  Widget exitGroupButton(double containerHeight,double containerWidth,double height,double width){
    return Container(
      decoration: BoxDecoration(
        color: MyColors().backgroundColor,
        boxShadow: [BoxShadow(
          offset: Offset.fromDirection(0,5),
          spreadRadius: 1,
          blurRadius: 5,
          color: Colors.grey[600]?? Colors.grey

        )]
      ),
      child: SizedBox(
        width: containerWidth,
        height: containerHeight,
        child: Center(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height*0.5),
              color: Colors.red
            ),
            child: Center(
              child: WidgetUtils().customText('EXIT GROUP',color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void exitGroup() {
   Navigator.pushNamed(context, HomePageComponent.tag);
  }

  @override
  void goToWhatsapp(String phone, String message) {
    // TODO: implement goToWhatsapp
  }

  @override
  void gotEventsNumber(int number) {
    setState(()=>{
     eventNumber = number
    });
  }

  @override
  void onError(String error) {
    GeneralUtils().errorSnackBar(error, context);
  }
}