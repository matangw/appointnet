import 'package:appointnet/models/parlament.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  late SharedPreferences sh;
  SharedPreferencesUtils(){
    initiate();
  }

  Future<void>  initiate()async{
    sh =await SharedPreferences.getInstance();
    userId = _auth.currentUser?.uid as String;
  }

  Future<void> setParlament(Parlament parlament) async{
    await Future.delayed(Duration(milliseconds: 100));
    String parlamentId = parlament.id as String;
    String imageUrl = parlament.imageUrl as String;
    List<String> usersId = parlament.usersId;
    String managerId = parlament.managerId;
    String parlamentName  = parlament.name;
    sh.setString(parlamentId+'Id',parlamentId);
    sh.setString(parlamentId+'ImageUrl',imageUrl);
    sh.setStringList(parlamentId+'UsersId',usersId);
    sh.setString(parlamentId+'ManagerId',managerId);
    sh.setString(parlamentId+'Name',parlamentName);
  }

  Future<Parlament?> getLocalParlmanet(String parlamentId)async{
    await Future.delayed(Duration(milliseconds: 100));
    if(sh.getString(parlamentId+'Id')==null){
      return null;
    }
    else{
      return Parlament(
          name: sh.getString(parlamentId+'Name') as String,
          managerId: sh.get(parlamentId+'ManagerId') as String,
          usersId: sh.getStringList(parlamentId+'UsersId') as List<String>,
          id:parlamentId,
          imageUrl:sh.getString(parlamentId+'ImageUrl') as String
      );
    }
  }

  Future<void> setUserParlamentsNumber(int number)async{
    await Future.delayed(Duration(milliseconds: 100));
    sh.setInt(userId+'ParlamentNumber', number);
  }

  Future<int?> getUserNumberOfParlaments()async{
    await Future.delayed(Duration(milliseconds: 100));
    return sh.getInt(userId+'ParlamentNumber');
  }

  Future<void> setUserFriendsNumber(int number)async{
    await Future.delayed(Duration(milliseconds: 100));
    sh.setInt(userId+'FriendsNumber', number);
  }

  Future<int?> getUserFriendsNumber() async{
    await Future.delayed(Duration(milliseconds: 100));
    return sh.getInt(userId+'FriendsNumber');
  }




}