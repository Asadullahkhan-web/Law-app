// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';

// class SharedPreferencesManager {
//   static SharedPreferences? preferences;

//   // Ensure that you're using the same instance of SharedPreferences.
//   static Future<SharedPreferences> getSharedPreferences() async {
//     preferences ??= await SharedPreferences.getInstance();
//     return preferences!;
//   }
// }

import 'package:flutter/material.dart';

class Constants {
  static const Color appColor = Colors.green;

  static screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
