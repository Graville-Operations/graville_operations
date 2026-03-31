
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/menu_store.dart';
import 'package:graville_operations/screens/application/state.dart';

class ApplicationController extends GetxController{
  var state = ApplicationState();
  static const _bottomNavNames = {'home', 'workers', 'inventory', 'account'};

  @override
  void onInit() {
    super.onInit();
    loadMenus();
  }
  void changeIndex(int index) {
    state.currentIndex.value = index;
  }

  void loadMenus() {
    final saved = MenuStore.getMenus();
    state.bottomMenus.assignAll(
      saved.where((m) => _bottomNavNames.contains(m.name)).toList(),
    );
    state.drawerMenus.assignAll(
      saved.where((m) => !_bottomNavNames.contains(m.name)).toList(),
    );
  }

}