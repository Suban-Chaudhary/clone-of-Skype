class Call{
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool hasDialed;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.channelId,
    this.hasDialed,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
  });

  Map<String, dynamic> toMap(Call call){
    Map<String, dynamic> callMap = Map();
      callMap['callerId'] = call.callerId;
      callMap['callerName'] = call.callerName;
      callMap['callerPic'] = call.callerPic;
      callMap['receiverId'] = call.receiverId;
      callMap['receiverName'] = call.receiverName;
      callMap['receiverPic'] = call.receiverPic;
      callMap['channelId'] = call.channelId;
      callMap['hasDialed'] = call.hasDialed;
    return callMap;
  }

  Call.fromMap(Map callMap){
    this.callerId = callMap['callerId'];
    this.callerName = callMap['callerName'];
    this.callerPic = callMap['callerPic'];
    this.receiverId = callMap['receiverId'];
    this.receiverName = callMap['receiverName'];
    this.receiverPic = callMap['receiverPic'];
    this.channelId = callMap['channelId'];
    this.hasDialed = callMap['hasDialed'];
  }

}