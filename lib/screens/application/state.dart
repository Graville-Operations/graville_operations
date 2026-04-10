import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';

class ApplicationState {
  RxInt currentIndex = 0.obs;
  RxList<MenuItem> bottomMenus = <MenuItem>[].obs;
  RxList<MenuItem> drawerMenus = <MenuItem>[].obs;
}
