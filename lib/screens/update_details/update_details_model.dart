import 'dart:io';

import 'package:appointnet/models/user.dart';
import 'package:appointnet/repositories/user_repository.dart';
import 'package:appointnet/screens/update_details/update_details_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class UpdateDetailsModel {

  FirebaseAuth  auth = FirebaseAuth.instance;
  UserRepository repository = UserRepository();

  UpdateDetailsView view;
  UpdateDetailsModel(this.view);

  Future<void> createAppointnetUser(String? userImage,String? name, DateTime? birthDate) async {
    if(userImage==null){
      view.onError('Please upload a photo');
    }
    else if (name == null || name=='') {
      view.onError('Please insert user name.');
    }
    else if (birthDate == null) {
      view.onError('Please select birth date.');
    }
    else {
      AppointnetUser user = AppointnetUser(name: name, phoneNumber:auth.currentUser?.phoneNumber as String, birthDate: birthDate);
      String imageUrl =await repository.uploadPhoto(File(userImage as String ), user);
      user.imageUrl = imageUrl;
      await repository.updateUser(user).then((sucssess) =>sucssess? print('[+] USER UPDATED') : print('[-] SOMETHING WENT WRONG WITH USER UPDATE') );
    }

  }


}