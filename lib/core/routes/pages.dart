import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/middleware/auth_middleware.dart';
import 'package:graville_operations/screens/admin/create_user_screen.dart';
import 'package:graville_operations/screens/admin/users_list_screen.dart';
import 'package:graville_operations/screens/application/binding.dart';
import 'package:graville_operations/screens/application/view.dart';
import 'package:graville_operations/screens/auth/login/binding.dart';
import 'package:graville_operations/screens/auth/login/view.dart';
import 'package:graville_operations/screens/finance_dashboard/finance_dashboard.dart';
import 'package:graville_operations/screens/projects/dashboard/assign_user_screen.dart';
import 'package:graville_operations/screens/invoice/invoice_screen.dart';
import 'package:graville_operations/screens/menus/menus.dart';
import 'package:graville_operations/screens/projects/dashboard/binding.dart';
import 'package:graville_operations/screens/projects/dashboard/view.dart';
import 'package:graville_operations/screens/sites/create/view.dart';

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
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBindings(),
    ),
    GetPage(
        name: AppPages.application,
        page: () => ApplicationScreen(),
        binding: ApplicationBindings(),
        middlewares: [AuthMiddleware(priority: 0)]),
    GetPage(
        name: AppRoutes.projectDashboard,
        page: () => ProjectDashboardScreen(),
        binding: ProjectDashboardBindings()),
    GetPage(name: AppRoutes.createProject, page: () => CreateSitesScreen()),
    GetPage(
        name: AppRoutes.userDepartment, page: () => AssignUserToGroupScreen()),
    //   name: AppPages.application,
    //   page: () => ApplicationScreen(),
    //   binding: ApplicationBindings(),
    //   middlewares: [AuthMiddleware(priority: 0)],
    // ),
    GetPage(
      name: AppRoutes.projectDashboard,
      page: () => ProjectDashboardScreen(),
      binding: ProjectDashboardBindings(),
    ),
    GetPage(
      name: AppRoutes.createProject,
      page: () => CreateSitesScreen(),
    ),
    // Users menu routes
    GetPage(
      name: AppRoutes.usersDashboard,
      page: () => const UsersListScreen(),
    ),
    GetPage(
      name: AppRoutes.createUser,
      page: () => const CreateUserScreen(),
    ),
    GetPage(
      name: AppRoutes.userRoles,
      page: () => const UsersListScreen(),
    ),
    GetPage(name: AppRoutes.userDepartment, page: ()=>AssignUserToGroupScreen(),),

    // ─── Finance menu routes
    GetPage(
      name: AppRoutes.financeDashboard,
      page: () => const FinanceDashboardApp(),
    ),
    GetPage(
      name: AppRoutes.financeInvoices,
      page: () => const InvoiceScreen(),
    ),
    GetPage(
      name: AppRoutes.menuDepartments,
      page: () => const MenusScreen(),
    )
  ];
}
