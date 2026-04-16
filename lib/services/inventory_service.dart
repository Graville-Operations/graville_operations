
import 'dart:convert';
//import 'package:graville_operations/models/material/material_model.dart';
import 'package:flutter/widgets.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';

class MaterialService {
  static const String _path = '/materials';
  static final _http = HttpUtil();


  static Future<InventoryModel> createMaterial(InventoryModel material) async {
    final data = await _http.post('$_path/',data: material.toUpdateJson());
    return InventoryModel.fromJson(data);

  }


  static Future<List<InventoryModel>> getMaterials() async {
    final data =  await _http.get('$_path/materials');
    //debugPrint('getMaterial raw: ${(data as List).first}');
    return (data as List).map((json) => InventoryModel.fromJson(json)).toList();

  }


  static Future<InventoryModel> getMaterialById(int id) async {
    final data = await _http.get('$_path/get_material_by_id/$id');
    return InventoryModel.fromJson(data);

  }


  static Future<InventoryModel> updateMaterial(
      int id, InventoryModel material) async {
    final data = await _http.put('$_path/update_materials/$id');
    return InventoryModel.fromJson(data);

  }


  static Future<List<InventoryModel>> getAllInventory() async {
    final data = await _http.get('$_path/get_all_inventory');
    debugPrint('getAllInventory raw: $data');
    return (data as List).map((json) => InventoryModel.fromJson(json)).toList();

  }

  
  static Future<InventoryModel> getInventoryById(int id) async {
    final data = await _http.get('$_path/get_inventory_by_id/$id');
    return InventoryModel.fromJson(data);

  }

  static Future<InventoryModel> updateInventory(
      int id, InventoryModel inventory) async {
        debugPrint('Update payload: ${jsonEncode(inventory.toUpdateJson())}');
    final data = await _http.put('$_path/update_inventory/$id', data: inventory.toUpdateJson());
    debugPrint('Update response: $data');
    return InventoryModel.fromJson(data);

  }

}

class MaterialServiceException implements Exception {
  final String message;
  const MaterialServiceException(this.message);

  @override
  String toString() => message;
}