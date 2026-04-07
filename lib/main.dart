import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
//import 'package:graville_operations/screens/account_screen/account_screen.dart';

import 'core/routes/routes.dart';
import 'core/style/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<StorageService>(() async {
    return await StorageService().init();
  });
  Get.put(UserStore());
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
      // home: const AccountScreen(),
    );
  }
}
