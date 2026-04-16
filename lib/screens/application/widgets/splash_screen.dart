import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/local/store/values.dart';
import 'package:graville_operations/core/routes/names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
  await Future.delayed(const Duration(milliseconds: 500));

  // Always clear stored session
  await StorageService.to.remove(storageUserTokenKey);
  await StorageService.to.remove(storageUserProfileKey);
  await StorageService.to.remove(userMenus);
  await StorageService.to.remove(menuTokenKey);

  Get.offAllNamed(AppRoutes.login);
}

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}