import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graville_operations/models/store_checkin_model.dart';
import 'package:http/http.dart' as http;

class StoreCheckInService {
  static const String _baseUrl =
      'https://j6bxcq4z-8000.uks1.devtunnels.ms/api/v1';

  Future<List<StoreItem>> fetchMaterials(int storeId) async {
    final url = '$_baseUrl/store/materials/$storeId';
    debugPrint('>>> fetchMaterials URL: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    debugPrint('>>> fetchMaterials status: ${response.statusCode}');
    debugPrint('>>> fetchMaterials body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => StoreItem.fromMaterialJson(e)).toList();
    }
    throw Exception(
        'Failed to load materials (${response.statusCode}): ${response.body}');
  }

  Future<List<StoreItem>> fetchTools(int storeId) async {
    final url = '$_baseUrl/store/tools/$storeId';
    debugPrint('>>> fetchTools URL: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
    debugPrint('>>> fetchTools status: ${response.statusCode}');
    debugPrint('>>> fetchTools body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => StoreItem.fromToolJson(e)).toList();
    }
    throw Exception(
        'Failed to load tools (${response.statusCode}): ${response.body}');
  }
}
