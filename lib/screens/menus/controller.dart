import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/core/remote/api/menus.dart';

class MenusController extends GetxController {
  final RxList<MenuItem> menus = <MenuItem>[].obs;
  final RxList<MenuItem> filteredMenus = <MenuItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllMenus();
  }

  void searchMenus(String query) {
    if (query.isEmpty) {
      filteredMenus.assignAll(menus);
    } else {
      filteredMenus.assignAll(menus.where(
        (m) => (m.title ?? '').toLowerCase().contains(query.toLowerCase()),
      ));
    }
  }

  Future<void> fetchAllMenus() async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'Loading menus...');
      final result = await MenuApi.getAllMenus();
      menus.assignAll(result);
      filteredMenus.assignAll(result);
    } catch (_) {
      EasyLoading.showError('Failed to load menus');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> createMenu({
    required String name,
    required String title,
    String? link,
  }) async {
    try {
      EasyLoading.show(status: 'Creating menu...');
      final newMenu = await MenuApi.createMenu(name: name, title: title, link: link);
      menus.add(newMenu);
      filteredMenus.assignAll(menus);
      EasyLoading.showSuccess('Menu created');
    } catch (_) {
      EasyLoading.showError('Failed to create menu');
    }
  }

  Future<void> createSubMenu({
    required String menuRefId,
    required String name,
    required String title,
    String? link,
  }) async {
    try {
      EasyLoading.show(status: 'Adding sub-menu...');
      final newSub = await MenuApi.createSubMenu(
        menuRefId: menuRefId, name: name, title: title, link: link,
      );
      final index = menus.indexWhere((m) => m.refId == menuRefId);
      if (index != -1) {
        final m = menus[index];
        menus[index] = MenuItem(
          refId: m.refId, id: m.id, name: m.name, title: m.title,
          link: m.link, icon: m.icon, priority: m.priority,
          subMenus: [...m.subMenus, newSub],
        );
        filteredMenus.assignAll(menus);
      }
      EasyLoading.showSuccess('Sub-menu added');
    } catch (_) {
      EasyLoading.showError('Failed to add sub-menu');
    }
  }

  Future<void> revokeMenu({required String groupId, required String menuRefId}) async {
    try {
      EasyLoading.show(status: 'Removing...');
      await MenuApi.revokeMenu(groupId: groupId, menuRefId: menuRefId);
      menus.removeWhere((m) => m.refId == menuRefId);
      filteredMenus.assignAll(menus);
      EasyLoading.showSuccess('Menu removed');
    } catch (_) {
      EasyLoading.showError('Failed to remove menu');
    }
  }
}