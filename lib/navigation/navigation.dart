import 'package:flutter/material.dart';
import 'package:graville_operations/screens/account_screen/account_screen.dart';
import 'package:graville_operations/screens/admin/admin_dashboard.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/inventory/inventory_screen.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';
import 'package:graville_operations/services/api_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _role = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  void _loadRole() async {
    final role = await ApiService.getRole();
    setState(() {
      _role = role ?? '';
      _isLoading = false;
    });
  }

  List<Widget> get _screens {
    final base = [
      const HomeScreen(),
      const WorkersScreen(),
      const InventoryScreen(),
      const AccountScreen(),
    ];

    if (_role == 'admin') {
      base.add(const AdminDashboard());
    }

    return base;
  }

  List<BottomNavigationBarItem> get _bottomItems {
    Color activeColor = Colors.blue.shade900;
    Color inActiveColor = Colors.blue.shade100;

    final base = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined, color: inActiveColor),
        activeIcon: Icon(Icons.home_filled, color: activeColor),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_outlined, color: inActiveColor),
        activeIcon: Icon(Icons.people, color: activeColor),
        label: "Workers",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_outlined, color: inActiveColor),
        activeIcon: Icon(Icons.inventory, color: activeColor),
        label: "Inventory",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_2_outlined, color: inActiveColor),
        activeIcon: Icon(Icons.person, color: activeColor),
        label: "Account",
      ),
    ];

    if (_role == 'admin') {
      base.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined, color: inActiveColor),
          activeIcon: Icon(Icons.admin_panel_settings, color: activeColor),
          label: "Admin",
        ),
      );
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _bottomItems,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}