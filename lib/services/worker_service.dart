// // import 'dart:convert';
// // import 'package:graville_operations/models/worker_model.dart';
// // import 'package:http/http.dart' as http;

// // class WorkerService {
// //   static const String _baseUrl = 'https://tvkdbvsl-8000.uks1.devtunnels.ms/';

// //   static const Map<String, String> _headers = {
// //     'Content-Type': 'application/json',
// //   };

// //   static Future<Worker> createWorker(Worker worker) async {
// //       final url = Uri.parse('$_baseUrl/');

// //       final response = await http.post(
// //       url,
// //       headers: _headers,
// //       body: jsonEncode(worker.toCreateJson()),
// //     );

// //     if (response.statusCode == 201) {
// //       return Worker.fromJson(jsonDecode(response.body));
// //     } else {
// //       final message  = _extractError(response);
// //       throw WorkerServiceException('Failed to add worker: $message');
// //     }
// //   }

// //   static Future<List<Worker>> fetchWorkers() async {
// //     final url = Uri.parse('$_baseUrl/list');

// //     final response = await http.get(url, headers: _headers);

// //     if (response.statusCode == 200) {
// //       final List<dynamic> data = jsonDecode(response.body);
// //       return data.map((json) => Worker.fromJson(json)).toList();
// //     } else {
// //       final message  = _extractError(response);
// //       throw WorkerServiceException('Failed to fetch workers: $message');
// //     }
// //   }

// //   static Future<Worker> getWorkerById(int workerId) async {
// //     final url = Uri.parse('$_baseUrl/$workerId');

// //     final response = await http.get(url, headers: _headers);

// //     if (response.statusCode == 200) {
// //       return Worker.fromJson(jsonDecode(response.body));
// //     } else {
// //       final message  = _extractError(response);
// //       throw WorkerServiceException('Failed to fetch worker: $message');
// //     }
// //   }

// //   static String _extractError(http.Response response) {
// //     try {
// //       final body = jsonDecode(response.body);
// //       return body['detail'] ?? response.statusCode.toString();
// //     } catch (_) {
// //       return response.statusCode.toString();
// //     }
// //   }

// //   //static Future<Object?> getWorkers() async {}
// // }

// // class WorkerServiceException implements Exception {
// //   final String message;
// //   WorkerServiceException(this.message);

// //   @override
// //   String toString() => message;
// // }

// import 'dart:convert';
// import 'package:graville_operations/models/worker_model.dart';
// import 'package:http/http.dart' as http;

// class WorkerService {

//   static const Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//   };

//   static Future<Worker> createWorker(Worker worker) async {
//     final url = Uri.parse('$_baseUrl/');

//     final response = await http.post(
//       url,
//       headers: _headers,
//       body: jsonEncode(worker.toCreateJson()),
//     );

//     if (response.statusCode == 201) {
//       return Worker.fromJson(jsonDecode(response.body));
//     } else {
//       final message = _extractError(response);
//       throw WorkerServiceException('Failed to add worker: $message');
//     }
//   }

//   static Future<List<Worker>> fetchWorkers() async {
//     final url = Uri.parse('$_baseUrl/list');

//     final response = await http.get(url, headers: _headers);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Worker.fromJson(json)).toList();
//     } else {
//       final message = _extractError(response);
//       throw WorkerServiceException('Failed to fetch workers: $message');
//     }
//   }

//   /// Fetches workers with server-side sorting, skill filtering, and pagination.
//   ///
//   /// Maps to: GET /list?sort_by=id&order=asc&skill=electrician&limit=20&offset=0
//   ///
//   /// Parameters:
//   /// - [skill]   : optional partial match on skill_type (e.g. "electrician")
//   /// - [sortBy]  : one of id | first_name | last_name | joined_date | amount | skill_type
//   /// - [order]   : "asc" or "desc"
//   /// - [limit]   : max records to return (pass null for no limit)
//   /// - [offset]  : number of records to skip (for pagination)
//   static Future<List<Worker>> fetchWorkersFiltered({
//     String? skill,
//     String sortBy = 'id',
//     String order = 'asc',
//     int? limit = 20,
//     int offset = 0,
//   }) async {
//     final queryParams = <String, String>{
//       'sort_by': sortBy,
//       'order': order,
//       'offset': offset.toString(),
//     };

//     if (skill != null && skill.isNotEmpty) {
//       queryParams['skill'] = skill;
//     }

//     if (limit != null) {
//       queryParams['limit'] = limit.toString();
//     }

//     final url = Uri.parse('$_baseUrl/list').replace(
//       queryParameters: queryParams,
//     );

//     final response = await http.get(url, headers: _headers);

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Worker.fromJson(json)).toList();
//     } else {
//       final message = _extractError(response);
//       throw WorkerServiceException('Failed to fetch workers: $message');
//     }
//   }

//   static Future<Worker> getWorkerById(int workerId) async {
//     final url = Uri.parse('$_baseUrl/$workerId');

//     final response = await http.get(url, headers: _headers);

//     if (response.statusCode == 200) {
//       return Worker.fromJson(jsonDecode(response.body));
//     } else {
//       final message = _extractError(response);
//       throw WorkerServiceException('Failed to fetch worker: $message');
//     }
//   }

//   static String _extractError(http.Response response) {
//     try {
//       final body = jsonDecode(response.body);
//       return body['detail'] ?? response.statusCode.toString();
//     } catch (_) {
//       return response.statusCode.toString();
//     }
//   }

//   //static Future<Object?> getWorkers() async {}
// }

// class WorkerServiceException implements Exception {
//   final String message;
//   WorkerServiceException(this.message);

//   @override
//   String toString() => message;
// }

//import 'dart:convert';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/worker_model.dart';
//import 'package:http/http.dart' as http;

class WorkerService {
  static const String _path = '/workers';
  static HttpUtil _http = HttpUtil();

  // const Map<String, String> _headers = {
  //   'Content-Type': 'application/json',

  static Future<Worker> createWorker(Worker worker) async {
    final data = await _http.post('$_path/', data: worker.toCreateJson());
    return Worker.fromJson(data);
  }

  static Future<List<Worker>> fetchWorkers() async {
    final data = await _http.get('$_path/list');
    return (data as List).map((json) => Worker.fromJson(json)).toList();
  }

  /// Fetches workers with server-side sorting, skill filtering, and pagination.
  ///
  /// Calls GET /workers/search?sort_by=id&order=asc&skill=electrician&limit=20&offset=0
  ///
  /// Parameters:
  /// - [skill]   : optional partial match on skill_type (e.g. "electrician")
  /// - [sortBy]  : one of id | first_name | last_name | joined_date | amount | skill_type
  /// - [order]   : "asc" or "desc"
  /// - [limit]   : max records to return (pass null for no limit)
  /// - [offset]  : number of records to skip (for pagination)
  static Future<List<Worker>> fetchWorkersFiltered({
    String? skill,
    String sortBy = 'id',
    String order = 'asc',
    int? limit = 20,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'sort_by': sortBy,
      'order': order,
      'offset': offset,
    };

    if (skill != null && skill.isNotEmpty) {
      queryParams['skill'] = skill;
    }

    if (limit != null) {
      queryParams['limit'] = limit;
    }

    final data = await _http.get('$_path/search', queryParameters: queryParams);
    return (data as List).map((json) => Worker.fromJson(json)).toList();
  }

  Future<Worker> getWorkerById(int workerId) async {
    final data = await _http.get('$_path/$workerId');
    return Worker.fromJson(data);
  }

  // String _extractError(http.Response response) {
  //   try {
  //     final body = jsonDecode(response.body);
  //     return body['detail'] ?? response.statusCode.toString();
  //   } catch (_) {
  //     return response.statusCode.toString();
  //   }
  // }

  //static Future<Object?> getWorkers() async {}
}

class WorkerServiceException implements Exception {
  final String message;
  WorkerServiceException(this.message);

  @override
  String toString() => message;
}