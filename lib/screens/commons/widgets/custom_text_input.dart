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
  final ValueChanged<String>? onChanged;
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
    this.onChanged,
  });

  @override
  @override
Widget build(BuildContext context) {
  final bool isMultiline = maxLines != null && maxLines! > 1;
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    validator: validator,
    readOnly: readOnly,
    style: const TextStyle(color: Colors.black), 

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
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey), 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          suffixIcon: IconButton(
            icon: Icon(suffixIcon, color: Colors.grey),
            onPressed: onSuffixIconPressed,
          ),
        ),
  );
}
}