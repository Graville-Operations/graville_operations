import 'dart:io';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/inventory_item.dart';
import 'package:graville_operations/models/material/receipt_record.dart';
import 'package:graville_operations/services/api_service.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class ReceiveMaterialService {
  static List<InventoryItem>? _inventoryCache;

  static void clearCache() {
    _inventoryCache = null;
  }

  static Future<List<InventoryItem>> fetchInventory() async {
    if (_inventoryCache != null) return _inventoryCache!;
    try {
      final result = await ApiService.authenticatedGet(
          '/materials/transfer/materials');
      if (result['success'] != true) return [];
      final raw  = result['data'];
      final list = raw is List ? raw : [];
      _inventoryCache = (list as List)
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return _inventoryCache!;
    } catch (_) {
      return [];
    }
  }

  static Future<List<DestinationSite>> fetchSites() {
    return TransferMaterialService.fetchSites();
  }

  static Future<List<ReceiptRecord>> fetchReceipts() async {
  try {
    final result =
        await ApiService.authenticatedGet('/material/receive_material');
    if (result['success'] != true) return [];
    final raw  = result['data'];
    final list = raw is List ? raw : [];
    return (list as List)
        .map((e) => ReceiptRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return [];
  }
}

static Future<Map<String, dynamic>> receiveFromSupplier({
  required int    inventoryId,
  required int    quantity,
  required double amountPaid,
  required String supplierName,
  String?         notes,
  File?           photo,
}) async {
  try {
    final token = await ApiService.getToken();
    final formData = FormData.fromMap({
      'inventory_id':      inventoryId,
      'quantity_received': quantity,
      'amount_paid':       amountPaid,
      'supplier_name':     supplierName,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (photo != null)
        'photo': await MultipartFile.fromFile(
            photo.path, filename: photo.path.split('/').last),
    });
    final response = await HttpUtil().post(
      '/material/receive_material/from_supplier',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return {'success': true, 'data': response};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

static Future<Map<String, dynamic>> receiveFromSite({
  required int    inventoryId,
  required int    quantity,
  required int    fromSiteId,
  double          amountPaid = 0.0,
  String?         notes,
  File?           photo,
}) async {
  try {
    final token = await ApiService.getToken();
    final formData = FormData.fromMap({
      'inventory_id':      inventoryId,
      'quantity_received': quantity,
      'amount_paid':       amountPaid,
      'from_site_id':      fromSiteId,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (photo != null)
        'photo': await MultipartFile.fromFile(
            photo.path, filename: photo.path.split('/').last),
    });
    final response = await HttpUtil().post(
      '/material/receive_material/from_site',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return {'success': true, 'data': response};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}
}