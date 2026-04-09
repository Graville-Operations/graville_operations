
import 'package:flutter/material.dart';
import 'package:graville_operations/screens/account_screen/account_screen.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/inventory/inventory_screen.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';

class MenuRegistry {
  static const Map<String, Widget> screens = {
    'home': HomeScreen(),
    'workers': WorkersScreen(),
    'inventory': InventoryScreen(),
    'account': AccountScreen(),
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