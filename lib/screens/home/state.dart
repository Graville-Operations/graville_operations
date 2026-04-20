
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';

class HomeState{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isFabOpen = false.obs;
  RxInt totalWorkers = 0.obs;
  RxBool workersLoading = false.obs;
  RxBool attendeesLoading = false.obs;
  RxInt presentToday = 0.obs;
  RxList<MenuItem> drawerMenus = <MenuItem>[].obs;
}