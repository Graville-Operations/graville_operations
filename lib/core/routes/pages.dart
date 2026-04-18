import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/middleware/auth_middleware.dart';
import 'package:graville_operations/screens/account_screen/binding.dart';
import 'package:graville_operations/screens/account_screen/view.dart';
import 'package:graville_operations/screens/application/binding.dart';
import 'package:graville_operations/screens/application/view.dart';
import 'package:graville_operations/screens/auth/login/binding.dart';
import 'package:graville_operations/screens/auth/login/view.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/projects/dashboard/binding.dart';
import 'package:graville_operations/screens/projects/dashboard/view.dart';
import 'package:graville_operations/screens/sites/create/bindings.dart';
import 'package:graville_operations/screens/sites/create/view.dart';
import 'package:graville_operations/screens/store/hired_tools/bindings.dart';
import 'package:graville_operations/screens/store/hired_tools/view.dart';
import 'package:graville_operations/screens/store/inventory/binding.dart';
import 'package:graville_operations/screens/store/inventory/view.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';

import 'routes.dart';

class AppPages {
  static const initial = AppRoutes.initial;
  static const application = AppRoutes.application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = _rawRoutes
      .map((page) => GetPage(
            name: page.name,
            page: page.page,
            binding: page.binding,
            middlewares: [AuthMiddleware(priority: 0)],
          ))
      .toList();
  static final List<GetPage> _rawRoutes = [
    // about bootup of an app
    // GetPage(
    //   name: AppRoutes.initial,
    //   page: () => const SplashScreen(),
    //   binding: ApplicationBindings()
    // ),
    GetPage(
        name: AppRoutes.initial,
        page: () => const LoginScreen(),
        binding: LoginBindings()),
    GetPage(
        name: AppPages.application,
        page: () => ApplicationScreen(),
        binding: ApplicationBindings()),
    GetPage(
      name: AppRoutes.projectDashboard,
      page: () => ProjectDashboardScreen(),
      binding: ProjectDashboardBindings(),
    ),
    GetPage(
      name: AppRoutes.createProject,
      page: () => CreateSitesScreen(),
      binding: CreateSiteBindings(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      // binding: Home(),
    ),
    GetPage(
      name: AppRoutes.workers,
      page: () => WorkersScreen(),
      // binding: InventoryScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.store,
      page: () => InventoryScreen(),
      binding: InventoryScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.account,
      page: () => AccountScreen(),
      // binding: InventoryScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.account,
      page: () => AccountScreen(),
      binding: AccountScreenBinding(),
    )
  ];
}
