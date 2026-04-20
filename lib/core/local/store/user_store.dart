import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/local/entities/user_data.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/values.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/models/auth/user.dart';

class UserStore extends GetxController {
  // int userId = 12;
  static UserStore get to => Get.find();

  // checking if user is logged in
  final _isLogin = false.obs;

  // token
  String token = '';

  // profile
  final _profile = UserData().obs;

  bool get isLogin => _isLogin.value;

  UserData get profile => _profile.value;

  bool get hasToken => token.isNotEmpty;

  int get userId => _profile.value.id ?? 12;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(storageUserTokenKey);
    var profileOffline = StorageService.to.getString(storageUserProfileKey);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserData.fromJson(jsonDecode(profileOffline)));
    }
    debugPrint("... UserStore is login $_isLogin");
  }

  // saving token
  Future<void> setToken(String value) async {
    await StorageService.to.setString(storageUserTokenKey, value);
    token = value;
  }

  // get profile
  Future<User> getProfile() async {
    if (token.isEmpty) return User.empty();
    final String userData = StorageService.to.getString(storageUserProfileKey);
    var decoded = jsonDecode(userData);
    print("Get profile data returns this object : "+decoded.toString());
    return User.fromJson(decoded);
  }

  // saving profile
  Future<void> saveProfile(UserData profile) async {
    _isLogin.value = true;
    StorageService.to.setString(storageUserProfileKey, jsonEncode(profile));
  }

  // during logout
  Future<void> onLogout() async {
    //  if (_isLogin.value) await UserApi.logout();
    await StorageService.to.remove(storageUserTokenKey);
    await StorageService.to.remove(storageUserProfileKey);
    _isLogin.value = false;
    token = '';
    Get.offAllNamed(AppRoutes.login);
  }
  Future<void> saveMenusIfNeeded(List<MenuItem> menus, String currentToken) async {
    final savedToken = StorageService.to.getString(menuTokenKey);
    if (savedToken == currentToken && getMenus().isNotEmpty) {
      return;
    }
    await saveMenus(menus, currentToken);
  }
  Future<void> saveMenus(List<MenuItem> menus, String currentToken) async {
    final encoded = jsonEncode(menus.map((m) => m.toJson()).toList());
    await StorageService.to.setString(userMenus, encoded);
    await StorageService.to.setString(menuTokenKey, currentToken);
  }

  List<MenuItem> getMenus() {
    final rawMenus = StorageService.to.getString(userMenus);
    final storedMenuToken = StorageService.to.getString(menuTokenKey);
    if (rawMenus.isEmpty || storedMenuToken.isEmpty) {
      return [];
    }
    if (storedMenuToken != token) {
      clearMenus();
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(rawMenus);
      return decoded.map((menus) => MenuItem.fromJson(menus)).toList();
    } catch (e) {
      debugPrint("...... error reading menus $e");
      return [];
    }
  }
  static Future<void> clearMenus() async {
    await StorageService.to.remove(userMenus);
    await StorageService.to.remove(menuTokenKey);
  }

  static Future<void> updateMenu()async{

  }

  Map<String, String>? getAuthorizationHeader() {
    if (hasToken) {
      final token = UserStore.to.token;
      return {'Authorization': 'Bearer $token'};
    }
    return null;
  }
}
