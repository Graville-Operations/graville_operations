import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:graville_operations/screens/auth/login/login_screen.dart';
=======
import 'package:graville_operations/screens/login/login_screen.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
>>>>>>> e4baeb1518eda4cf290b4a1b8f3d194dc8465fe2

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
