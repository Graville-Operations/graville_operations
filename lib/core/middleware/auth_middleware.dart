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
    final isLoggedIn = UserStore.to.isLogin;
    if (isLoggedIn &&
        (route == AppRoutes.loginScreen || route == AppRoutes.initial)) {
      return const RouteSettings(name: AppRoutes.application);
    }
    if (!isLoggedIn &&
        route != AppRoutes.loginScreen &&
        route != AppRoutes.initial) {
      return const RouteSettings(name: AppRoutes.loginScreen);
    }

    return null;
  }
}
