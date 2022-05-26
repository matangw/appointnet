import 'dart:io';

import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/screens/new_parlament/new_parlament_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewParlamentModel{

  NewParlamentView view;
  FirebaseAuth auth =FirebaseAuth.instance;
  ParlamentsRepository repo = ParlamentsRepository();

  NewParlamentModel(this.view);

  bool allFieldsFilled(String? name,List<String> friendsIds,String? parlamentImagePath) {
    if(parlamentImagePath==null){view.onError('Please upload image.'); return false;}
    else if(name?.isEmpty as bool){view.onError('Please enter name.'); return false;}
    else{return true;}
  }

  Future<void> uploadParlament(String name,List<String> friendsIds,File parlamentImage) async{
    view.onSubmit();
    Parlament parlament = Parlament(name: name, managerId:auth.currentUser?.uid as String , usersId: friendsIds);
    String imageUrl = await repo.uploadPhoto(parlamentImage, parlament);
    parlament.usersId.add(auth.currentUser?.uid as String);
    parlament.imageUrl = imageUrl;
    repo.updateParlament(parlament);
    view.onFinishedUploading();
  }

}