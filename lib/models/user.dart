class OurUser{
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  OurUser({this.uid, this.name, this.email, this.username, this.status, this.profilePhoto});

  Map toMap(OurUser user){
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data['status'] = user.status;
    data['state'] = user.state;
    data['profilePhoto'] = user.profilePhoto;
    return data;
  }


  OurUser.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }
}