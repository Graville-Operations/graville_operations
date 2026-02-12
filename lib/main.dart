import 'package:flutter/material.dart';
import 'package:graville_operations/screens/account_screen/account_screen.dart';
import 'package:graville_operations/screens/forgot_password/forgot_password.dart';
import 'package:graville_operations/screens/login/login_screen.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forgot Password Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
