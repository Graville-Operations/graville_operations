
import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/remote/api/auth_api.dart';
import 'package:graville_operations/models/auth/user.dart';
import 'package:graville_operations/screens/account_screen/state.dart';

class AccountScreenController extends GetxController{
  var state = AccountScreenState();

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void languageChange(String language) {
    state.language.value = language;
  }

  void themeChange(String theme) {
    state.theme.value = theme;
  }
  Future<void> getUserData()async{
    User user = await UserStore.to.getProfile();
    state.user.value = user;
  }
}