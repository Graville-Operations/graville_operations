import 'package:flutter/widgets.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/site/site_model.dart';

class SiteService {
  static const String _path = '/sites';
  static final _http = HttpUtil();

  static Future<SiteModel> createSite(SiteModel site) async {
    final jsonData = site.toJson();
    // debugPrint(' Sending to API: $jsonData');
    // debugPrint(' URL: $_path/create-site');
    
    final data = await _http.post('$_path/create-site', data: jsonData);
    return SiteModel.fromJson(data);
  }

  static Future<List<SiteModel>> getAllSites() async {
    final data = await _http.get('$_path/get-all-sites');
    debugPrint('getAllSites raw: $data');
    return (data as List).map((json) => SiteModel.fromJson(json)).toList();
  }

  static Future<SiteModel> getSiteById(int id) async {
    final data = await _http.get('$_path/get-site/$id');
    return SiteModel.fromJson(data);
  }

  static Future<SiteModel> updateSite(int id, SiteModel site) async {
    final data = await _http.put('$_path/update-site/$id', data: site.toUpdateJson());
    debugPrint('updateSite response: $data');
    return SiteModel.fromJson(data);
  }

  static Future<void> deleteSite(int id) async {
    await _http.delete('$_path/delete-site/$id');
  }
}

class SiteServiceException implements Exception {
  final String message;
  const SiteServiceException(this.message);

  @override
  String toString() => message;
}