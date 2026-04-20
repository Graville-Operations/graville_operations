

import 'package:get/get.dart';

import 'controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    //we are injecting LoginController
    // when we use lazyput() the instance is called whenever you call this controller
    Get.lazyPut<LoginController>(() => LoginController());
  }
}