import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onSuffixIconPressed;
  final String labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String hintText;

  final String? Function(String?)? validator;

  const CustomTextInput({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.isObscure = false,
    this.onSuffixIconPressed,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        style: TextStyle(
          color: Colors.black54
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          labelText: labelText,
          floatingLabelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              suffixIcon,
              color: Colors.grey,
            ),
            onPressed:onSuffixIconPressed,
          ),
        ),
      ),
    );
  }
}