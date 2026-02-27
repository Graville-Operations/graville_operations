import 'package:flutter/material.dart';
import 'package:graville_operations/screens/auth/login/login_screen.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';

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
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
