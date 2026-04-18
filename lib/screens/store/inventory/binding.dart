

import 'package:get/get.dart';
import 'package:graville_operations/screens/store/inventory/controller.dart';

class InventoryScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<InventoryScreenController>(
      InventoryScreenController(),
      permanent: false,
    );
  }

}