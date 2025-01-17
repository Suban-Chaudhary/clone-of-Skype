import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/auth_methods.dart';
import 'package:skype_clone/screens/call_screens/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/chat_screens/chat_screen.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods _authMethods = AuthMethods();
  List<OurUser> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUserInfo();
  }

  currentUserInfo() {
    _authMethods.getCurrentUser().then((User user) {
      _authMethods.fetchAllUsers(user).then((List<OurUser> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      backgroundColorStart: UniversalVariables.gradientColorStart,
      backgroundColorEnd: UniversalVariables.gradientColorEnd,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                color: Colors.white,
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<OurUser> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((OurUser user) {
                String _getUsername = user.username.toLowerCase();
                String _getName = user.name.toLowerCase();
                String _query = query.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesName || matchesUsername);
                // user.username.toLowerCase().contains(query.toLowerCase()) ||
                //     user.name.toLowerCase().contains(query.toLowerCase());
              }).toList()
            : [];

    return ListView.builder(
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            OurUser searchedUser = OurUser(
              uid: suggestionList[index].uid,
              profilePhoto: suggestionList[index].profilePhoto,
              name: suggestionList[index].name,
              username: suggestionList[index].username,
            );
            return CustomTile(
              mini: false,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatScreen(
                    receiver: searchedUser,
                  );
                }));
              },
              leading: CircleAvatar(
                // backgroundImage: NetworkImage(searchedUser.profilePhoto),
                backgroundColor: Colors.grey,
              ),
              title: Text(
                searchedUser.username,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                searchedUser.name,
                style: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
              ),
            );
          },
        ) ??
        Container();
  }

  @override
   Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ),
      ),
    );
  }
}
