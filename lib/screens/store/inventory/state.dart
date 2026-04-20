
import 'package:get/get.dart';
import 'package:graville_operations/core/remote/dto/response/store.dart';

class InventoryScreenState{
  RxList<StoreMaterial> materials = <StoreMaterial>[].obs;
  RxList<StoreTool> tools = <StoreTool>[].obs;
  RxBool isLoadingMaterials = false.obs;
  RxBool isLoadingTools = false.obs;
  RxString materialsErrorMessage = ''.obs;
  RxString toolsErrorMessage = ''.obs;
}