import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginState {
  var formKey = GlobalKey();
  RxBool obscurePassword = true.obs;
  final TextEditingController psw = TextEditingController();
  final TextEditingController email = TextEditingController();
}