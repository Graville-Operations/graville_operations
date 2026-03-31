import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/routes/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? priority = 0; // priority smaller the better

  AuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin == true||
        route == AppRoutes.login ||
        route == AppRoutes.initial) {
      return null;
    } else {
      Future.delayed(
        const Duration(seconds: 1),
        () => Get.snackbar("Tips", "Login expired, please login"),
      );
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}
