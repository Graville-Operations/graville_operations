import 'package:flutter/cupertino.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/remote/routes/menu_route.dart';
import 'package:graville_operations/core/utils/http.dart';

class MenuApi {
  static Future<List<MenuItem>> getMyMenu() async {
    final  result = await HttpUtil().get(MenuRoute.myMenus);
    debugPrint("...... remote getmenu()  ${result.toString()}");
    return (result as List<dynamic>)  // casting results to List of dynamic
        .map((menu)=>MenuItem.fromJson(menu)).toList(); // error was here since I passed MenuItem.fromJson(result)) which is the whole list
  }
}
