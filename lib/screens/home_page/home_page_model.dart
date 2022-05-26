import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/models/user.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/repositories/user_repository.dart';
import 'package:appointnet/screens/home_page/home_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageModel{

  FirebaseAuth auth = FirebaseAuth.instance;

  ///user data
  late AppointnetUser user;
  List<Parlament> userParlaments = [];

  HomePageView view;
  HomePageModel(this.view){
    getUserData();
  }

  Future<void> getUserData() async{
    AppointnetUser? user = await UserRepository().getUserData(auth.currentUser?.uid as String);
    if(user== null){
      view.onError('[-] USER NOT FOUND');
    }
    else{
      print('[+] FOUND USER');
      await getUserParlaments();
      this.user = user;
      view.onFinishedLoading()
      ;
    }
  }

  Future<void> getUserParlaments()async{
    userParlaments = await ParlamentsRepository().getParlmanetsForUser(auth.currentUser?.uid as String);
  }


  // TODO: GET TOP 5 CLOSE EVENTS

}