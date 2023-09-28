import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/models/user.dart';
import 'package:appointnet/repositories/event_repository.dart';
import 'package:appointnet/repositories/parlaments_repository.dart';
import 'package:appointnet/screens/parlament_screen/parlament_screen_view.dart';
import 'package:appointnet/utils/general_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as calendar;
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/event.dart';
import '../../utils/shared_reffrencess_utils.dart';

class ParlamentScreenModel {
  Parlament parlament;
  ParlamentScreenView view;
  late List<AppointnetUser> parlamentUsers = [];
  late EventRepository eventRepository;

  SharedPreferencesUtils localData = SharedPreferencesUtils();

  ParlamentScreenModel(this.view, this.parlament) {
    eventRepository = EventRepository(parlamentId: parlament.id as String);
    loadAllData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loadAllData() async {
    await localData.initiate();
    getLocalData();
    await getUpcomingParlamentEvents();
    getParlamentUsers();
    view.onFinishedLoading();
  }

  Future<void> setLocalData(List<Event> events) async {
    List<String> eventsIds = [];
    for (var event in events) {
      eventsIds.add(event.id as String);
    }
    await localData.setParlamentEventsIds(parlament.id as String, eventsIds);
    for (var event in events) {
      localData.setEventData(event);
    }
    for (var user in parlamentUsers) {
      localData.setUserdata(user);
    }
  }

  Future<void> getLocalData() async {
    List<Event> events = [];
    List<String>? eventsIds =
        await localData.getParlamentEventsIds(parlament.id as String);
    if (eventsIds != null) {
      events = await localData.getListEventsData(eventsIds);
      events.removeWhere((element) => element.date.isAfter(DateTime.now()));
      view.gotUpcomingEvents(events);
    }
    for (var id in parlament.usersId) {
      AppointnetUser? user = await localData.getUserData(id);
      user != null ? parlamentUsers.add(user) : null;
    }
    view.onLocalDataLoad();
  }

  Future<void> getUpcomingParlamentEvents() async {
    String parlamentId = parlament.id as String;
    List<Event> events = await EventRepository(parlamentId: parlamentId)
        .getUpcomingParlamentEvents();
    view.gotUpcomingEvents(events);
  }

  Future<void> addUserFromContacts() async {
    bool premmision = await FlutterContactPicker.hasPermission();
    if (!premmision) {
      await FlutterContactPicker.requestPermission();
      return;
    }
    PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    if (contact.phoneNumber == null) {
      view.onError('Contact does not have phone number');
    }
    String contactPhone = contact.phoneNumber?.number as String;
    contactPhone = contactPhone.replaceAll(RegExp('[^0-9]'), '');
    print('[!] Contact phone number: ' + contactPhone);
    addNewUserToParlament(contactPhone);
  }

  Future<void> addNewUserToParlament(String phone) async {
    bool success = true;
    String? phoneError = GeneralUtils().phoneValidationError(phone);
    print('[!] USER PHONE NUMBER: ' + phone);
    if (phoneError != null) {
      view.onError(phoneError);
      return;
    }

    String newPhone = GeneralUtils().phoneTemplate(phone);
    view.startAddingUserToParlament();
    String? error = await ParlamentsRepository()
        .addUserToParlamentUsingPhone(parlament, newPhone);
    if (error != null) {
      view.onError(error);
      success = false;
    }
    view.finishedAddingUserToParlament(success);
  }

  Future<void> confirmAttend(Event event) async {
    event.attendingsIds.add(_auth.currentUser?.uid as String);
    eventRepository.updateEvent(event);
    view.successFeedBack('Your attending updated successfully ');
  }

  Future<void> cancelAttend(Event event) async {
    event.attendingsIds.remove(_auth.currentUser?.uid as String);
    eventRepository.updateEvent(event);
    view.successFeedBack('You successfully canceld your attending');
  }

  bool isUserAttending(Event event) {
    return event.attendingsIds.contains(_auth.currentUser?.uid as String);
  }

  Future<void> getParlamentUsers() async {
    List<AppointnetUser> users =
        await ParlamentsRepository().getParlamentUsers(parlament);
    parlamentUsers = users;
    view.finishedLoadingUsers();
  }

  List<AppointnetUser> comingToEventUserList(Event event) {
    return parlamentUsers
        .where((user) => event.attendingsIds.contains(user.id))
        .toList();
  }

  void addEventToCalendar(Event event) {
    final calendar.Event calendarEvent = calendar.Event(
      title: parlament.name,
      description: '',
      location: event.location,
      startDate: event.date,
      endDate: event.date.add(Duration(hours: 2)),
    );
    calendar.Add2Calendar.addEvent2Cal(calendarEvent);
  }

  Future<void> deleteEvent(Event event) async {
    await eventRepository.deleteEvent(event);
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setBool('home_screen_update', true);
    view.deleteEvent(event);
  }
}
