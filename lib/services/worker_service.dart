import 'dart:convert';
import 'package:graville_operations/models/worker_model.dart';
import 'package:http/http.dart' as http;

class WorkerService {
  static const String _baseUrl = 'http://localhost:8000/api/v1/workers';

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  static Future<Worker> createWorker(Worker worker) async {
      final url = Uri.parse('$_baseUrl/');

      final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(worker.toCreateJson()),
    );

    if (response.statusCode == 201) {
      return Worker.fromJson(jsonDecode(response.body));
    } else {
      final message  = _extractError(response);
      throw WorkerServiceException('Failed to add worker: $message');
    }
  }

  static Future<List<Worker>> fetchWorkers() async {
    final url = Uri.parse('$_baseUrl/list');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Worker.fromJson(json)).toList();
    } else {
      final message  = _extractError(response);
      throw WorkerServiceException('Failed to fetch workers: $message');
    }
  }

  static Future<Worker> getWorkerById(int workerId) async {
    final url = Uri.parse('$_baseUrl/$workerId');

    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      return Worker.fromJson(jsonDecode(response.body));
    } else {
      final message  = _extractError(response);
      throw WorkerServiceException('Failed to fetch worker: $message');
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

  //static Future<Object?> getWorkers() async {}
}

class WorkerServiceException implements Exception {
  final String message;
  WorkerServiceException(this.message);

  @override
  String toString() => message;
}