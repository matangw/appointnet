import 'dart:io';

import 'package:appointnet/models/event.dart';
import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/repositories/event_repository.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/screens/parlament_profile_screen/parlament_profile_view.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
class ParlamentProfileModel{

  Parlament parlament;
  late EventRepository repository;

  ParlamentProfileView view;

  ParlamentProfileModel(this.parlament,this.view){
    repository = EventRepository(parlamentId: parlament.id as String);
  }

  Future<void> getEventNumber()async{
    int number = await repository.getNumberOfAllEvents();
    view.gotEventsNumber(number);

  }


  openWhatsappContact(String phoneNumber) async{
    var whatsapp =phoneNumber;
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
        await launch(whatappURL_ios, forceSafariVC: false);
      }else{
          print('[!] WHATSAPP NOT INSTALLED');
      }

    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
          print('[!] WHATSAPP NOT INSTALLED');

      }
    }
  }

  openWhatsappGroup(String link) async{
    var whatsapp =link;
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(link)){
        await launch(link, forceSafariVC: false);
      }else{
        print('[!] WHATSAPP NOT INSTALLED');
      }

    }else{
      // android , web
      if( await canLaunch(link)){
        await launch(link);
      }else{
        print('[!] WHATSAPP NOT INSTALLED');

      }
    }
  }


  Future<void> launchPhone(String phoneNumber) async{
    await launchUrl(Uri.parse('tel://$phoneNumber'));
  }

  Future<void> exitGroup()async{
    await ParlamentsRepository().removeUserFromParlament(parlament);
    view.exitGroup();

  }
}