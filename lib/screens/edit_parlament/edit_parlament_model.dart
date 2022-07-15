import 'dart:io';

import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/screens/edit_parlament/edit_parlament_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repositories/parlaments_repository.dart';

class EditParlamentModel{


  EditParlamentView view;
  FirebaseAuth auth =FirebaseAuth.instance;
  ParlamentsRepository repo = ParlamentsRepository();

  EditParlamentModel(this.view);

  bool allFieldsFilled(String? name,String? parlamentImagePath) {
    if(name?.isEmpty as bool){view.onError('Please enter name.'); return false;}
    else{return true;}
  }

  Future<void> updateParlament(Parlament parlament,File? parlamentImage) async{
    view.onSubmit();
    if(parlamentImage!=null)
      {
        String imageUrl = await repo.uploadPhoto(parlamentImage, parlament);
        parlament.imageUrl = imageUrl;
      }
    repo.updateParlament(parlament);
    view.onFinish();
  }

}