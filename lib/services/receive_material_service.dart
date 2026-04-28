import 'dart:io';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/inventory_item.dart';
import 'package:graville_operations/models/material/receipt_record.dart';
import 'package:graville_operations/services/api_service.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class ReceiveMaterialService {
  static List<InventoryItem>? _materialsCache;

  static void clearCache() {
    _materialsCache = null;
  }

  static Future<List<InventoryItem>> fetchInventory() async {
    if (_materialsCache != null) return _materialsCache!;
    try {
      final result = await ApiService.authenticatedGet(
          '/material/receive_material/materials');
      if (result['success'] != true) return [];
      final raw  = result['data'];
      final list = raw is List ? raw : [];
      _materialsCache = (list as List)
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return _materialsCache!;
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
    required int    materialId,
    required int    quantity,
    required double amountPaid,
    required String supplierName,
    int?            storeId,
    String?         notes,
    File?           photo,
  }) async {
    try {
      final token = await ApiService.getToken();
      final formData = FormData.fromMap({
        'material_id':       materialId,
        'quantity_received': quantity,
        'amount_paid':       amountPaid,
        'supplier_name':     supplierName,
        if (storeId != null) 'store_id': storeId,
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
    required int    materialId,
    required int    quantity,
    required int    fromSiteId,
    int?            storeId,
    double          amountPaid = 0.0,
    String?         notes,
    File?           photo,
  }) async {
    try {
      final token = await ApiService.getToken();
      final formData = FormData.fromMap({
        'material_id':       materialId,
        'quantity_received': quantity,
        'amount_paid':       amountPaid,
        'from_site_id':      fromSiteId,
        if (storeId != null) 'store_id': storeId,
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