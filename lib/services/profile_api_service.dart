import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileApiService {
  static const String _baseUrl = 'http://localhost:8000/api/v1';
  late final Dio _dio;

  ProfileApiService() {
    print('🔧 ProfileApiService _baseUrl: $_baseUrl');
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: 15),
    ));
    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          print('Token expired');
        }
        handler.next(error);
      },
    ));
  }

  Future<UserProfile?> getCurrentProfile() async {
    try {
      final response = await _dio.get('/profile/me');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('🔑 No JWT - Guest mode');
        return null;
      }
      print('🌐 Error: ${e.message}');
      rethrow;
    }
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('/profile/me', data: data);
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_parseError(e));
    }
  }

  String _parseError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }
    return e.message ?? 'Unknown error occurred';
  }
}
