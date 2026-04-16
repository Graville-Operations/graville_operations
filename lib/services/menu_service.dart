import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/menus/menus_model.dart';

class MenuService {
  static const String _path = '/menus';
  static final _http = HttpUtil();

  /// GET /menus/all
  static Future<List<MenuModel>> getAllMenus() async {
    final data = await _http.get('$_path/all');

    return (data as List).map((json) => MenuModel.fromJson(json)).toList();
  }

  /// POST /menus/create-menu
  static Future<MenuModel> createMenu(MenuModel menu) async {
    final data = await _http.post(
      '$_path/create-menu',
      data: menu.toJson(),
    );

    return MenuModel.fromJson(data);
  }

  /// GET /menus/{menu_id}
  static Future<MenuModel> getMenuById(String refId) async {
    final data = await _http.get('$_path/$refId');
    return MenuModel.fromJson(data);
  }

  /// POST /menus/{menu_id}/create-sub-menu
  static Future<SubMenuModel> createSubMenu(
    String menuId,
    SubMenuModel subMenu,
  ) async {
    final data = await _http.post(
      '$_path/$menuId/create-sub-menu',
      data: subMenu.toJson(),
    );

    return SubMenuModel.fromJson(data);
  }

  /// GET /menus/sub-menus/all
  static Future<List<SubMenuModel>> getAllSubMenus() async {
    final data = await _http.get('$_path/sub-menus/all');

    return (data as List).map((json) => SubMenuModel.fromJson(json)).toList();
  }
}
