import 'dart:async';
import 'dart:convert';
import 'package:frolicsports/constance/constance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frolicsports/constance/global.dart';
import 'package:frolicsports/models/userData.dart';

class MySharedPreferences {
  Future clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return;
  }

  Future<String> getUsertokenString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(ConstanceData.Usertoken) == null) {
      await prefs.setString(ConstanceData.Usertoken, '');
    }
    return prefs.getString(ConstanceData.Usertoken);
  }

  Future<UserData> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(ConstanceData.UserData) == null) {
      await prefs.setString(ConstanceData.UserData, '');
    }
    var userDataTxt = prefs.getString(ConstanceData.UserData);
    if (userDataTxt != '') {
      UserData userData = UserData.fromJson(jsonDecode(userDataTxt));
      return userData;
    } else {
//      return userdata;//
    }
  }

  Future setUserDataString(UserData userData) async {
    if (userData != null) {
      final usertxt = jsonEncode(userData);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(ConstanceData.UserData, usertxt);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(ConstanceData.UserData, '');
    }
  }
}
