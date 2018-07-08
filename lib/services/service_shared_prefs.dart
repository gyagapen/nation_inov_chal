import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class MausafeSharedPreferences {
  static Future<String> getStoredHelpRequestId() async {
    String helpReqId = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    helpReqId = prefs.getString('help_request_id');

    return helpReqId;
  }

  static void setStoredHelpRequestId(String newReqId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('help_request_id', newReqId);
  }
}
