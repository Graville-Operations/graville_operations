//
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserStore {
//   // Singleton pattern
//   static final UserStore _instance = UserStore._internal();
//   static UserStore get to => _instance;
//   factory UserStore() => _instance;
//   UserStore._internal();
//
//   // In-memory state (no observables)
//   String token = '';
//   UserData _profile = UserData();
//   bool _isLogin = false;
//
//   bool get isLogin => _isLogin;
//   UserData get profile => _profile;
//   bool get hasToken => token.isNotEmpty;
//
//   // Call this once at app startup (e.g. in main.dart)
//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     token = prefs.getString(STORAGE_USER_TOKEN_KEY) ?? '';
//     final profileOffline = prefs.getString(STORAGE_USER_PROFILE_KEY) ?? '';
//
//     if (profileOffline.isNotEmpty) {
//       _isLogin = true;
//       _profile = UserData.fromJson(jsonDecode(profileOffline));
//     }
//
//     print("... userstore isLogin: $_isLogin");
//   }
//
//   // Save token
//   Future<void> setToken(String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(STORAGE_USER_TOKEN_KEY, value);
//     token = value;
//   }
//
//   // Get profile string from storage
//   Future<String> getProfile() async {
//     if (token.isEmpty) return '';
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(STORAGE_USER_PROFILE_KEY) ?? '';
//   }
//
//   // Save profile to storage and memory
//   Future<void> saveProfile(UserData profile) async {
//     final prefs = await SharedPreferences.getInstance();
//     _isLogin = true;
//     _profile = profile;
//     await prefs.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
//     await setToken(profile.accessToken!);
//   }
//
//   // Logout
//   Future<void> onLogout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(STORAGE_USER_TOKEN_KEY);
//     await prefs.remove(STORAGE_USER_PROFILE_KEY);
//     _isLogin = false;
//     token = '';
//     _profile = UserData();
//     print('... deleted the data from local storage');
//   }
// }