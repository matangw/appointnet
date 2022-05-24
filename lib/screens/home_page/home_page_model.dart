import 'package:appointnet/models/user.dart';
import 'package:appointnet/repositories/user_repository.dart';
import 'package:appointnet/screens/home_page/home_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageModel{

  FirebaseAuth auth = FirebaseAuth.instance;

  HomePageView view;
  HomePageModel(this.view){}

  Future<void> getUserData() async{
    AppointnetUser? user = await UserRepository().getUserData(auth.currentUser?.uid as String);
    if(user== null){
      view.onError('[-] USER NOT FOUND');
    }
    else{
      view.onFinishedLoading(user);
    }

  }

}