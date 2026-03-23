// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ProfileService {
//   static const String _baseUrl = 'http://localhost:8000/api/v1/profile';

//   static const Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//   };
// }

//   static Future<Map<String, dynamic>> getProfile(int userId) async {
//     final url = Uri.parse('$_baseUrl/$userId');

//     final response = await http.get(url, headers: _headers);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       final message = _extractError(response);
//       throw Exception('Failed to fetch profile: $message');
//     }
//   }

//     static Future<Map<String, dynamic>> updateProfile(
//       int userId, Map<String, dynamic> data) async {
//     final url = Uri.parse('$_baseUrl/$userId');

//     final response = await http.put(
//       url,
//       headers: _headers,
//       body: jsonEncode(data),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       final message = _extractError(response);
//       throw Exception('Failed to update profile: $message');
//     }
//   }

//   static Future<Map<String, dynamic>> updateSettings(
//       int userId, Map<String, dynamic> data) async {
//     final url = Uri.parse('$_baseUrl/settings/$userId');

//     final response = await http.put(
//       url,
//       headers: _headers,
//       body: jsonEncode(data),
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       final message = _extractError(response);
//       throw Exception('Failed to update settings: $message');
//     }
//   }

//     static String _extractError(http.Response response) {
//     try {
//       final body = jsonDecode(response.body);
//       return body['detail'] ?? response.statusCode.toString();
//     } catch (_) {
//       return response.statusCode.toString();
//     }
//   }
