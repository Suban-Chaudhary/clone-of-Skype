import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/models/contact.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/resources/chat_methods.dart';
import 'package:skype_clone/screens/chat_screens/chat_screen.dart';
import 'package:skype_clone/screens/chat_screens/widgets/cached_image.dart';
import 'package:skype_clone/screens/pageviews/widgets/last_message_container.dart';
import 'package:skype_clone/screens/pageviews/widgets/online_indicator.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  ContactView(this.contact);
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OurUser>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          OurUser user = snapshot.data;
          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final OurUser contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({@required this.contact});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiver: contact,
          ),
        ),
      ),
      title: Text(
        contact?.name ?? "..",
        style:
            TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.uid, receiverId: contact.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
