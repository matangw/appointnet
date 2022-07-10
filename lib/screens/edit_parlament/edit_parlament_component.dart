import 'dart:io';

import 'package:appointnet/screens/edit_parlament/edit_parlament_model.dart';
import 'package:appointnet/screens/edit_parlament/edit_parlament_view.dart';
import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/parlament.dart';
import '../../utils/my_colors.dart';
import '../../utils/widget_utils.dart';

class EditParlamentComponent extends StatefulWidget{

  static const String tag = '/edit_parlament_component';

  @override
  State<EditParlamentComponent> createState() => _EditParlamentComponentState();
}

class _EditParlamentComponentState extends State<EditParlamentComponent> implements EditParlamentView{

  late EditParlamentModel model;


  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController whatsappLinkController = TextEditingController();
  ImagePicker picker = ImagePicker();
  CroppedFile? userImage;

  bool needToGetParlament = true;
  late Parlament parlament;

  @override
  Widget build(BuildContext context) {
    if(needToGetParlament){
      setState(()=>{
        parlament = ModalRoute.of(context)?.settings.arguments as Parlament,
          needToGetParlament = false,
          model = EditParlamentModel(this),
          nameController.text = parlament.name,
          whatsappLinkController.text = parlament.whatsappLink?? ''
      });
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: myActionButton(height, width),

      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: isLoading? Center(child: WidgetUtils().loadingWidget(height*0.3, width*0.3),)
          :Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height*0.1,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [SizedBox(width: width*0.1,),WidgetUtils().goBackButton(width, height*0.05, context)],
              ),
              SizedBox(height: height*0.1,),
              titleWidget(height*0.5, width)
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: ()=> onPickImage(),
            child:userImage==null?
            CircleAvatar(
              radius: height*0.2,
              backgroundColor: MyColors().mainBright,
              backgroundImage: NetworkImage(parlament.imageUrl as String),
              child: Icon(Icons.image,color: Colors.white,),
            ):
            CircleAvatar(
              radius: height*0.2,
              backgroundColor: MyColors().mainBright,
              backgroundImage: userImage == null? null : FileImage(File(userImage?.path as String )),
              child: Icon(Icons.image,color: Colors.white,),
            ),
          ),
          SizedBox(height: height*0.05,),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height*0.2)),
            child: Container(
              width: width*0.9,
              padding: EdgeInsets.symmetric(vertical: height*0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height*0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width*0.05,),
                  Icon(Icons.group,color: MyColors().mainColor,),
                  SizedBox(width: width*0.05,),
                  Container(
                      alignment: Alignment.centerLeft,
                      width:width*0.25,child: WidgetUtils().customText('Name: ',fontWeight: FontWeight.bold)
                  ),
                  Container(
                    width: width*0.4,
                    child: TextField(
                      decoration: InputDecoration(hintText: ' must*'),
                      controller: nameController,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: height*0.05,),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(height*0.2)),
            child: Container(
              width: width*0.9,
              padding: EdgeInsets.symmetric(vertical: height*0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height*0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: width*0.05,),
                  Icon(Icons.whatsapp_sharp,color: MyColors().mainColor,),
                  SizedBox(width: width*0.05,),
                  Container(
                      alignment: Alignment.centerLeft,
                      width: width*0.25,child: WidgetUtils().customText('whatsapp link: ',fontWeight: FontWeight.bold)
                  ),
                  Container(
                    width: width*0.4,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'mandetory'),
                      controller: whatsappLinkController,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget myAlertDialog(double height,double width){
    File? imageFile = userImage?.path==null? null : File(userImage?.path as String);
    return AlertDialog(
      title: Text('Are you sure you want to update the parlament '+nameController.text),
      actions: [
        InkWell(
          onTap: ()=>{
            parlament.name = nameController.text,
            parlament.whatsappLink = whatsappLinkController.text,
            Navigator.of(context).pop(),
            model.updateParlament(parlament,imageFile),
          },
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


  FloatingActionButton myActionButton(double height,double width){
    return FloatingActionButton(
      backgroundColor: MyColors().mainBright,
      child: Icon(Icons.check,color: Colors.white,),
      onPressed: ()=> floatingActionButtonFunction(height, width),
    );
  }

  void floatingActionButtonFunction(double height,double width){
    if(model.allFieldsFilled(nameController.text,userImage?.path)){
      showDialog(context: context, builder:(_)=>myAlertDialog(height, width));
    }
  }


  void onDataChanged() {
    setState(() {});
  }

  @override
  void onError(String error) {
    GeneralUtils().errorSnackBar(error, context);
  }

  @override
  void onFinish() {
    Navigator.of(context).pushNamed(HomePageComponent.tag);
  }

  @override
  void onSubmit() {
    setState(()=> isLoading= true);
  }
}