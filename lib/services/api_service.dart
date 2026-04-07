import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static dynamic _decodeResponse(dynamic response) {
    if (response is String) return jsonDecode(response);
    return response;
  }

  static Options _jsonOptions() {
    return Options(headers: {'Content-Type': 'application/json'});
  }

  static Future<Options> _authJsonOptions() async {
    final token = await getToken();
    return Options(headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
  }


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
    final response = await HttpUtil().get(
      '/auth/admin/exists',
      options: _jsonOptions(),
    );
    final data = _decodeResponse(response);
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
    final response = await HttpUtil().post(
      '/auth/admin/signup',
      options: _jsonOptions(),
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        //'phone': phone,
      },
    );
    final data = _decodeResponse(response);

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
      'success': !(data['detail'] is List),
      'message': message
    };
  }

  //  Login 
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await HttpUtil().post(
      '/auth/login',
      options: _jsonOptions(),
      data: {'email': email, 'password': password},
    );

    final data = _decodeResponse(response);

    if (data['access_token'] != null) {
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
    final response = await HttpUtil().post(
      '/auth/forgot-password',
      options: _jsonOptions(),
      data: {'email': email},
    );

    final data = _decodeResponse(response);
    return {
      'success': data['message'] != null,
      'message': data['message']
    };
  }

  //  Verify OTP 
  static Future<Map<String, dynamic>> verifyOtp(
      String email, String code) async {
    final response = await HttpUtil().post(
      '/auth/verify-otp',
      options: _jsonOptions(),
      data: {'email': email, 'code': code},
    );

    final data = _decodeResponse(response);
    return {
      'success': data['message'] != null,
      'message': data['message']
    };
  }

  //  Reset Password 
  static Future<Map<String, dynamic>> resetPassword(
      String email, String code, String newPassword) async {
    final response = await HttpUtil().post(
      '/auth/reset-password',
      options: _jsonOptions(),
      data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      },
    );

    final data = _decodeResponse(response);
    return {
      'success': data['message'] != null,
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
    final response = await HttpUtil().post(
      '/auth/admin/create-field-engineer',
      options: await _authJsonOptions(),
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'national_id': nationalId != null ? int.tryParse(nationalId) : null,
      },
    );

    final data = _decodeResponse(response);
    return {
      'success': data['message'] != null,
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
    final response = await HttpUtil().post(
      '/auth/admin/create-auditor',
      options: await _authJsonOptions(),
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'national_id': nationalId != null ? int.tryParse(nationalId) : null,
      },
    );

    final data = _decodeResponse(response);
    return {
      'success': data['message'] != null,
      'message': data['message'] ?? data['detail']
    };
  }

  // ─── Get All Users (Admin only) 
  static Future<Map<String, dynamic>> getAllUsers() async {
    final response = await HttpUtil().get(
      '/auth/admin/users',
      options: await _authJsonOptions(),
    );

    final data = _decodeResponse(response);
    return {'success': data != null, 'data': data};
  }

  //  Delete User (Admin only) 
  static Future<Map<String, dynamic>> deleteUser(
      int userId, String role) async {
    final response = await HttpUtil().delete(
      '/auth/admin/users/$userId',
      queryParameters: {'role': role},
      options: await _authJsonOptions(),
    );

    final data = _decodeResponse(response);
    return {
      'success': data['message'] != null,
      'message': data['message'] ?? data['detail']
    };
  }

  //  Get Profile 
  static Future<Map<String, dynamic>> getProfile(int userId) async {
    final response = await HttpUtil().get(
      '/profile/$userId',
      options: await _authJsonOptions(),
    );
    final data = _decodeResponse(response);
    return {'success': data != null, 'data': data};
  }

  //  Update Profile 
  static Future<Map<String, dynamic>> updateProfile(
      int userId, Map<String, dynamic> profileData) async {
    final response = await HttpUtil().put(
      '/profile/$userId',
      options: await _authJsonOptions(),
      data: profileData,
    );
    final data = _decodeResponse(response);
    return {
      'success': data != null,
      'data': data,
      'message': data['detail'] ?? 'Updated successfully'
    };
  }

  //  Update Personal Settings 
  static Future<Map<String, dynamic>> updatePersonalSettings(
      int userId, Map<String, dynamic> settings) async {
    final response = await HttpUtil().put(
      '/profile/personal-settings/$userId',
      options: await _authJsonOptions(),
      data: settings,
    );
    final data = _decodeResponse(response);
    return {
      'success': data != null,
      'data': data,
      'message': data['detail'] ?? 'Settings updated successfully'
    };
  }

  //  Authenticated Requests 
  static Future<Map<String, dynamic>> authenticatedGet(
      String endpoint) async {
    final response = await HttpUtil().get(
      endpoint,
      options: await _authJsonOptions(),
    );

    final data = _decodeResponse(response);
    return {'success': data != null, 'data': data};
  }

  static Future<Map<String, dynamic>> authenticatedPost(
      String endpoint, Map<String, dynamic> body) async {
    final response = await HttpUtil().post(
      endpoint,
      options: await _authJsonOptions(),
      data: body,
    );

    final data = _decodeResponse(response);
    return {'success': data != null, 'data': data};
  }
}