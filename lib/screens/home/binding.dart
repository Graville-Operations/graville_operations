import 'package:get/get.dart';
import 'package:graville_operations/screens/home/controller.dart';

class HomeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeScreenController>(
      HomeScreenController(),
      permanent: false,
    );
  }
}
