import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setTheme(String mode) {
    if (mode == "dark") {
      _themeMode = ThemeMode.dark;
    } else if (mode == "light") {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners(); // 🔥 this rebuilds entire app
  }
}
