import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator, your PC IP for physical device
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
 // static get SharedPreferences => null;

  // Token Management 
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
  }

  // Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveToken(data['access_token']);
      await saveRole(data['role']);
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['detail']};
    }
  }

  // Forgot Password 
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message']
    };
  }

  // Verify OTP 
  static Future<Map<String, dynamic>> verifyOtp(
      String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message']
    };
  }

  //  Reset Password 
  static Future<Map<String, dynamic>> resetPassword(
      String email, String code, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'new_password': newPassword,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message']
    };
  }

  //Authenticated Requests
  static Future<Map<String, dynamic>> authenticatedGet(
      String endpoint) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    return {'success': response.statusCode == 200, 'data': data};
  }

  static Future<Map<String, dynamic>> authenticatedPost(
      String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    return {'success': response.statusCode == 200, 'data': data};
  }
}