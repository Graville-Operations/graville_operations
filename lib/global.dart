
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/user_store.dart';

class Global{
  static Future<void> init() async{
    WidgetsFlutterBinding.ensureInitialized();
    //putAsync is used to load data that happens with Future which is a asynchronous method
    await Get.putAsync<StorageService>(() => StorageService().init());

    //while using Get.put() you can inject the controller and the controller will be ready to be used
    //this is because it's in the memory
    Get.put<UserStore>(UserStore());
    // Get.put<MenuStore>(MenuStore());
  }
}