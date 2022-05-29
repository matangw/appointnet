import 'dart:io';

import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_model.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_view.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class NewParlamentComponent extends StatefulWidget{

  static const String tag = '/new_parlament';

  @override
  State<NewParlamentComponent> createState() => _NewParlamentComponentState();
}

class _NewParlamentComponentState extends State<NewParlamentComponent> implements NewParlamentView{

  /// USER INPUT VARIABLES
  TextEditingController nameController = TextEditingController();
  TextEditingController friendsSearchingBar = TextEditingController();
  List<String> friendsIds = [];
  CroppedFile? userImage;
  bool needToConfirm = false;

  /// image picker
  ImagePicker picker = ImagePicker();

  ///loading variables
  bool isLoading = false;

  late NewParlamentModel model;

  @override
  void initState() {
    model = NewParlamentModel(this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors().mainBright,
      floatingActionButton: myActionButton(height,width),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                titleWidget(height*0.3, width),
              friendsContainer(height*0.6, width)
                
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
      color: MyColors().mainBright,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: ()=> onPickImage(),
            child: CircleAvatar(
              radius: height*0.3,
              backgroundColor: MyColors().backgroundColor,
              backgroundImage: userImage == null? null : FileImage(File(userImage?.path as String )),
              child: Icon(Icons.image,color: MyColors().mainDark,),
            ),
          ),
          SizedBox(height: height*0.05,),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height*0.2)),
            child: Container(
              width: width*0.7,
              padding: EdgeInsets.symmetric(vertical: height*0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height*0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group,color: MyColors().mainColor,),
                  SizedBox(width: width*0.05,),
                  WidgetUtils().customText('name: ',fontWeight: FontWeight.bold),
                  Container(
                    width: width*0.4,
                    child: TextField(
                      controller: nameController,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget friendsContainer(double height,double width){
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(width*0.1),topRight: Radius.circular(width*0.1)),
        color: MyColors().backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height*0.05,child: WidgetUtils().customText('Pick friends',fontWeight: FontWeight.bold,)),
          Container(height:height*0.1,width: width*0.7,child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.search), SizedBox(width:width*0.4,child: TextField(controller: friendsSearchingBar,))],)),
          ),
          SizedBox(height:height*0.05),
          Container(
            height: height*0.75,
            width: width*0.9,
            child: ListView(
              children: [
                freindListTile(height*0.15 ,width*0.8),
                freindListTile(height*0.15 ,width*0.8),
                freindListTile(height*0.15 ,width*0.8),
                freindListTile(height*0.15 ,width*0.8),
                freindListTile(height*0.15 ,width*0.8),
                freindListTile(height*0.15 ,width*0.8),
              ],
            ),
            
          )
        ],
      ),
    );
  }
  
  List<Widget> friendsList(double tileHeight,double tileWidth,String search){
    return [];
  }
  
  Widget freindListTile(double height,double width){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height*0.25)),
      child: Container(
        height: height,
        width: width,
        margin: EdgeInsets.symmetric(vertical: height*0.15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height*0.25),
          color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: width*0.1,),
            CircleAvatar(backgroundColor: MyColors().backgroundColor,),
            SizedBox(width: width*0.05,),
            WidgetUtils().customText('user name',fontWeight: FontWeight.bold),
            Expanded(child: SizedBox()),
            CircleAvatar(backgroundColor: MyColors().mainColor,child: Icon(Icons.add,color: Colors.white,),),
            SizedBox(width: width*0.1,)
          ],
        ),
      ),
    );
  }

  FloatingActionButton myActionButton(double height,double width){
    return FloatingActionButton(
        backgroundColor: MyColors().mainBright,
        child: Icon(Icons.check,color:needToConfirm?Colors.white : Colors.white,),
        onPressed: ()=> floatingActionButtonFunction(height, width),
    );
  }

  Widget myAlertDialog(double height,double width){
    return AlertDialog(
      title: Text('Are you sure you want to create the group '+nameController.text),
      actions: [
        InkWell(
          onTap: ()=>model.uploadParlament(nameController.text, friendsIds, File(userImage?.path as String)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.01),
            color: MyColors().mainColor,
            child: WidgetUtils().customText('YES',color: Colors.white),
          ),
        ),
        InkWell(
          onTap: ()=>Navigator.of(context).pop(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: height*0.01),
            color: Colors.red,
            child: WidgetUtils().customText('NO',color: Colors.white),
          ),
        )
      ],
    );
  }


  void floatingActionButtonFunction(double height,double width){
      if(model.allFieldsFilled(nameController.text, friendsIds,userImage?.path)){
        showDialog(context: context, builder:(_)=>myAlertDialog(height, width));
      }
  }

  @override
  void onError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.white,content: WidgetUtils().customText(error,color: Colors.red)));
  }

  @override
  void onPickImage() {
    picker.pickImage(source: ImageSource.gallery).then((value) => {
      if(value!=null){
        ImageCropper().cropImage(
          sourcePath: value.path,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: MyColors().mainColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        ).then((value) =>
        {userImage = value,onDataChanged()}
        )
      }
    });
  }

  @override
  void onSubmit() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void onDataChanged() {
    setState(() {});
  }

  @override
  void onFinishedUploading() {
    Navigator.of(context).popAndPushNamed(HomePageComponent.tag);
  }
}