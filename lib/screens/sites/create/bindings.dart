

import 'package:get/get.dart';
import 'package:graville_operations/screens/sites/create/controller.dart';

class CreateSiteBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CreateSiteController>(() => CreateSiteController());
  }

}