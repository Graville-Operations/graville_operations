import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/local/entities/menu_data.dart';
import 'package:graville_operations/screens/application/widgets/menus_card.dart';
import 'controller.dart';

const Color kPrimary = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFFE8EAF6);

class MenusScreen extends StatelessWidget {
  const MenusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<MenusController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        title: const Text("Menus",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenuDialog(context, ctrl),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                onChanged: ctrl.searchMenus,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: 17, color: kPrimary),
                  hintText: "Search menus...",
                  hintStyle: TextStyle(fontSize: 13),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text("ALL MENUS",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                    color: kPrimary, letterSpacing: 0.8)),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: kPrimary));
                }
                if (ctrl.filteredMenus.isEmpty) {
                  return const Center(child: Text("No menus found."));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 15,
                    mainAxisSpacing: 15, childAspectRatio: 1.35,
                  ),
                  itemCount: ctrl.filteredMenus.length,
                  itemBuilder: (context, index) {
                    final MenuItem menu = ctrl.filteredMenus[index];
                    return MenuCard(
                      title: menu.title ?? '',
                      subMenus: menu.subMenus.map((s) => s.title ?? '').toList(),
                      displayLimit: 3,
                      onEdit: () => _showEditMenuDialog(context, ctrl, menu),
                      onDelete: () => _confirmDelete(context, ctrl, menu),
                      onAddSubMenu: (_) => _showAddSubMenuDialog(context, ctrl, menu),
                      onDeleteSubMenu: (subTitle) =>
                          _confirmDeleteSubMenu(context, ctrl, menu, subTitle),
                      onSubMenuTap: (subTitle) =>
                          _showSubMenuDetail(context, menu, subTitle),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Menu
void _showAddMenuDialog(BuildContext context, MenusController ctrl) {
  final nameCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final linkCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Add Menu",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name", hintText: "e.g. site_management", isDense: true)),
          const SizedBox(height: 10),
          TextField(controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title", hintText: "e.g. Site Management", isDense: true)),
          const SizedBox(height: 10),
          TextField(controller: linkCtrl,
              decoration: const InputDecoration(labelText: "Link", hintText: "e.g. /site-management", isDense: true)),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            if (titleCtrl.text.isNotEmpty) {
              ctrl.createMenu(
                name: nameCtrl.text.isEmpty
                    ? titleCtrl.text.toLowerCase().replaceAll(' ', '_')
                    : nameCtrl.text,
                title: titleCtrl.text,
                link: linkCtrl.text.isEmpty ? null : linkCtrl.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Add", style: TextStyle(color: kPrimary)),
        ),
      ],
    ),
  );
}

// Edit Menu
void _showEditMenuDialog(BuildContext context, MenusController ctrl, MenuItem menu) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Edit Menu",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
      content: const Text("Edit endpoint not yet available on backend."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
      ],
    ),
  );
}

// Delete Menu 
void _confirmDelete(BuildContext context, MenusController ctrl, MenuItem menu) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Delete Menu",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
      content: Text("Remove '${menu.title}' from its group?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            // groupId needed — adjust once you have group context
            ctrl.revokeMenu(groupId: '1', menuRefId: menu.refId ?? '');
            Navigator.pop(context);
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

//  Add Sub-menu
void _showAddSubMenuDialog(BuildContext context, MenusController ctrl, MenuItem menu) {
  final nameCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final linkCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Add Sub-menu to\n'${menu.title}'",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimary)),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name", isDense: true)),
          const SizedBox(height: 10),
          TextField(controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title", isDense: true)),
          const SizedBox(height: 10),
          TextField(controller: linkCtrl,
              decoration: const InputDecoration(labelText: "Link", isDense: true)),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            if (titleCtrl.text.isNotEmpty) {
              ctrl.createSubMenu(
                menuRefId: menu.id ??0, 
                name: nameCtrl.text.isEmpty
                    ? titleCtrl.text.toLowerCase().replaceAll(' ', '_')
                    : nameCtrl.text,
                title: titleCtrl.text,
                link: linkCtrl.text.isEmpty ? null : linkCtrl.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Add", style: TextStyle(color: kPrimary)),
        ),
      ],
    ),
  );
}

// Delete Sub-menu
void _confirmDeleteSubMenu(BuildContext context, MenusController ctrl,
    MenuItem menu, String subMenuTitle) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Delete Sub-menu",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
      content: Text("Delete '$subMenuTitle' from '${menu.title}'?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(
          onPressed: () {
            // Sub-menu delete endpoint not in backend yet — add when available
            Navigator.pop(context);
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

// Sub-menu Detail
void _showSubMenuDetail(BuildContext context, MenuItem menu, String subMenuTitle) {
  final subMenu = menu.subMenus.firstWhere(
    (s) => s.title == subMenuTitle,
    orElse: () => SubMenu(title: subMenuTitle),
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 36, height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: kPrimary,
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: kPrimaryLight, borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.grid_view_rounded, size: 18, color: kPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(subMenu.title ?? '', style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Part of: ${menu.title}", style: TextStyle(
                      fontSize: 11, color: Colors.white.withOpacity(0.75))),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              _detailRow(Icons.label_outline, "Name", subMenu.name ?? ''),
              const SizedBox(height: 10),
              _detailRow(Icons.title, "Title", subMenu.title ?? ''),
              const SizedBox(height: 10),
              _detailRow(Icons.link, "Link", subMenu.link ?? ''),
              const SizedBox(height: 10),
              _detailRow(Icons.folder_outlined, "Parent Menu", menu.title ?? ''),
            ]),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 16, color: kPrimary),
                label: const Text("Close",
                    style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _detailRow(IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(children: [
      Icon(icon, size: 16, color: kPrimary),
      const SizedBox(width: 10),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      const Spacer(),
      Flexible(
        child: Text(value, textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, color: kPrimary, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis),
      ),
    ]),
  );
}