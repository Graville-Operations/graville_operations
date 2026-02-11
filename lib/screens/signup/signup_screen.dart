import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmpasswordVisible = false;

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

  // @override
  // void initState() {
  //   super.initState();
  //   emailController = TextEditingController();
  //   passwordController = TextEditingController();
  //   confirmpasswordController = TextEditingController();
  // }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  void signUpUser() {
    if (_formKey.currentState!.validate()) {
      print("Signup Successful");

      print("First Name: ${firstNameController.text}");
      print("Last Name: ${lastNameController.text}");
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[500],
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(CommonImages.background, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(height: 10),
                    Image.asset(CommonImages.logo, height: 50, width: 500),
                    //SizedBox(height: 20),
                    //welcome text
                    Text(
                      'Welcome to Graville Enterprises Limited!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    //SizedBox(height: 10),
                    Text(
                      'Please enter your details below',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 19,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextInput(
                            controller: firstNameController,
                            labelText: "First Name",
                            hintText: "John",
                            prefixIcon: Icons.person,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: CustomTextInput(
                            controller: firstNameController,
                            labelText: "Last Name",
                            hintText: "Doe",
                            prefixIcon: Icons.person,
                          ),
                        ),
                      ],
                    ),
                    //Email
                    SizedBox(height: 20),

                    CustomTextInput(
                      controller: emailController,
                      labelText: "Email",
                      hintText: "example@gmail.com",
                      prefixIcon: Icons.email,
                    ),
                    //password textfield
                    SizedBox(height: 20),
                    CustomTextInput(
                      controller: passwordController,
                      isPassword: _isPasswordVisible,
                      isObscure: !_isPasswordVisible,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      labelText: 'Password',
                      hintText: 'at least 8 characters',
                      prefixIcon: Icons.lock,
                      suffixIcon: _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    SizedBox(height: 20),
                    CustomTextInput(
                      controller: confirmpasswordController,
                      isPassword: _isConfirmpasswordVisible,
                      isObscure: !_isConfirmpasswordVisible,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isConfirmpasswordVisible =
                              !_isConfirmpasswordVisible;
                        });
                      },
                      labelText: 'Confirm Password',
                      hintText: 'Password should be equal',
                      prefixIcon: Icons.lock,
                      suffixIcon: _isConfirmpasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    //signup button
                    SizedBox(height: 20),
                    CustomButton(
                      label: "Sign up",
                      backgroundColor: Colors.green,
                      textColor: Colors.black,
                      onPressed: signUpUser,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '-------------------- OR --------------------',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          ),
                          child: Text(
                            ' Sign in',
                            style: TextStyle(
                              color: Colors.blue[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon(FontAwesomeIcons.google, Colors.red),
                        _socialIcon(
                          FontAwesomeIcons.linkedinIn,
                          Colors.blueAccent,
                        ),
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
      ),
    );
  }
}
