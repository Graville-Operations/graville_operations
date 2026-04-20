import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/core/utils/constants.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = appBaseUrl;

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

  static Future<bool> adminExists() async {
    try {
      final response = await HttpUtil().get(
        AppRoutes.adminExists,
        options: _jsonOptions(),
      );
      final data = _decodeResponse(response);
      return data['exists'] ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> adminSignup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.adminSignup,
        options: _jsonOptions(),
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
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

      return {'success': data['message'] != null, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.login,
        options: _jsonOptions(),
        data: {'email': email, 'password': password},
      );

      final data = _decodeResponse(response);

      if (data['access_token'] != null) {
        final token = data['access_token'];
        final accountType = data['account_type'] ?? '';

        await saveToken(token);
        await saveRole(accountType);

        try {
          final me = await HttpUtil().get(
            AppRoutes.me,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            }),
          );
          final meData = _decodeResponse(me);
          if (meData['id'] != null) {
            await saveUserId(meData['id']);
          }
          return {
            'success': true,
            'data': {
              'access_token': token,
              'account_type': accountType,
              'role': accountType,
              'user': {
                'id': meData['id'],
                'first_name': meData['first_name'],
                'last_name': meData['last_name'],
                'email': meData['email'],
                'role': accountType,
              }
            }
          };
        } catch (e) {
          return {
            'success': true,
            'data': {
              'access_token': token,
              'account_type': accountType,
              'role': accountType,
              'user': {
                'id': 0,
                'first_name': '',
                'last_name': '',
                'email': email,
                'role': accountType,
              }
            }
          };
        }
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
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.forgotPassword,
        options: _jsonOptions(),
        data: {'email': email},
      );
      final data = _decodeResponse(response);
      return {'success': data['message'] != null, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String code) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.verifyOtp,
        options: _jsonOptions(),
        data: {'email': email, 'code': code},
      );
      final data = _decodeResponse(response);
      return {'success': data['message'] != null, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String email, String code, String newPassword) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.resetPassword,
        options: _jsonOptions(),
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
        },
      );
      final data = _decodeResponse(response);
      return {'success': data['message'] != null, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createMember({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    String? nationalId,
    String? staffId,
    required String accountType,
  }) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.createMember,
        options: await _authJsonOptions(),
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_no': phone,
          'national_id': nationalId,
          'staff_id': staffId,
          'account_type': accountType,
        },
      );
      final data = _decodeResponse(response);
      return {
        'success': data != null,
        'message': data['message'] ?? 'User created successfully'
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final response = await HttpUtil().get(
        AppRoutes.getAllUsers,
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return {'success': data != null, 'data': data};
    } catch (e) {
      return {'success': false, 'data': [], 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteUser(
      int userId, String role) async {
    try {
      final response = await HttpUtil().delete(
        AppRoutes.deleteUser(userId),
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return {
        'success': data != null,
        'message': data['message'] ?? data['detail']
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      final response = await HttpUtil().get(
        AppRoutes.getProfile(userId),
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return {'success': data != null, 'data': data};
    } catch (e) {
      return {'success': false, 'data': null, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getRefactorMe() async {
    try {
      final response = await HttpUtil().get(
        AppRoutes.me,
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return {'success': data != null, 'data': data};
    } catch (e) {
      return {'success': false, 'data': null, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(
      int userId, Map<String, dynamic> profileData) async {
    try {
      final response = await HttpUtil().put(
        AppRoutes.updateProfile(userId),
        options: await _authJsonOptions(),
        data: profileData,
      );
      final data = _decodeResponse(response);
      return {
        'success': data != null,
        'data': data,
        'message': data['detail'] ?? 'Updated successfully'
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // static Future<Map<String, dynamic>> updatePersonalSettings(
  //     int userId, Map<String, dynamic> settings) async {
  //   try {
  //     final response = await HttpUtil().put(
  //       ApiEndpoints.personalSettings(userId),
  //       options: await _authJsonOptions(),
  //       data: settings,
  //     );
  //     final data = _decodeResponse(response);
  //     return {
  //       'success': data != null,
  //       'data': data,
  //       'message': data['detail'] ?? 'Settings updated successfully'
  //     };
  //   } catch (e) {
  //     return {'success': false, 'message': e.toString()};
  //   }
  // }

  static Future<Map<String, dynamic>> authenticatedGet(String endpoint) async {
    try {
      final response = await HttpUtil().get(
        endpoint,
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return {'success': data != null, 'data': data};
    } catch (e) {
      return {'success': false, 'data': null, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> authenticatedPost(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await HttpUtil().post(
        endpoint,
        options: await _authJsonOptions(),
        data: body,
      );
      final data = _decodeResponse(response);
      return {'success': data != null, 'data': data};
    } catch (e) {
      return {'success': false, 'data': null, 'message': e.toString()};
    }
  }
}
