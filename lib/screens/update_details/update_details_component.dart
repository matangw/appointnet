import 'dart:io';

import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/update_details/update_details_model.dart';
import 'package:appointnet/screens/update_details/update_details_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';


class UpdateDetailsComponent extends StatefulWidget{

  static const String tag ='/updateDetails';

  @override
  State<UpdateDetailsComponent> createState() => _UpdateDetailsComponentState();
}

class _UpdateDetailsComponentState extends State<UpdateDetailsComponent> implements UpdateDetailsView{

  ///model
  late UpdateDetailsModel model;

  /// user input data
  TextEditingController nameController = TextEditingController();
  DateTime? birthDate;
  CroppedFile? userImage;

  ///loading bool
  bool isLoading = false;

  ImagePicker picker = ImagePicker();

  @override
    void initState() {
      model = UpdateDetailsModel(this);
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
    backgroundColor: MyColors().backgroundColor,
    body: isLoading? SizedBox(height: height,width: width,child: const  Center(child: CircularProgressIndicator(),),)
    :SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width*0.05),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget(width*0.05),
            SizedBox(height: height*0.05,),
            imageContainer(width*0.15),
            SizedBox(height: height*0.05,),
            textFieldWidget(height*0.08, width*0.6, nameController, 'Name:', Icons.person),
            SizedBox(height: height*0.02,),
            datePickerWidget(height*0.08, width*0.6),
            SizedBox(height: height*0.1,),
            submitButton(height*0.1, width*0.4),
            SizedBox(height: height*0.05)
          ],

        ),
      ),
    ),
    );
  }
  
  Widget titleWidget(double fontSize){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: WidgetUtils().customText(
            'Please fill youre details',
            color: MyColors().mainColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
        Container(
          child: WidgetUtils().customText(
              'and submit',
              color: MyColors().mainColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  Widget imageContainer(double radius){
    return Container(
      decoration: BoxDecoration(
        color: MyColors().mainColor,
        borderRadius: BorderRadius.circular(radius*0.1)
      ),
      padding: EdgeInsets.all(radius*0.1),
      child: InkWell(
        onTap: ()=> pickImage(),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
          backgroundImage: userImage==null? null : FileImage(File(userImage?.path as String)),
          child:userImage==null? Icon(Icons.image,size: radius*0.8,) : Container(),
        ),
      ),
    );
  }

  Widget textFieldWidget(double height,double width,TextEditingController controller, String name, IconData icon){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical:height*0.01),
      decoration: BoxDecoration(
        color: MyColors().mainColor,
        borderRadius: BorderRadius.circular(height*0.1)
      ),
      child: Card(
        elevation: 10,
        child: Container(
              padding: EdgeInsets.symmetric(vertical: height*0.1,horizontal: width*0.02),
          height: height,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,color: MyColors().mainColor,),
              SizedBox(width: width*0.05,),
              WidgetUtils().customText(name,color: MyColors().mainColor,fontWeight: FontWeight.bold),
              SizedBox(width: width*0.05,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*0.02),
                width: width*0.5,
                height: height,
                child: Center(
                  child: TextField(
                    controller: nameController,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget datePickerWidget(double height,double width,){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width*0.02,vertical:height*0.01),
      decoration: BoxDecoration(
          color: MyColors().mainColor,
          borderRadius: BorderRadius.circular(height*0.1)
      ),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height*0.1,horizontal: width*0.02),
          height: height,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.date_range,color: MyColors().mainColor,),
              SizedBox(width: width*0.05,),
              WidgetUtils().customText('Birth date:',color: MyColors().mainColor,fontWeight: FontWeight.bold),
              SizedBox(width: width*0.08,),
              Container(
                width: width*0.4,
                decoration: BoxDecoration(
                  color: MyColors().mainColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child:  InkWell(
                    onTap: ()=>showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(Duration(days: 3650)),
                        firstDate: DateTime.now().subtract(Duration(days: 36500)),
                        lastDate: DateTime.now().subtract(Duration(days: 3649)),
                    ).then((value) => {
                      birthDate = value,
                      dataChanged()
                    }),
                      child: WidgetUtils().customText(
                          birthDate==null?
                          'PICK':DateFormat.yMMMd().format(birthDate as DateTime),
                          color:Colors.white))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget submitButton(double height,double width,){
    return InkWell(
      onTap: ()=> model.createAppointnetUser(userImage?.path,nameController.text, birthDate),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            color: MyColors().mainColor,
              child: Center(child: WidgetUtils().submitButton(height, width,color: MyColors().mainColor))),
        ],
      ),
    );
  }

  @override
  void dataChanged() {
    setState(() {});
  }

  @override
  void onError(String error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }

  @override
  void onSubmit() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void pickImage() {
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
        {userImage = value,dataChanged()}
        )
      }
    });
  }

  @override
  void onFinshedUploading() {
    Navigator.of(context).pushNamed(HomePageComponent.tag);
  }
}