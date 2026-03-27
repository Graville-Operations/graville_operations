

import 'package:get/get.dart';
import 'package:graville_operations/screens/application/controller.dart';

class ApplicationBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationController>(() => ApplicationController());
  }
}