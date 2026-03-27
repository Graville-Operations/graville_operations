import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginState {
  RxBool obscurePassword = true.obs;
  final TextEditingController psw = TextEditingController();
  final TextEditingController email = TextEditingController();
}