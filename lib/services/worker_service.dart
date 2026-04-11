//import 'dart:convert';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/worker_model.dart';
//import 'package:http/http.dart' as http;

class WorkerService {
  static const String _path = '/workers';
  static  HttpUtil _http =  HttpUtil();


  static Future<Worker> createWorker(Worker worker) async {
      final data = await _http.post('$_path/', data: worker.toCreateJson());
      return Worker.fromJson(data);

  }

  static Future<List<Worker>> fetchWorkers() async {
    final data = await _http.get('$_path/list');
    return (data as List).map((json) => Worker.fromJson(json)).toList();

  }

  Future<Worker> getWorkerById(int workerId) async {
    final data = await _http.get('$_path/$workerId');
    return Worker.fromJson(data);

  }
}

class WorkerServiceException implements Exception {
  final String message;
  WorkerServiceException(this.message);

  @override
  String toString() => message;
}