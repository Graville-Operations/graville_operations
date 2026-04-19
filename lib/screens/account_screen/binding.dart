
import 'package:get/get.dart';
import 'package:graville_operations/screens/account_screen/controller.dart';

class AccountScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<AccountScreenController>(AccountScreenController(),permanent: false);
  }

}