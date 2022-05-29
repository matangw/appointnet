import 'package:appointnet/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_view.dart';

class LoginModel{

  LoginView view;
  FirebaseAuth auth = FirebaseAuth.instance;

  late String verificationId;


  LoginModel(this.view);


  void getCode(String phoneNumber) async{
    String? error = GeneralUtils().phoneValidationError(phoneNumber);
    if(error!=null){
      view.loginFailed(error);
    }
    else{
      phoneNumber = GeneralUtils().phoneTemplate(phoneNumber);
      print(phoneNumber);
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (cred)=> {loginTry(cred.smsCode.toString())},
        verificationFailed:(exeption)=> view.loginFailed(exeption.message),
        codeSent: (String verificationId, int? resendToken) async {
          this.verificationId = verificationId;
          codeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId){

        }
    );
    }
  }

  Future<void> codeSent()async{
    view.gotCode();
  }

  Future<void> loginTry(String userCode)async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userCode) ;
    await auth.signInWithCredential(credential);
    view.loginSucsses(credential);

  }
}