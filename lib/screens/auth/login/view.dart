import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:graville_operations/screens/auth/forgot_password/forgot_password.dart';
import 'package:graville_operations/screens/auth/signup/signup_screen.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';

import 'controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
  Widget socialIcon(IconData icon, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {},
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        //child: FaIcon(icon, color: color, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[500],
      body: Stack(children: [
        // ✅ Background
        SizedBox.expand(
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),

          // ✅ Blur overlay (optional)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Form(
              key: controller.formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 500,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome to Graville Enterprises Limited!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      'Please enter your credentials',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Log in to your account",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ EMAIL
                    CustomTextInput(
                      controller: controller.state.email,
                      labelText: "Email",
                      hintText: "example@gmail.com",
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter email';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // ✅ PASSWORD (reactive)
                    Obx(() => CustomTextInput(
                      controller: controller.state.psw,
                      labelText: "Password",
                      hintText: "********",
                      prefixIcon: Icons.lock,
                      suffixIcon: controller.state.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      isObscure:
                      controller.state.obscurePassword.value,
                      isPassword:
                      controller.state.obscurePassword.value,
                      onSuffixIconPressed:
                      controller.togglePasswordVisibility,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter password';
                        }
                        if (value.length < 8) {
                          return 'Min 8 characters';
                        }
                        return null;
                      },
                    )),

                    // ✅ Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.to(() => ForgotPasswordScreen()),
                        child: const Text("Forgot password?"),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ LOGIN BUTTON
                    CustomButton(
                      label: "Log In",
                      width: double.infinity,
                      onPressed: controller.login,
                    ),

                    const SizedBox(height: 20),

                    // ✅ Divider
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("OR"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ✅ Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        InkWell(
                          onTap: () => Get.to(() => const Signup()),
                          child: const Text(
                            "Sign Up",
                            style:
                            TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ✅ Social icons (optional UI)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ]),
    );
  }
}