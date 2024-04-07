import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/themes/dark_mode.dart';
import 'package:todo/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_themeData == lightMode) {
      themeData = darkMode;
      prefs.setString('theme', 'dark');
    } else {
      themeData = lightMode;
      prefs.setString('theme', 'light');
    }

    notifyListeners();
  }

  initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeData = prefs.getString('theme') == 'dark' ? darkMode : lightMode;
    notifyListeners();
  }
}
