
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/remote/api/store.dart';
import 'package:graville_operations/core/remote/dto/response/store.dart';
import 'package:graville_operations/screens/store/inventory/state.dart';

class InventoryScreenController extends GetxController{
  var state = InventoryScreenState();

  @override
  void onInit() {
    super.onInit();
    getStoreMaterials();
    getStoreTools();
  }


  Future<void> getStoreMaterials()async{
    state.isLoadingMaterials.value = true;
    state.materialsErrorMessage.value = '';
    try{
      var response = await StoreApi.fetchStoreMaterials();
      state.materials.assignAll(response);
    }catch(e){
      state.materialsErrorMessage.value = "Failed to load materials";
    } finally {
      state.isLoadingMaterials.value = false;
    }
  }
  Future<void> getStoreTools()async{
    state.isLoadingTools.value = true;
    state.toolsErrorMessage.value = '';
    try{
      var response = await StoreApi.fetchStoreTools();
      state.tools.assignAll(response);
    }catch(e){
      state.toolsErrorMessage.value = "Failed to load materials";
    } finally {
      state.isLoadingTools.value = false;
    }
  }
}