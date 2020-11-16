import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();
  OnlineDotIndicator({@required this.uid});
  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.OFFLINE:
          return Colors.red;
        case UserState.ONLINE:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          OurUser user;
          if (snapshot.hasData && snapshot.data.data() != null) {
            user = OurUser.fromMap(snapshot.data.data());
          }
          return Positioned(
            top: 42,
            left: 40,
            child: Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 8, top: 8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: getColor(user?.state)),
            ),
          );
        });
  }
}
