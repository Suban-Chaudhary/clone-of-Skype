import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/resources/local_db/repository/local_repository.dart';
import 'package:skype_clone/screens/call_screens/call_screen.dart';
import 'dart:math';

class CallUtils {
  static final CallMethods callMethods = CallMethods();
  static dial({OurUser from, OurUser to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random.secure().nextInt(10000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialed = true;
    if (callMade) {
      LogRepository.addLogs(log);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CallScreen(call: call)),
      );
    }
  }
}
