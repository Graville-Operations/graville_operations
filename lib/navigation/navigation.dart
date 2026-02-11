import 'package:flutter/material.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/inventory/InventoryScreen.dart';
import 'package:graville_operations/screens/workers/WorkersScreen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const WorkersScreen(),
    const InventoryScreen(),
    const AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    Color activeColor = Colors.blue.shade900;
    Color inActiveColor = Colors.blue.shade100;
    List<BottomNavigationBarItem> bottomItems = [
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
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: bottomItems,
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

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Account Screen"),
    );
  }
}

