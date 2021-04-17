import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('userId');
}

Future<bool> setUserId(String usrId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString('userId', usrId);
}
