import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.dart';

class AppTheme {
  final horizontalMargin = 16.0.w;
  final radius = 10.h;

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.scaffoldBackground,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    primaryColor: AppColor.primaryBackground,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColor.primaryBackground,
    ),
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColor.primaryBackground,
      ),
      backgroundColor: AppColor.primaryBackground,
      iconTheme: IconThemeData(
        color: AppColor.scaffoldBackground,
      ),
      titleTextStyle: TextStyle(
        color: AppColor.scaffoldBackground,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      toolbarTextStyle: TextStyle(
        color: AppColor.primaryText,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.scaffoldBackground,
      unselectedLabelStyle: TextStyle(fontSize: 12),
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedItemColor: Color.fromRGBO(76, 76, 76, 1),
      selectedItemColor: AppColor.primaryBackground,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppColor.accentColor,
      unselectedLabelColor: AppColor.secondaryText,
    ),
  );
}
