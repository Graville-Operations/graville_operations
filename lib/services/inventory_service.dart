
import 'dart:convert';
//import 'package:graville_operations/models/material/material_model.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:http/http.dart' as http;

class MaterialService {
  static const String _baseUrl = 'http://localhost:8000/api/v1/materials';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };


  static Future<InventoryModel> createMaterial(InventoryModel material) async {
    final url = Uri.parse('$_baseUrl/');

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(material.toUpdateJson()),
    );

    if (response.statusCode == 201) {
      return InventoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw MaterialServiceException(
          'Failed to create material: ${_extractError(response)}');
    }
  }


  static Future<List<InventoryModel>> getMaterials() async {
    final url = Uri.parse('$_baseUrl/materials');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => InventoryModel.fromJson(json)).toList();
    } else {
      throw MaterialServiceException(
          'Failed to fetch materials: ${_extractError(response)}');
    }
  }


  static Future<InventoryModel> getMaterialById(int id) async {
    final url = Uri.parse('$_baseUrl/get_material_by_id/$id');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return InventoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw MaterialServiceException(
          'Failed to fetch material: ${_extractError(response)}');
    }
  }


  static Future<InventoryModel> updateMaterial(
      int id, InventoryModel material) async {
    final url = Uri.parse('$_baseUrl/update_materials/$id');

    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(material.toUpdateJson()),
    );

    if (response.statusCode == 200) {
      return InventoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw MaterialServiceException(
          'Failed to update material: ${_extractError(response)}');
    }
  }


  static Future<List<InventoryModel>> getAllInventory() async {
    final url = Uri.parse('$_baseUrl/get_all_inventory');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => InventoryModel.fromJson(json)).toList();
    } else {
      throw MaterialServiceException(
          'Failed to fetch inventory: ${_extractError(response)}');
    }
  }

  
  static Future<InventoryModel> getInventoryById(int id) async {
    final url = Uri.parse('$_baseUrl/get_inventory_by_id/$id');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return InventoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw MaterialServiceException(
          'Failed to fetch inventory item: ${_extractError(response)}');
    }
  }

  static Future<InventoryModel> updateInventory(
      int id, InventoryModel inventory) async {
    final url = Uri.parse('$_baseUrl/update_inventory/$id');

    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(inventory.toUpdateJson()),
    );

    if (response.statusCode == 200) {
      return InventoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw MaterialServiceException(
          'Failed to update inventory: ${_extractError(response)}');
    }
  }


  static String _extractError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['detail'] ?? response.statusCode.toString();
    } catch (_) {
      return response.statusCode.toString();
    }
  }
}

class MaterialServiceException implements Exception {
  final String message;
  const MaterialServiceException(this.message);

  @override
  String toString() => message;
}