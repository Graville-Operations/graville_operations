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
Widget build(BuildContext context) {
  final bool isMultiline = maxLines != null && maxLines! > 1;

  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    validator: validator,
    readOnly: readOnly,
    onChanged: onChanged,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
    keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
    minLines: isMultiline ? 4 : 1,
    maxLines: isMultiline ? null : 1,
    decoration: decoration ??
        InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8F8F8), // softer white-grey
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey[500], size: 20)
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: Colors.grey[500], size: 20),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          floatingLabelStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),

          // Subtle border by default
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black38, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
  );
}
}