import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';



import 'package:graville_operations/screens/account_screen/account_screen.dart';
import 'package:graville_operations/screens/application/controller.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/inventory/inventory_screen.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';

class ApplicationScreen extends GetView<ApplicationController> {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const WorkersScreen(),
      const InventoryScreen(),
      const AccountScreen(),
    ];

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

    return Obx(() => Scaffold(
      body: screens[controller.state.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.state.currentIndex.value,
        items: bottomItems,
        type: BottomNavigationBarType.fixed,
        onTap: controller.changeIndex,
      ),
    ));
  }
}