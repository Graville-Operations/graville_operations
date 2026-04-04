

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/values.dart';
//
// class MenuStore extends GetxController {
//   static MenuStore get to => Get.find();
//
//
//
//   static Future<void> saveMenusIfNeeded(List<MenuItem> menus, String currentToken) async {
//     final savedToken = StorageService.to.getString(menuTokenKey);
//     if (savedToken == currentToken && getMenus().isNotEmpty) {
//       debugPrint("...... menus already up to date, skipping save");
//       return;
//     }
//     await saveMenus(menus, currentToken);
//   }
//   static Future<void> saveMenus(List<MenuItem> menus, String currentToken) async {
//     final encoded = jsonEncode(menus.map((m) => m.toJson()).toList());
//     await StorageService.to.setString(userMenus, encoded);
//     await StorageService.to.setString(menuTokenKey, currentToken);
//     debugPrint("...... menus saved successfully");
//   }
//
//   static List<MenuItem> getMenus() {
//     final raw = StorageService.to.getString(userMenus);
//     if (raw.isEmpty) return [];
//
//     try {
//       final List<dynamic> decoded = jsonDecode(raw);
//       return decoded.map((menus) => MenuItem.fromJson(menus)).toList();
//     } catch (e) {
//       debugPrint("...... error reading menus $e");
//       return [];
//     }
//   }
//   static Future<void> clearMenus() async {
//     await StorageService.to.remove(userMenus);
//     await StorageService.to.remove(menuTokenKey);
//   }
//
//   static Future<void> updateMenu()async{
//
//   }
// }