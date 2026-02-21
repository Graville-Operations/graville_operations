import 'package:flutter/material.dart';
import 'package:graville_operations/screens/Inventory_Screen/inventory_screen.dart';
import 'package:graville_operations/screens/login/login_screen.dart';
import 'package:graville_operations/screens/settings_screen/settings_screen.dart';
//import 'package:graville_operations/screens/worker_profile_screen.dart';
import 'package:graville_operations/screens/workers_screen/worker_profile_screen.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'graville operations',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
      ),
     home: const WorkerProfileScreen(),
    );
  }
}
