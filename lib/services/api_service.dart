import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  //static const String baseUrl = 'http://localhost:8000/api/v1';

  // Use 10.0.2.2 for Android emulator, your PC IP for physical device
 static const String baseUrl = 'https://hello.graville.co.ke/api/v1';


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

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('user_id');
  }

  //  Check if admin exists 
  static Future<bool> adminExists() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/admin/exists'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);
    return data['exists'] ?? false;
  }

  //  Admin Signup
  static Future<Map<String, dynamic>> adminSignup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    //String? phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/admin/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        //'phone': phone,
      }),
    );
    final data = jsonDecode(response.body);

    String message;
    if (data['detail'] is List) {
      message = (data['detail'] as List)
          .map((e) => e['msg']?.toString() ?? '')
          .join(', ');
    } else {
      message = data['message']?.toString() ??
          data['detail']?.toString() ??
          'Something went wrong';
    }

    return {
      'success': response.statusCode == 200 || response.statusCode == 201,
      'message': message
    };
  }

  //  Login 
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
      await saveUserId(data['user']['id']);
      return {'success': true, 'data': data};
    } else {
      String message;
      if (data['detail'] is List) {
        message = (data['detail'] as List)
            .map((e) => e['msg']?.toString() ?? '')
            .join(', ');
      } else {
        message = data['detail']?.toString() ?? 'Login failed';
      }
      return {'success': false, 'message': message};
    }
  }

  //  Forgot Password 
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

  //  Verify OTP 
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

  //  Create Field Engineer (Admin only) 
  static Future<Map<String, dynamic>> createFieldEngineer({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? nationalId,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/admin/create-field-engineer'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'national_id': nationalId != null ? int.tryParse(nationalId) : null,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? data['detail']
    };
  }

  //  Create Auditor (Admin only) 
  static Future<Map<String, dynamic>> createAuditor({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? nationalId,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/auth/admin/create-auditor'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'national_id': nationalId != null ? int.tryParse(nationalId) : null,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? data['detail']
    };
  }

  // ─── Get All Users (Admin only) 
  static Future<Map<String, dynamic>> getAllUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/admin/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    return {'success': response.statusCode == 200, 'data': data};
  }

  //  Delete User (Admin only) 
  static Future<Map<String, dynamic>> deleteUser(
      int userId, String role) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/auth/admin/users/$userId?role=$role'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'message': data['message'] ?? data['detail']
    };
  }

  //  Get Profile 
  static Future<Map<String, dynamic>> getProfile(int userId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    return {'success': response.statusCode == 200, 'data': data};
  }

  //  Update Profile 
  static Future<Map<String, dynamic>> updateProfile(
      int userId, Map<String, dynamic> profileData) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/profile/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profileData),
    );
    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'data': data,
      'message': data['detail'] ?? 'Updated successfully'
    };
  }

  //  Update Personal Settings 
  static Future<Map<String, dynamic>> updatePersonalSettings(
      int userId, Map<String, dynamic> settings) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/profile/personal-settings/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(settings),
    );
    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 200,
      'data': data,
      'message': data['detail'] ?? 'Settings updated successfully'
    };
  }

  //  Authenticated Requests 
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