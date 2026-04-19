

import 'package:flutter/widgets.dart';
import 'package:graville_operations/core/remote/dto/response/store.dart';
import 'package:graville_operations/core/remote/routes/store.dart';
import 'package:graville_operations/core/utils/http.dart';

class StoreApi{
  
  static Future<List<StoreMaterial>> fetchStoreMaterials()async{
    var response = await HttpUtil().get(
      StoreRoute.getMaterials,
    );
    return (response as List<dynamic>).map((material)=>StoreMaterial.fromJson(material)).toList();
  }

  static Future<List<StoreTool>> fetchStoreTools()async{
    var response = await HttpUtil().get(
      StoreRoute.getTools,
    );
    debugPrint("Store api fetching tools: $response");
    return (response as List<dynamic>).map((tool)=>StoreTool.fromJson(tool)).toList();
  }
}