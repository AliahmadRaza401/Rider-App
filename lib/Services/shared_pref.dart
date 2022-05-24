import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_element

class SharedPref {
  static userLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userLoggedIn', value);
  }

  static getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool('userLoggedIn');
    return boolValue;
  }

  static saveUserFirstTime(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userFirstTime', value);
  }

  static getUserFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool('userFirstTime');
    return boolValue;
  }

    static saverememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', value);
  }

  static getrememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool('rememberMe');
    return boolValue;
  }

  static saveUserId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', value);
  }

  static getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('userId');
    return value;
  }

  static saveUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', value);
  }

  static getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('userName');
    return value;
  }

  static saveCookieId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cookieId', value);
  }

  static getCookieId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('cookieId');
    return value;
  }

  static saveUserEmail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', value);
  }

  static getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('userEmail');
    return value;
  }

  static saveUserPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userPassword', value);
  }

  static getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String? value = prefs.getString('userPassword');
    return value;
  }
}
