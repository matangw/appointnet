import 'package:appointnet/screens/profile_screen/profile_screen_view.dart';

import '../../utils/shared_reffrencess_utils.dart';

class ProfileScreenModel{

  ProfileScreenView view;
  late SharedPreferencesUtils sh;
  ProfileScreenModel(this.view){
    sh  = SharedPreferencesUtils();
    fetchedSharedData();
  }

  Future<void> fetchedSharedData()async{
    int? number = await sh.getUserNumberOfParlaments();
    view.gotSharedData(number??0);
  }

}