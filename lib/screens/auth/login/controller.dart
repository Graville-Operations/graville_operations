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
    String res = "Unexpected Error Occurred";
    EasyLoading.show(status: "Logging you in....");
    try {
      LoginRequest request =
          LoginRequest(username: state.email.text, password: state.psw.text);
      var result = await AuthApi.login(request);
      print('✅ Raw login response userId: ${result.userId}');
      print('✅ Raw login response email: ${result.email}');
      print('✅ Raw login response role: ${result.role}');
      await UserStore.to.setToken(result.accessToken);

      // Save user data directly from login response — no me() call needed
      await UserStore.to.saveProfile(UserData(
        id: result.userId,
        firstName: result.firstName,
        lastName: result.lastName,
        email: result.email,
        phoneNo: result.phoneNo,
      ));

      print('✅ Saved userId: ${UserStore.to.userId}');
      EasyLoading.showSuccess('Logged in Successfully');
      Get.offAllNamed(AppRoutes.application);
      return "Success";
    } catch (e) {
      res = "...error in login ${e.toString()}";
      debugPrint(res);
      return res;
    }
  }
}
