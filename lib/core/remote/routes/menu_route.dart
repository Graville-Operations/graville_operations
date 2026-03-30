
class MenuRoute{
  static const String _prefix = "/menu";
  static const String myMenus = "$_prefix/me/menus";
  static const String allMenus = "$_prefix/all";
  static const String createMenu = "$_prefix/create-menu";
  static const String createSubMenu = "$_prefix/{menu_id}/create-sub-menu";
}