import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/screens/application/binding.dart';
import 'package:graville_operations/screens/application/view.dart';
import 'package:graville_operations/screens/auth/login/binding.dart';
import 'package:graville_operations/screens/auth/login/view.dart';

import 'routes.dart';

class AppPages {
  static const initial = AppRoutes.initial;
  static const application = AppRoutes.application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    // about bootup of an app
    GetPage(
      name: AppRoutes.initial,
      page: () => const LoginScreen(),
      binding: LoginBindings(),
    ),
    GetPage(
        name: AppPages.application,
        page: ()=>ApplicationScreen(),
      binding: ApplicationBindings()
    )
   ];
}
