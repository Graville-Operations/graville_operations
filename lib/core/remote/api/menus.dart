import 'package:flutter/cupertino.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/remote/routes/menu_route.dart';
import 'package:graville_operations/core/utils/http.dart';

class MenuApi {
  // GET  /me/menus (cached)
  static Future<List<MenuItem>> getMyMenu() async {
    final currentToken = UserStore.to.token;
    final cachedMenus = UserStore.to.getMenus();
    if (cachedMenus.isNotEmpty) return cachedMenus;
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

  // GET /all 
  static Future<List<MenuItem>> getAllMenus() async {
    try {
      final result = await HttpUtil().get(MenuRoute.allMenus);
      return (result as List<dynamic>)
          .map((e) => MenuItem.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("Error fetching all menus: $e");
      rethrow;
    }
  }

  // POST /create-menu 
  static Future<MenuItem> createMenu({
    required String name,
    required String title,
    String? link,
    String? icon,
    int? priority,
  }) async {
    try {
      final result = await HttpUtil().post(MenuRoute.createMenu, data: {
        'name': name,
        'title': title,
        if (link != null) 'link': link,
        if (icon != null) 'icon': icon,
        if (priority != null) 'priority': priority,
      });
      return MenuItem.fromJson(result);
    } catch (e) {
      debugPrint("Error creating menu: $e");
      rethrow;
    }
  }

  // POST /{menu_id}/create-sub-menu 
  static Future<SubMenu> createSubMenu({
    required int menuId,
    required String name,
    required String title,
    String? link,
    String? icon,
    int? priority,
  }) async {
    print("Creating sub-menu under menuRefId: $menuId with name: $name, title: $title");
    try {
      final result = await HttpUtil().post(
        MenuRoute.createSubMenu(menuId),
        data: {
          'name': name,
          'title': title,
          if (link != null) 'link': link,
          if (icon != null) 'icon': icon,
          if (priority != null) 'priority': priority,
        },
      );
      return SubMenu.fromJson(result);
    } catch (e) {
      debugPrint("Error creating sub-menu: $e");
      rethrow;
    }
  }

  // DELETE /{group_id}/menus/{menu_id} 
  static Future<void> revokeMenu({
    required String groupId,
    required String menuRefId,
  }) async {
    try {
      await HttpUtil().delete(MenuRoute.revokeMenu(groupId, menuRefId));
    } catch (e) {
      debugPrint("Error revoking menu: $e");
      rethrow;
    }
  }
}