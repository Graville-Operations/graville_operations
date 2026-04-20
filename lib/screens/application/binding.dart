

import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/screens/application/controller.dart';

class ApplicationBindings implements Bindings {
  @override
  void dependencies() async{
    Get.lazyPut<ApplicationController>(() => ApplicationController());
  }
}