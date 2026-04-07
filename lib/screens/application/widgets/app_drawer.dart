

import 'package:flutter/material.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/screens/application/widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final List<MenuItem> drawerMenus;
  const AppDrawer({super.key, required this.drawerMenus});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              color: Colors.blue.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.widgets_rounded, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    "More Options",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Drawer menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: drawerMenus
                    .map((menu) => DrawerMenuTile(menu: menu))
                    .toList(),
              ),
            ),

            const Divider(),

            // Bottom: logout
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade400),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.red.shade400),
              ),
              onTap: () {
                // TODO: controller.logout()
              },
            ),
          ],
        ),
      ),
    );
  }
}