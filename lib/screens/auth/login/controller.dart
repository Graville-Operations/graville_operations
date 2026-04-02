import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/user_data.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
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
      final result = await ApiService.login(
        state.email.text.trim(),
        state.psw.text.trim(),
      );

      if (result['success']) {
        final data = result['data'];
        final user = data['user'];

        // Save token to UserStore (GetX storage)
        await UserStore.to.setToken(data['access_token']);

        // Save profile to UserStore using data from our backend
        await UserStore.to.saveProfile(UserData(
          id: user['id'],
          email: user['email'],
          firstName: user['first_name'],
          lastName: user['last_name'],
          accountType: user['role'],
          enabled: true,
          groups: [],
        ));

        // Also save to ApiService SharedPreferences for our screens
        await ApiService.saveRole(data['role']);
        await ApiService.saveUserId(user['id']);

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
}