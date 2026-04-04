import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/local/entities/user_data.dart';
import 'package:graville_operations/core/local/store/storage_service.dart';
import 'package:graville_operations/core/local/store/values.dart';
import 'package:graville_operations/core/routes/names.dart';


class UserStore extends GetxController {
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
  Future<String> getProfile() async {
    if (token.isEmpty) return "";
    return StorageService.to.getString(storageUserProfileKey);
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
    print('... deleted the data from local storage');
    Get.offAllNamed(AppRoutes.login);
  }
  Future<void> saveMenusIfNeeded(List<MenuItem> menus, String currentToken) async {
    final savedToken = StorageService.to.getString(menuTokenKey);
    if (savedToken == currentToken && getMenus().isNotEmpty) {
      debugPrint("...... menus already up to date, skipping save");
      return;
    }
    await saveMenus(menus, currentToken);
  }
  Future<void> saveMenus(List<MenuItem> menus, String currentToken) async {
    final encoded = jsonEncode(menus.map((m) => m.toJson()).toList());
    await StorageService.to.setString(userMenus, encoded);
    await StorageService.to.setString(menuTokenKey, currentToken);
    debugPrint("...... menus saved successfully");
  }

  List<MenuItem> getMenus() {
    final raw = StorageService.to.getString(userMenus);
    if (raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw);
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
}
