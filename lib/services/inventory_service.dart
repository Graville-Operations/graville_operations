import 'package:flutter/foundation.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:graville_operations/models/material/material_data.dart';

class MaterialService {
  static final HttpUtil _http = HttpUtil();

  //Materials

  // static Future<List<MaterialData>> fetchMaterials() async {
  //   final data = await _http.get(AppRoutes.getMaterials);
  //   return (data as List).map((json) => MaterialData.fromJson(json)).toList();
  // }

  static Future<List<MaterialData>> fetchMaterials() async {
    final data = await _http.get('/materials/all');
    return (data as List).map((json) => MaterialData.fromJson(json)).toList();
  }

  static Future<InventoryModel> createMaterial(InventoryModel material) async {
    final data = await _http.post(
      AppRoutes.createMaterial,
      data: material.toUpdateJson(),
    );
    return InventoryModel.fromJson(data);
  }

  static Future<List<InventoryModel>> getMaterials() async {
    final data = await _http.get(AppRoutes.getMaterials);
    return (data as List).map((json) => InventoryModel.fromJson(json)).toList();
  }

  static Future<InventoryModel> getMaterialById(int id) async {
    final data = await _http.get(AppRoutes.materialById(id));
    return InventoryModel.fromJson(data);
  }

  static Future<InventoryModel> updateMaterial(
      int id, InventoryModel material) async {
    final data = await _http.put(
      AppRoutes.updateMaterial(id),
      data: material.toUpdateJson(),
    );
    return InventoryModel.fromJson(data);
  }

  //Inventory

  static Future<List<InventoryModel>> getAllInventory() async {
    final data = await _http.get(AppRoutes.getAllInventory);
    debugPrint('getAllInventory raw: $data');
    return (data as List).map((json) => InventoryModel.fromJson(json)).toList();
  }

  static Future<InventoryModel> getInventoryById(int id) async {
    final data = await _http.get(AppRoutes.inventoryById(id));
    return InventoryModel.fromJson(data);
  }

  static Future<InventoryModel> updateInventory(
      int id, InventoryModel inventory) async {
    debugPrint('Update payload: ${inventory.toUpdateJson()}');
    final data = await _http.put(
      AppRoutes.updateInventory(id),
      data: inventory.toUpdateJson(),
    );
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
