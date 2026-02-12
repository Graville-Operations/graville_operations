import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graville_operations/navigation/navigation.dart' show MainNavigationScreen;
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/forgot_password/forgot_password.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/signup/signup_screen.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  Widget _socialIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {},
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200],
          child: FaIcon(icon, color: color, size: 20),
        ),
      ),
    );
  }
    void signUpUser() {
    if (_formKey.currentState!.validate()) {
      print("Signin Successful");

      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");
    }
  }

  String? passwordErrorMessage;
  String? emailErrorMessage;
  
  get body => null;

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
            key: _formKey,
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
                        color: Colors.blue,
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
                  controller: emailController,
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  prefixIcon: Icons.email,
                ),
                CustomTextInput(
                  controller: passwordController,
                  labelText: "Password",
                  hintText: "at least 8 characters",
                  prefixIcon: Icons.lock,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  isObscure: _obscurePassword,
                  isPassword: _obscurePassword,
                  onSuffixIconPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
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
<<<<<<< HEAD
                    CustomButton(
                      label: "Login",
                      backgroundColor: Colors.grey,
                      textColor: Colors.black,
                      onPressed: signUpUser,
=======

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => MainNavigationScreen()));
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontSize: 22),
                      selectionColor: Color.fromRGBO(47, 33, 243, 1),
>>>>>>> b182a356854f9a40e691542cd9e5e5f0036ad983
                    ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('OR'),
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

                    TextButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => Signup())),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 19),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon(FontAwesomeIcons.google, Colors.red),
                    _socialIcon(FontAwesomeIcons.linkedinIn, Colors.blueAccent),
                    _socialIcon(FontAwesomeIcons.facebookF, Colors.blue),
                    _socialIcon(FontAwesomeIcons.instagram, Colors.purple),
                    _socialIcon(FontAwesomeIcons.xTwitter, Colors.black),
                  ],
                ),
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
