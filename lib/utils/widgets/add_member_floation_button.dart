import 'dart:math' as math;

import 'package:appointnet/models/parlament.dart';
import 'package:appointnet/services/dynamic_links_creation.dart';
import 'package:appointnet/utils/general_utils.dart';
import 'package:appointnet/utils/my_colors.dart';
import 'package:appointnet/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class addMemberButton extends StatefulWidget {
  Parlament parlament;

  addMemberButton({required this.parlament});

  @override
  _addMemberButton createState() => _addMemberButton();
}

class _addMemberButton extends State<addMemberButton>
    with SingleTickerProviderStateMixin<addMemberButton> {
  late AnimationController _controller;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // ignore: null_aware_before_operator
  }

  double width = 50;

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [Icons.person_add, Icons.share];
    List<String> texts = ["Add contacts", "Share link"];
    return Container(
      child: SingleChildScrollView(
        clipBehavior: Clip.hardEdge,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(icons.length, (int index) {
            Widget child = AnimatedContainer(
              height: 50.0,
              width: width,
              alignment: FractionalOffset.topRight,
              duration: Duration(milliseconds: 300),
              child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            String screen = "None";
                            if (index == 0) {
                              addUserFromContacts();
                            }
                            if (index == 1) {
                              ShareLinkService().shareGroup(
                                  platform: 'whatsapp',
                                  group: widget.parlament);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Icon(icons[index],
                                    color: MyColors().mainColor,
                                    size: _controller.isDismissed ? 0 : 16.0),
                                Container(
                                    width: _controller.isDismissed ? 0 : 10.0),
                                Flexible(
                                  child: Text(texts[index],
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false),
                                ),
                              ],
                            ),
                          )),
                    ],
                  )),
            );
            return child;
          }).toList()
            ..add(
              FloatingActionButton(
                heroTag: "floating_button",
                backgroundColor: Colors.white,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return Transform(
                      transform:
                          Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: Icon(
                          _controller.isDismissed ? Icons.add : Icons.close,
                          size: _controller.isDismissed ? 25 : 20,
                          color: MyColors().mainColor),
                    );
                  },
                ),
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                    setState(() {
                      width = 140;
                    });
                  } else {
                    _controller.reverse();
                    setState(() {
                      width = 60;
                    });
                  }
                },
              ),
            ),
        ),
      ),
    );
  }

  Future<void> addUserFromContacts() async {
    bool premmision = await FlutterContactPicker.hasPermission();
    if (!premmision) {
      await FlutterContactPicker.requestPermission();
      return;
    }
    PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    if (contact.phoneNumber == null) {
      print('Contact does not have phone number');
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
      return;
    }
  }
}
