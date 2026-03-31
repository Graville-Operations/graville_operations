import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool get isDarkMode =>  false;

  ThemeMode get theme => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}