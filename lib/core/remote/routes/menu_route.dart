class MenuRoute {
  static const String _prefix = "/menu";
  static const String myMenus = "$_prefix/me/menus";
  static const String allMenus = "$_prefix/all";
  static const String createMenu = "$_prefix/create-menu";

  static String createSubMenu(String menuId) => "$_prefix/$menuId/create-sub-menu";
  static String revokeMenu(String groupId, String menuId) => "$_prefix/$groupId/menus/$menuId";
}