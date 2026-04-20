import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/screens/account_screen/binding.dart';
import 'package:graville_operations/screens/account_screen/controller.dart';
import 'package:graville_operations/screens/account_screen/view.dart';
import 'package:graville_operations/screens/home/binding.dart';
import 'package:graville_operations/screens/home/controller.dart';
import 'package:graville_operations/screens/home/view.dart';
import 'package:graville_operations/screens/store/inventory/binding.dart';
import 'package:graville_operations/screens/store/inventory/controller.dart';
import 'package:graville_operations/screens/store/inventory/view.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';

class MenuRegistry {
  static final Map<String, WidgetBuilder> screens = {
    'home': (_) {
      if (!Get.isRegistered<HomeScreenController>()) {
        HomeScreenBindings().dependencies();
      }
      return const HomeScreen();
    },
    'workers': (_) => const WorkersScreen(),
    'inventory': (_) {
      if (!Get.isRegistered<InventoryScreenController>()) {
        InventoryScreenBinding().dependencies();
      }
      return const InventoryScreen();
    },
    'account': (_) {
      if (!Get.isRegistered<AccountScreenController>()) {
        AccountScreenBinding().dependencies();
      }
      return const AccountScreen();
    },
  };

  static const Map<String, IconData> activeIcons = {
    'home': Icons.home_filled,
    'workers': Icons.people,
    'inventory': Icons.inventory,
    'account': Icons.person,
  };

  static const Map<String, IconData> inactiveIcons = {
    'home': Icons.home_outlined,
    'workers': Icons.people_alt_outlined,
    'inventory': Icons.inventory_2_outlined,
    'account': Icons.person_2_outlined,
  };
}
