import 'dart:convert';
import 'dart:io';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/transfer_record.dart';
import 'package:graville_operations/models/material/transport_mode.dart';
import 'package:graville_operations/services/api_service.dart';

class TransferMaterialService {

  static Future<List<AppMaterial>> fetchMaterials() async {
    try {
      final result = await ApiService.authenticatedGet('/materials/transfer/materials');
      if (result['success'] != true) return [];
      final data = result['data'];
      final list = data is List ? data : [];
      return (list as List)
          .map((e) => AppMaterial.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<DestinationSite>> fetchSites() async {
    try {
      final result = await ApiService.authenticatedGet('/materials/transfer/sites');
      if (result['success'] != true) return [];
      final data = result['data'];
      final list = data is List ? data : [];
      return (list as List)
          .map((e) => DestinationSite.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<TransportMode>> fetchTransportModes() async {
    try {
      final result = await ApiService.authenticatedGet('/materials/transfer/transport-modes');
      if (result['success'] != true) return [];
      final data = result['data'];
      final list = data is List ? data : [];
      return (list as List)
          .map((e) => TransportMode.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

static Future<List<TransferRecord>> fetchTransfers() async {
  try {
    final result = await ApiService.authenticatedGet('/materials/transfer');
    if (result['success'] != true) return [];
    final data = result['data'];
    final list = data is List ? data : [];
    return (list as List)
        .map((e) => TransferRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return [];
  }
}


  static Future<Map<String, dynamic>> submitTransfer({
    required int materialId,
    required int toSiteId,
    required double quantity,
    required double pricePerUnit,
    int? transportModeId,
    String? driverDetails,
    String? notes,
    File? imageFile,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'material_id': materialId,
        'to_site_id': toSiteId,
        'quantity': quantity,
        'price_per_unit': pricePerUnit,
        if (transportModeId != null) 'transport_mode_id': transportModeId,
        if (driverDetails != null && driverDetails.isNotEmpty)
          'driver_details': driverDetails,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (imageFile != null)
          'image': base64Encode(await imageFile.readAsBytes()),
      };

      final result = await ApiService.authenticatedPost(
        '/materials/transfer',
        body,
      );

      if (result['success'] == true) {
        return {'success': true, 'data': result['data']};
      }
      return {
        'success': false,
        'message': result['message'] ?? 'Transfer failed.',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}