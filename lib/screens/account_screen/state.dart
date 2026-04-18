

import 'package:get/get.dart';
import 'package:graville_operations/models/auth/user.dart';

class AccountScreenState{
  final Rx<User> user = User.empty().obs;
  final RxString language = "English".obs;
  final RxString theme = "System".obs;
}