import 'package:flutter/material.dart';
import 'package:graville_operations/screens/forgot_password/forgot_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Reset Demo',
      theme: ThemeData.dark(),
      home: const ForgotPasswordScreen(),
    );
  }
}
