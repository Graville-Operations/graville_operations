import 'dart:convert';
import 'package:graville_operations/screens/settings/edit_profile_screen.dart';
import 'package:http/http.dart' as http;
//import 'package:graville_operations/models/material/edit_profile.dart'
//import 'package:graville_operations/models/personal_settings.dart'

class ApiService {
  static const String baseUrl = 'https://your-api-base-url.com/api';

  // Headers without authentication
  Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  // Get user profile
  Future<EditProfileScreen> getProfile(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return EditProfileScreen.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // Update user profile
  Future<EditProfileScreen> updateProfile(EditProfileScreen profile) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/${profile.userId}'),
        headers: _getHeaders(),
        body: json.encode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        return EditProfileScreen.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // Update personal settings
  // Future<PersonalSettings> updatePersonalSettings(
  //   int userId,
  //   PersonalSettings settings
  // ) async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$baseUrl/users/$userId/settings'),
  //       headers: _getHeaders(),
  //       body: json.encode(settings.toJson()),
  //     );

  //     if (response.statusCode == 200) {
  //       return PersonalSettings.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to update settings: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error updating settings: $e');
  //   }
  // }

  // Optional: Add a method to check API connectivity
  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'), headers: _getHeaders())
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
