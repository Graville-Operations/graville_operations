
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/menu_store.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/screens/application/state.dart';

class ApplicationController extends GetxController{
  var state = ApplicationState();
  static const _bottomNavNames = {'home', 'workers', 'inventory', 'account'};

  @override
  void onInit() {
    super.onInit();
    loadMenus();
    // _checkLogin();
  }
  void changeIndex(int index) {
    state.currentIndex.value = index;
  }
  // void _checkLogin() async {
  //   await Future.delayed(const Duration(microseconds: 300));
  //
  //   if (UserStore.to.isLogin) {
  //     Get.offAllNamed(AppRoutes.application);
  //   } else {
  //     Get.offAllNamed(AppRoutes.login);
  //   }
  // }
  void loadMenus() {
    final saved = UserStore.to.getMenus();
    state.bottomMenus.assignAll(
      saved.where((m) => _bottomNavNames.contains(m.name)).toList(),
    );
    state.drawerMenus.assignAll(
      saved.where((m) => !_bottomNavNames.contains(m.name)).toList(),
    );
  }

}