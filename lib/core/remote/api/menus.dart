import 'package:flutter/cupertino.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/remote/routes/menu_route.dart';
import 'package:graville_operations/core/utils/http.dart';

class MenuApi {
  static Future<List<MenuItem>> getMyMenu() async {
    final currentToken = UserStore.to.token;
    final cachedMenus = UserStore.to.getMenus();
    if (cachedMenus.isNotEmpty) {
      return cachedMenus;
    }
    try {
      final result = await HttpUtil().get(MenuRoute.myMenus);
      List<MenuItem> menus = (result as List<dynamic>)
          .map((menu) => MenuItem.fromJson(menu))
          .toList();
      await UserStore.to.saveMenus(menus, currentToken);
      return menus;
    } catch (e) {
      debugPrint("Error fetching menus: $e");
      rethrow;
    }
  }
}
