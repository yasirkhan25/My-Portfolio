import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMap = {
  "dark": ThemeMode.dark,
  "light": ThemeMode.light,
};

class AppProvider extends ChangeNotifier {
  static AppProvider state(BuildContext context, [bool listen = false]) =>
      Provider.of<AppProvider>(context, listen: listen);

  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void init() async {
    final prefs = await SharedPreferences.getInstance();

    String? stringTheme = prefs.getString('theme');

    ThemeMode? theme =
        stringTheme == null ? ThemeMode.dark : themeMap[stringTheme];

    if (theme == null) {
      await prefs.setString(
          'theme', ThemeMode.dark.toString().split(".").last);

      _themeMode = ThemeMode.dark;
    }
    _themeMode = theme!;

    notifyListeners();
  }

  void setTheme(ThemeMode newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_themeMode == newTheme) {
      return;
    }
    _themeMode = newTheme;

    await prefs.setString(
      'theme',
      newTheme.toString().split('.').last,
    );
    notifyListeners();
  }
}
