import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/screens/auth/forgot_password/forgot_password.dart';
import 'package:graville_operations/screens/auth/signup/signup_screen.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';

import 'controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});
//   Widget socialIcon(IconData icon, Color color) {
//   return InkWell(
//     borderRadius: BorderRadius.circular(30),
//     onTap: () {},
//     child: CircleAvatar(
//       radius: 22,
//       backgroundColor: Colors.white,
//       child: FaIcon(
//         icon,
//         color: color,//   Widget socialIcon(IconData icon, Color color) {
//   return InkWell(
//     borderRadius: BorderRadius.circular(30),
//     onTap: () {},
//     child: CircleAvatar(
//       radius: 22,
//       backgroundColor: Colors.white,
//       child: FaIcon(
//         icon,
//         color: color,
//         size: 20,
//       ),
//     ),
//   );
// }
//   String? passwordErrFessage;
//
//   get body => null;

//         size: 20,
//       ),
//     ),
//   );
// }
//   String? passwordErrorMessage;
//   String? emailErrorMessage;
//
//   get body => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[500],
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              // ignore: deprecated_member_use
              child: Container(color: Colors.black.withOpacity(0)),
            ),
          ),

      SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 500,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome to Graville Enterprises Limited!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
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
                const SizedBox(height: 10),

                CustomTextInput(
                  controller: controller.state.email,
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  prefixIcon: Icons.email,
                  onSuffixIconPressed: () {},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                      return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextInput(
                  controller: controller.state.psw,
                  labelText: "Password",
                  hintText: "at least 8 characters",
                  prefixIcon: Icons.lock,
                  suffixIcon: controller.state.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                  isObscure: controller.state.obscurePassword.value,
                  isPassword: controller.state.obscurePassword.value,
                  onSuffixIconPressed: ()=>controller.togglePasswordVisibility(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                       builder: (context) => ForgotPasswordScreen(),
                       ),
                     ),
                    child: const Text(
                      " Forgot password?",
                     style: TextStyle(color: Colors.blue),
                    ),
                   ),
                 ),
                const SizedBox(height: 8),
                CustomButton(
                  label: "log in",
                  width: double.infinity,
                  onPressed: controller.login
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'OR',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 19),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          color: Colors.blue,
                      ),
                    ),

                    InkWell(
                        onTap: () {
                           Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => Signup()),
                            );
                            },
                             child: const Text(
                                     "Sign Up",
                               style: TextStyle(
                               color: Colors.blue,
                                 fontWeight: FontWeight.bold,
                               ),
                            ),
                         ),
                  ],
                ),
                
                // const SizedBox(height: 19),
                //    Center(
                //      child: Wrap(
                //        alignment: WrapAlignment.center,
                //          spacing: 15,
                //            children: [
                //              _socialIcon(FontAwesomeIcons.google, Colors.red),
                //              _socialIcon(FontAwesomeIcons.linkedinIn, Colors.blueAccent),
                //              _socialIcon(FontAwesomeIcons.facebookF, Colors.blue),
                //              _socialIcon(FontAwesomeIcons.instagram, Colors.purple),
                //              _socialIcon(FontAwesomeIcons.xTwitter, Colors.black),
                //          ],
                //        ),
                //      ),
              ],
            ),
          ),
        ),
      ),
        ],
    )
    );
  }
}