import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/user_data.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/remote/api/auth_api.dart';
import 'package:graville_operations/core/remote/dto/requests/login.dart';
import 'package:graville_operations/core/routes/routes.dart';
import 'package:graville_operations/screens/auth/login/state.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>(); // ✅ ADD THIS

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
    // ✅ validate BEFORE login
    if (!formKey.currentState!.validate()) {
      return "Invalid form";
    }

    String res = "Unexpected Error Occurred";
    EasyLoading.show(status: "Logging you in....");

    try {
      LoginRequest request = LoginRequest(
        username: state.email.text,
        password: state.psw.text,
      );

      var result = await AuthApi.login(request);

      EasyLoading.show(status: 'Updating profile info .....');

      await UserStore.to.setToken(result.accessToken);

      var me = await AuthApi.me();
      await UserStore.to.saveProfile(me.toUserData());

      EasyLoading.showSuccess('Logged in Successfully');

      Get.offAllNamed(AppRoutes.application);

      return "Success";
    } catch (e) {
      res = "...error in login ${e.toString()}";
      debugPrint(res);

      EasyLoading.showError("Login failed"); // ✅ better UX

      return res;
    }
  }
}
