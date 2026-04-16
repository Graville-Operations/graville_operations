import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFFE8EAF6);

class MenuCard extends StatelessWidget {
  final String title;
  final List<String> subMenus;
  final int displayLimit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onAddSubMenu;
  final Function(String)? onDeleteSubMenu;
  final Function(String)? onSubMenuTap;

  const MenuCard({
    super.key,
    required this.title,
    required this.subMenus,
    required this.displayLimit,
    this.onEdit,
    this.onDelete,
    this.onAddSubMenu,
    this.onDeleteSubMenu,
    this.onSubMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final shown = subMenus.take(displayLimit).toList();
    final hasMore = subMenus.length > displayLimit;

    return GestureDetector(
      onTap: () => openMenuDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top banner
            Container(
              decoration: const BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
              ),
              padding: const EdgeInsets.fromLTRB(10, 9, 8, 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: kPrimaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.grid_view_rounded, size: 14, color: kPrimary),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${subMenus.length} sub-menus",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: const Icon(Icons.edit, size: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Icon(Icons.delete, size: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Submenu preview
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 5),
              child: Column(
                children: shown.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: kPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          s,
                          style: const TextStyle(
                            fontSize: 11,
                            color: kPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),

            if (hasMore) ...[
              Divider(height: 0.5, thickness: 0.5, color: Colors.grey.shade100),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => openMenuDetail(context),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: kPrimary),
                  label: Text(
                    "View all ${subMenus.length}",
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: const Size(0, 26),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ] else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  void openMenuDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MenuDetailSheet(
        title: title,
        subMenus: subMenus,
        onEdit: onEdit,
        onDelete: onDelete,
        onAddSubMenu: onAddSubMenu,
        onDeleteSubMenu: onDeleteSubMenu,
        onSubMenuTap: onSubMenuTap,
      ),
    );
  }
}

class MenuDetailSheet extends StatelessWidget {
  final String title;
  final List<String> subMenus;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onAddSubMenu;
  final Function(String)? onDeleteSubMenu;
  final Function(String)? onSubMenuTap;

  const MenuDetailSheet({
    super.key,
    required this.title,
    required this.subMenus,
    this.onEdit,
    this.onDelete,
    this.onAddSubMenu,
    this.onDeleteSubMenu,
    this.onSubMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              color: kPrimary,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kPrimaryLight,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.grid_view_rounded, size: 18, color: kPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${subMenus.length} sub-menus",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onEdit?.call();
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete?.call();
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 20),
                  ),
                ],
              ),
            ),

            // Label row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                children: [
                  Text(
                    "SUB-MENUS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${subMenus.length} total",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),

            // Sub-menu list
            Expanded(
              child: ListView.separated(
                controller: controller,
                itemCount: subMenus.length,
                padding: const EdgeInsets.only(bottom: 8),
                separatorBuilder: (context, index) =>
                    Divider(height: 0.5, color: Colors.grey.shade100, indent: 16, endIndent: 16),
                itemBuilder: (context, i) => ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    onSubMenuTap?.call(subMenus[i]);
                  },
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: kPrimaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_right, color: kPrimary, size: 18),
                  ),
                  title: Text(
                    subMenus[i],
                    style: const TextStyle(
                      fontSize: 13,
                      color: kPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onDeleteSubMenu?.call(subMenus[i]);
                    },
                    child: Icon(Icons.remove_circle_outline, color: Colors.red.shade300, size: 18),
                  ),
                  dense: true,
                  minLeadingWidth: 10,
                ),
              ),
            ),

            // Bottom button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onAddSubMenu?.call(title);
                  },
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    "Add Sub-menu",
                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}