import 'package:flutter/cupertino.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  OurUser _user;
  AuthMethods _authMethods = AuthMethods();

  OurUser get getUser => _user;
  
  Future<void> refreshUser() async {
    OurUser user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}