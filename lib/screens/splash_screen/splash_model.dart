import 'package:appointnet/screens/home_page/home_page_component.dart';
import 'package:appointnet/screens/login/login_component.dart';
import 'package:appointnet/screens/update_details/update_details_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashModel {
  FirebaseAuth auth = FirebaseAuth.instance;
  final usersRef = FirebaseFirestore.instance.collection('users');

  String correctRoute = '';

  SplashModel() {
    setStartingRoute();
  }

  Future<void> setStartingRoute() async {
    getCorrectRoute();
  }

  Future<void> getCorrectRoute() async {
    if (auth.currentUser == null) {
      correctRoute = LoginComponent.tag;
    } else {
      bool isExist = await checkIfUserExist();
      if (!isExist) {
        correctRoute = UpdateDetailsComponent.tag;
        print('need to update details');
      } else {
        correctRoute = HomePageComponent.tag;
        print('need to gome to home screen');
      }
    }
  }

  Future<bool> checkIfUserExist() async {
    QuerySnapshot snapshot = await usersRef
        .where('phone_number',
            isEqualTo: auth.currentUser!.phoneNumber as String)
        .get();
    if (snapshot.size == 0) {
      return false;
    } else {
      return true;
    }
  }
}
