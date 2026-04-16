
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/screens/application/controller.dart';

class SplashScreen extends GetView<ApplicationController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: CircularProgressIndicator()));
}