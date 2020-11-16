import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Contact {
  String uid;
  Timestamp addedOn;
  Contact({
    @required this.uid,
    @required this.addedOn,
  });

  Map toMap(Contact contact){
    var data = Map<String, dynamic>();
      data['uid'] = contact.uid;
      data['addedOn'] = contact.addedOn;
    return data;
  }

  Contact.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['uid'];
    this.addedOn = mapData['addedOn'];
  }
}
