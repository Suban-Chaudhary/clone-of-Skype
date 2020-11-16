import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/enum/user_state.dart';

class Utils{
  static String getUsername(String email) {
    return "live:${email.split("@")[0]}";
  }

  static getInitials(String name){
    List<String> nameSplit = name.split(" ");
    String firstNameInitital = nameSplit[0][0];
    String lastNameInitital = nameSplit[1][0];
    return firstNameInitital + lastNameInitital;
  }

  static Future<File> pickImage(ImageSource source) async {
    PickedFile pickedFile  = await ImagePicker().getImage(source: source);
    File selectedImage = File(pickedFile.path);
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int random = Random().nextInt(100000);
    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, height: 500, width: 500);

    return File('$path/img_$random.jpg')..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState){
    switch(userState){
      case UserState.OFFLINE:
        return 0;
      case UserState.ONLINE:
        return 1;
      default:
        return 2;
    }
  }
  
  static UserState numToState(int number){
    switch(number){
      case 0:
        return UserState.OFFLINE;
      case 1:
        return UserState.ONLINE;
      default:
        return UserState.WAITING;
    }
  }
  
  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
  
}