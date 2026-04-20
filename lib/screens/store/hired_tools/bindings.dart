
import 'package:get/get.dart';
import 'package:graville_operations/screens/store/hired_tools/controller.dart';

class AddHiredToolBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddHiredToolController>(()=>AddHiredToolController());
  }

}