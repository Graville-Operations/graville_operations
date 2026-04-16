import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/local/entities/user_data.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/remote/api/menus.dart';
import 'package:graville_operations/core/routes/routes.dart';
import 'package:graville_operations/screens/auth/login/state.dart';
import 'package:graville_operations/services/api_service.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  var state = LoginState();

  void goToSignUp() {
    Get.toNamed(AppRoutes.signup);
  }

  void goToApplication() {
    Get.toNamed(AppRoutes.application);
  }

  void togglePasswordVisibility() {
    state.obscurePassword.toggle();
  }

  Future<String> login() async {
    if (!formKey.currentState!.validate()) {
      return "Invalid form";
    }

    EasyLoading.show(status: "Logging you in....");

    try {
      // Use ApiService which hits /refactor/login
      final result = await ApiService.login(
        state.email.text.trim(),
        state.psw.text.trim(),
      );

      if (result['success']) {
        final data = result['data'];
        final token = data['access_token'];
        final accountType = data['account_type'] ?? '';
        final user = data['user'];

        // Save token to UserStore
        await UserStore.to.setToken(token);

        // Save profile to UserStore
        await UserStore.to.saveProfile(UserData(
          id: user['id'],
          email: user['email'],
          firstName: user['first_name'],
          lastName: user['last_name'],
          accountType: accountType,
          enabled: true,
          groups: [],
        ));

        // Save role and user id to SharedPreferences
        await ApiService.saveRole(accountType);
        await ApiService.saveUserId(user['id'] ?? 0);

        EasyLoading.show(status: 'Loading your menus.....');

        // Fetch menus from backend, fall back to defaults if fails
        try {
          var menus = await MenuApi.getMyMenu();
          if (menus.isEmpty) {
            await _assignDefaultMenus(accountType, token);
          } else {
            await UserStore.to.saveMenus(menus, token);
          }
        } catch (e) {
          debugPrint('Menu fetch failed: $e — using defaults');
          await _assignDefaultMenus(accountType, token);
        }

        EasyLoading.showSuccess('Logged in Successfully');
        Get.offAllNamed(AppRoutes.application);
        return "Success";
      } else {
        EasyLoading.showError(result['message'] ?? 'Login failed');
        return result['message'] ?? 'Login failed';
      }
    } catch (e) {
      debugPrint("...error in login ${e.toString()}");
      EasyLoading.showError("Login failed");
      return e.toString();
    }
  }

  Future<void> _assignDefaultMenus(String role, String token) async {
    final defaultMenus = [
      const MenuItem(id: 1, name: 'home', title: 'Home', priority: 1),
      const MenuItem(id: 2, name: 'workers', title: 'Workers', priority: 2),
      const MenuItem(id: 3, name: 'inventory', title: 'Inventory', priority: 3),
      const MenuItem(id: 4, name: 'account', title: 'Account', priority: 4),
    ];
    await UserStore.to.saveMenus(defaultMenus, token);
  }
}