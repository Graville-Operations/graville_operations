import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/middleware/auth_middleware.dart';
import 'package:graville_operations/screens/application/binding.dart';
import 'package:graville_operations/screens/application/view.dart';
import 'package:graville_operations/screens/auth/login/binding.dart';
import 'package:graville_operations/screens/auth/login/view.dart';
import 'package:graville_operations/screens/projects/dashboard/binding.dart';
import 'package:graville_operations/screens/projects/dashboard/view.dart';
import 'package:graville_operations/screens/sites/create_sites.dart';

import 'routes.dart';

class AppPages {
  static const initial = AppRoutes.initial;
  static const application = AppRoutes.application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    // about bootup of an app
    // GetPage(
    //   name: AppRoutes.initial,
    //   page: () => const SplashScreen(),
    //   binding: ApplicationBindings()
    // ),
    GetPage(
      name: AppRoutes.initial,
      page: () => const LoginScreen(),
      binding: LoginBindings(),
    ),
    GetPage(
        name: AppPages.application,
        page: () => ApplicationScreen(),
        binding: ApplicationBindings(),
        middlewares: [AuthMiddleware(priority: 0)]
    ),
    GetPage(
        name: AppRoutes.projectDashboard,
        page: () => ProjectDashboardScreen(),
        binding: ProjectDashboardBindings()
    ),
    GetPage(
      name: AppRoutes.createProject,
      page: ()=> CreateSitesScreen()
    ),
  ];
}
