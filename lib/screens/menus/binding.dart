import 'package:get/get.dart';
import 'controller.dart';

class MenusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MenusController>(() => MenusController());
  }
}