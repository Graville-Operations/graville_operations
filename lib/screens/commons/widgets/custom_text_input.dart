import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onSuffixIconPressed;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String hintText;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final int? maxLines;
  final bool readOnly;

  final String? Function(String?)? validator;
  const CustomTextInput({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.isObscure = false,
    this.onSuffixIconPressed,
    this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.decoration,
    this.maxLines = 1,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = maxLines != null && maxLines! > 1;
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      readOnly: readOnly,
      style: TextStyle(color: Colors.black54),

      keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
      minLines: isMultiline ? 4 : 1,
      maxLines: isMultiline ? null : 1,
      decoration:
          decoration ??
          InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            labelText: labelText,
            floatingLabelStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black),
            ),
            suffixIcon: IconButton(
              icon: Icon(suffixIcon, color: Colors.grey),
              onPressed: onSuffixIconPressed,
            ),
          ),
    );
  }
}
