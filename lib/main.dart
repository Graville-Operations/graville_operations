import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/screens/invoice/invoice_screen.dart';
import 'package:graville_operations/global.dart';
import 'package:graville_operations/models/dashboard/assign_user_screen.dart';
import 'core/routes/routes.dart';
import 'core/style/theme.dart';

void main() async {
 await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.initial,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
    );
  }
}