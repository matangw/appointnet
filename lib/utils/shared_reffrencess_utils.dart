import 'dart:ffi';

import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';

class SharedPreferencesUtils{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userId;

  late SharedPreferences sh;
  SharedPreferencesUtils();

  Future<void>  initiate()async{
    sh =await SharedPreferences.getInstance();
    userId = _auth.currentUser?.uid as String;
  }

  Future<void> setUserdata(AppointnetUser user)async{
    print('Setting data for user: '+user.name);
    sh.setString(userId+'id', userId);
    sh.setString(userId+'name', user.name);
    sh.setString(userId+'phoneNumber', user.phoneNumber);
    sh.setString(userId+'birthDate', user.birthDate.toString());
    sh.setString(userId+'imageUrl', user.imageUrl as String);
  }


  Future<void> setLocalParlamentsIds(List<String> parlamentsId)async{
    print('Setting local parlaments: '+parlamentsId.toString());
    sh.setStringList('palamentsIds', parlamentsId);
  }


  Future<List<Parlament>> getParlamentList(List<String> ids) async {
    List<Parlament> parlaments = [];
    for(var id in ids){
      Parlament? parlament = await  getLocalParlmanet(id);
      if(parlament!=null){
        parlaments.add(parlament);
      }
    }
    return parlaments;
  }

  Future<List<String>?> getLocalParlamentsIds()async{
    List<String>? ids =  sh.getStringList('palamentsIds');
    if(ids ==null)
      return null;
    else{
      return ids;
    }
  }

  Future<AppointnetUser?> getUserData(String userId)async{
    if(sh.getString(userId+'id')==null){
      return null;
    }
    return AppointnetUser(
        id:sh.getString(userId+'id'),
        name: sh.getString(userId+'name') as String,
        phoneNumber:sh.getString(userId+'phoneNumber') as String,
        birthDate: DateTime.parse(sh.getString(userId+'birthDate') as String),
        imageUrl:     sh.getString(userId+'imageUrl') as String,
    );
  }

  Future<void> setParlamentEventsIds(String parlamentId,List<String> ids)async{
    await sh.setStringList(parlamentId+ 'localEvents', ids);
  }
  Future<List<String>?> getParlamentEventsIds(String parlamentId)async{
    List<String>? ids = await sh.getStringList(parlamentId+'localEvents');
    if(ids==null){
      return null;
    }
    return ids;
  }


  Future<void> setEventData(Event event)async{
    String eventId = event.id as String;
    sh.setString(eventId+'id', eventId);
    sh.setString(eventId+'date', event.date.toString());
    sh.setString(eventId+'imageUrl', event.parlamentImage);
    sh.setString(eventId+'location', event.location);
    sh.setStringList(eventId+'attendings', event.attendingsIds);
    sh.setStringList(eventId+'invited', event.invitedIds);
    sh.setString(eventId+'time', event.time.toString());
  }


  Future<Event?> getEventData(String eventId)async{
    if(sh.getString(eventId)==null){
      return null;
    }
    else{
      String s = sh.getString(eventId+'time') as String;
      return Event(
          parlamentImage:sh.getString(eventId+'imageUrl') as String,
          date:DateTime.parse(sh.getString(eventId+'date') as String),
          time:TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1])),
          location: sh.getString(eventId+'location') as String,
          attendingsIds: sh.getStringList(eventId+'attendings') as List<String>,
          invitedIds: sh.getStringList(eventId+'invited',) as List<String>,
          id:sh.getString(eventId+'id') as String
    );
    }
  }

  Future<List<Event>> getListEventsData(List<String> ids)async{
    List<Event> result = [];
    for(var id in ids){
      result.add(await getEventData(id) as Event);
    }
    return result;
  }

  Future<void> setParlament(Parlament parlament) async{
    print('Setting local data for parlament: '+ parlament.name);
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
    sh.setInt(userId+'ParlamentNumber', number);
  }

  Future<int?> getUserNumberOfParlaments()async{
    return sh.getInt(userId+'ParlamentNumber');
  }

  Future<void> setUserFriendsNumber(int number)async{
    sh.setInt(userId+'FriendsNumber', number);
  }

  Future<int?> getUserFriendsNumber() async{
    return sh.getInt(userId+'FriendsNumber');
  }




}