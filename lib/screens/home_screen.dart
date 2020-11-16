import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/resources/local_db/repository/local_repository.dart';
import 'package:skype_clone/screens/call_screens/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/pageviews/chatlist_screen.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  AuthMethods _authMethods = AuthMethods();

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.ONLINE,
      );

      LogRepository.init(isHive: false, dbName: userProvider.getUser.uid);
    });
    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.ONLINE)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.OFFLINE)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.WAITING)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.OFFLINE)
            : print("detached state");
        break;
    }
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(
                child:
                    Text("Call Logs", style: TextStyle(color: Colors.white))),
            Center(
                child: Text("Contact Screen",
                    style: TextStyle(color: Colors.white))),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: UniversalVariables.blackColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: (_page == 0)
                      ? UniversalVariables.blueColor
                      : UniversalVariables.greyColor,
                ),
                label: ("Chats"),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call,
                  color: (_page == 1)
                      ? UniversalVariables.blueColor
                      : UniversalVariables.greyColor,
                ),
                label: ("Chats"),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.contact_phone,
                  color: (_page == 2)
                      ? UniversalVariables.blueColor
                      : UniversalVariables.greyColor,
                ),
                label: ("Chats"),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
