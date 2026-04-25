import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/core/utils/constants.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/auth/groups.dart';
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
        AppRoutes.loginScreen,
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
   static Future<Map<String, dynamic>> getAllInvoices() async {
  try {
    final response = await HttpUtil().get(
      AppRoutes.getInvoices,
      options: await _authJsonOptions(),
    );

    final data = _decodeResponse(response);

    return {
      'success': true,
      'data': data,
    };
  } catch (e) {
    print('getAllInvoices error: $e');
    return {
      'success': false,
      'message': 'Failed to load invoices',
    };
  }
}
static Future<Map<String, dynamic>> createInvoice(
    Map<String, dynamic> payload) async {
  try {
    final response = await HttpUtil().post(
      AppRoutes.createInvoices, 
      options: await _authJsonOptions(),
      data: payload,
    );

    final data = _decodeResponse(response);

    return {
      'success': true,
      'data': data,
    };
  } catch (e) {
    print('createInvoice error: $e');
    return {
      'success': false,
      'message': 'Failed to create invoice',
    };
  }
}
// ✅ Correct — uses AppRoutes
static Future<Map<String, dynamic>> updateInvoiceStatus(
    int invoiceId, String status) async {
  try {
    final response = await HttpUtil().put(  
      AppRoutes.updateInvoiceStatus(invoiceId),
      options: await _authJsonOptions(),
      data: {'status': status},
    );
    final data = _decodeResponse(response);
    return {'success': true, 'data': data};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

static Future<Map<String, dynamic>> recordInvoicePayment(
    int invoiceId, double amount) async {
  try {
    final response = await HttpUtil().put( 
      AppRoutes.updateInvoicePayment(invoiceId),
      options: await _authJsonOptions(),
      data: {'amount_paid': amount},
    );
    final data = _decodeResponse(response);
    return {'success': true, 'data': data};
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

  // GET /api/v1/group — Get all groups
  static Future<List<Group>> getAllGroups() async {
    try {
      final response = await HttpUtil().get(
        AppRoutes.getAllGroups,
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return (data as List<dynamic>).map((g) => Group.fromJson(g)).toList();
    } catch (e) {
      throw Exception('Failed to load groups: $e');
    }
  }

  // GET /api/v1/group/{group_id} — Get group by ID
  static Future<Group> getGroupById(int groupId) async {
    try {
      final response = await HttpUtil().get(
        AppRoutes.getGroupById(groupId),
        options: await _authJsonOptions(),
      );
      final data = _decodeResponse(response);
      return Group.fromJson(data);
    } catch (e) {
      throw Exception('Group not found: $e');
    }
  }

  /// POST /api/v1/group/create — Create a new group
  static Future<Group> createGroup({
    required String title,
    required String description,
  }) async {
    try {
      final response = await HttpUtil().post(
        AppRoutes.createGroup,
        options: await _authJsonOptions(),
        data: {'title': title, 'description': description},
      );
      final data = _decodeResponse(response);
      return Group.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  /// POST /api/v1/group/{group_id}/menus — Assign menus to group
  static Future<void> assignMenuToGroup({
    required int groupId,
    required List<String> menuIds,
  }) async {
    try {
      await HttpUtil().post(
        AppRoutes.assignGroupMenus(groupId),
        options: await _authJsonOptions(),
        data: {'menu_ids': menuIds},
      );
    } catch (e) {
      throw Exception('Failed to assign menus: $e');
    }
  }

  /// POST /api/v1/group{group_id}/users/{user_id} — Assign user to group
  static Future<void> assignUserToGroup({
    required int groupId,
    required String userId,
  }) async {
    try {
      await HttpUtil().post(
        AppRoutes.assignUserToGroup(groupId, userId),
        options: await _authJsonOptions(),
      );
    } catch (e) {
      throw Exception('Failed to assign user: $e');
    }
  }
}
