import 'package:flutter/material.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  OurUser user = OurUser();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<OurUser> getUserDetails() async {
    User currentUser = await getCurrentUser();
    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();
    return OurUser.fromMap(documentSnapshot.data());
  }

  Future<OurUser> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return OurUser.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);
    UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = OurUser(
        uid: currentUser.uid,
        email: currentUser.email,
        profilePhoto: currentUser.photoURL,
        name: currentUser.displayName,
        username: username);
    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(user.toMap(user));
  }

  Future<List<OurUser>> fetchAllUsers(User currentUser) async {
    List<OurUser> userList = [];

    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(OurUser.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({"state": stateNum});
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.doc(uid).snapshots();
}
