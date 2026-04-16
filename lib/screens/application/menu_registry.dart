import 'package:flutter/material.dart';
import 'package:graville_operations/screens/account_screen/account_screen.dart';
import 'package:graville_operations/screens/admin/admin_dashboard.dart';
import 'package:graville_operations/screens/admin/create_user_screen.dart';
import 'package:graville_operations/screens/admin/users_list_screen.dart';
import 'package:graville_operations/screens/finance/finance_dashboard_screen.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/inventory/inventory_screen.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';

class MenuRegistry {
  static final Map<String, Widget> screens = {
    // Bottom nav screens
    'home': const HomeScreen(),
    'workers': const WorkersScreen(),
    'inventory': const InventoryScreen(),
    'account': const AccountScreen(),

    // Drawer screens
    'users': const CreateUserScreen(),
    'finance': const FinanceDashboardScreen(),
  };

  static final Map<String, IconData> activeIcons = {
    'home': Icons.home_filled,
    'workers': Icons.people,
    'inventory': Icons.inventory,
    'account': Icons.person,
    'users': Icons.manage_accounts,
    'finance': Icons.bar_chart,
    'admin': Icons.admin_panel_settings,
    'projects': Icons.folder,
    'departments': Icons.business,
  };

  static final Map<String, IconData> inactiveIcons = {
    'home': Icons.home_outlined,
    'workers': Icons.people_alt_outlined,
    'inventory': Icons.inventory_2_outlined,
    'account': Icons.person_2_outlined,
    'users': Icons.manage_accounts_outlined,
    'finance': Icons.bar_chart_outlined,
    'admin': Icons.admin_panel_settings_outlined,
    'projects': Icons.folder_outlined,
    'departments': Icons.business_outlined,
  };
}