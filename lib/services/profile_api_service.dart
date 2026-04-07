import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/auth/user.dart';
import 'package:graville_operations/models/personal_settings.dart';

class ProfileApiService {
  final HttpUtil _http = HttpUtil();

  Future<User> getProfile(int userId) async {
    final url = '/profile/$userId';
    print('🌐 GET ${_http.dio.options.baseUrl}$url');
    final data = await _http.get('/profile/$userId');
    return User.fromJson(data);
  }

  Future<User> updateProfile(int userId, Map<String, dynamic> body) async {
    final data = await _http.put('/profile/$userId', data: body);
    return User.fromJson(data);
  }

  Future<PersonalSettings> updatePersonalSettings(
      int userId, Map<String, dynamic> body) async {
    final data =
        await _http.put('/profile/personal-settings/$userId', data: body);
    return PersonalSettings.fromJson(data);
  }
}
