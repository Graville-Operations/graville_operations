import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graville_operations/navigation/navigation.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/forgot_password/forgot_password.dart';
import 'package:graville_operations/screens/signup/signup_screen.dart';

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
  return InkWell(
    borderRadius: BorderRadius.circular(30),
    onTap: () {},
    child: CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: FaIcon(
        icon,
        color: color,
        size: 20,
      ),
    ),
  );
}


  // Widget _socialIcon(IconData icon, Color color) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(30),
  //       onTap: () {},
  //       child: CircleAvatar(
  //         radius: 22,
  //         backgroundColor: Colors.grey[200],
  //         child: FaIcon(icon, color: color, size: 20),
  //       ),
  //     ),
  //   );
  // }

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
                  controller: emailController,
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  prefixIcon: Icons.email, onSuffixIconPressed: () {  },
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
    
                    //const SizedBox(height: 10)
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: SizedBox(
              //     width: 150,
              //  child:CustomButton(
              //  label: "forgot password", 
              //  backgroundColor: Colors.black,
              //         textColor: Colors.blue,
              //       onPressed: () => Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()),
              //       ),
              //   ),
              // ),
              // ),
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
                CustomButton(label: "log in", 
              backgroundColor: Colors.green,
                      textColor: Colors.black,
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavigationScreen())),
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
                
                const SizedBox(height: 19),
                   Center(
                     child: Wrap(
                       alignment: WrapAlignment.center,
                         spacing: 15,
                           children: [
                             _socialIcon(FontAwesomeIcons.google, Colors.red),
                             _socialIcon(FontAwesomeIcons.linkedinIn, Colors.blueAccent),
                             _socialIcon(FontAwesomeIcons.facebookF, Colors.blue),
                             _socialIcon(FontAwesomeIcons.instagram, Colors.purple),
                             _socialIcon(FontAwesomeIcons.xTwitter, Colors.black),
                         ],
                       ),
                     ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _socialIcon(FontAwesomeIcons.google, Colors.red),
                //     _socialIcon(FontAwesomeIcons.linkedinIn, Colors.blueAccent),
                //     _socialIcon(FontAwesomeIcons.facebookF, Colors.blue),
                //     _socialIcon(FontAwesomeIcons.instagram, Colors.purple),
                //     _socialIcon(FontAwesomeIcons.xTwitter, Colors.black),
                //   ],
                // ),
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
