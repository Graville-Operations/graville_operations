import 'dart:convert';
import 'dart:io';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/transport_mode.dart';
import 'package:graville_operations/models/material/transfer_record.dart';
import 'package:graville_operations/models/material/transport_mode.dart';
import 'package:graville_operations/services/api_service.dart';

class TransferMaterialService {
  static List<AppMaterial>?     _materialsCache;
  static List<DestinationSite>? _sitesCache;
  static List<TransportMode>?   _modesCache;

  static void clearCache() {
    _materialsCache = null;
    _sitesCache     = null;
    _modesCache     = null;
  }

  static Future<List<AppMaterial>> fetchMaterials() async {
    if (_materialsCache != null) return _materialsCache!;
    try {
      final result = await ApiService.authenticatedGet(
          '/materials/transfer/materials');
      if (result['success'] != true) return [];
      final data = result['data'];
      final list = data is List ? data : [];
      _materialsCache = (list as List)
          .map((e) => AppMaterial.fromJson(e as Map<String, dynamic>))
          .toList();
      return _materialsCache!;
    } catch (_) {
      return [];
    }
  }

  static Future<List<DestinationSite>> fetchSites() async {
    if (_sitesCache != null) return _sitesCache!;
    try {
      final result =
          await ApiService.authenticatedGet('/materials/transfer/sites');
      if (result['success'] != true) return [];
      final data = result['data'];
      final list = data is List ? data : [];
      _sitesCache = (list as List)
          .map((e) => DestinationSite.fromJson(e as Map<String, dynamic>))
          .toList();
      return _sitesCache!;
    } catch (_) {
      return [];
    }
  }

  static Future<List<TransportMode>> fetchTransportModes() async {
    if (_modesCache != null) return _modesCache!;
    try {
      final result = await ApiService.authenticatedGet(
          '/materials/transfer/transport-modes');
      if (result['success'] != true) return [];
      final data = result['data'];
      final list = data is List ? data : [];
      _modesCache = (list as List)
          .map((e) => TransportMode.fromJson(e as Map<String, dynamic>))
          .toList();
      return _modesCache!;
    } catch (_) {
      return [];
    }
  }

  static Future<List<TransferRecord>> fetchTransfers() async {
    try {
      final result =
          await ApiService.authenticatedGet('/materials/transfer');
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

  static Future<Map<String, dynamic>> createTransportMode(
      TransportMode request) async {
    try {
      final result = await ApiService.authenticatedPost(
        '/materials/transfer/transport-modes',
        request.toJson(),
      );
      if (result['success'] == true) {
        _modesCache = null; // force fresh fetch
        return {'success': true, 'data': result['data']};
      }
      return {
        'success': false,
        'message': result['message'] ?? 'Failed to create transport mode.',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> submitTransfer({
    required int materialId,
    required int fromSiteId,
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
        'material_id':    materialId,
        'from_site_id':   fromSiteId,
        'to_site_id':     toSiteId,
        'quantity':       quantity,
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