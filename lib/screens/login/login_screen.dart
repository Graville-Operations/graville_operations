import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  String? passwordErrorMessage;
  String? emailErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 70, color: Colors.blue),

                const SizedBox(height: 20),

                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Log in to your account",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 26),

                CustomTextInput(
                  controller: emailController,
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 15),
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
                  onVisibilityPressed: () {
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
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontSize: 22),
                      selectionColor: Color.fromRGBO(47, 33, 243, 1),
                    ),
                  ),
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
                    Text("Don't have an account? "),
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
    );
  }
}
