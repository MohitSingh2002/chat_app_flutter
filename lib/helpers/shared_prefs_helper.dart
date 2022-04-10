import 'dart:convert';

import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {

  void saveProfile(Profile profile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(Constants.profile, jsonEncode(profile.toJson()));
  }

  Future<Profile?> getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? profileFromSharedPreferences = sharedPreferences.getString(Constants.profile);
    if (profileFromSharedPreferences == null) {
      return null;
    } else {
      return Profile.fromJson(jsonDecode(profileFromSharedPreferences));
    }
  }

  void clearAll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

}
