import 'package:flutter/material.dart';
import 'package:graville_operations/screens/application/widgets/menus_card.dart';

const Color kPrimary = Color(0xFF1A237E);
const Color kPrimaryLight = Color(0xFFE8EAF6);

class MenusScreen extends StatefulWidget {
  const MenusScreen({super.key});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  static const int subMenuDisplayLimit = 3;

  final List<Map<String, dynamic>> allMenus = [
    {
      "name": "site_management",
      "title": "Site Management",
      "link": "/site-management",
      "subMenus": [
        {"name": "site_overview", "title": "Site Overview", "link": "/site-management/overview"},
        {"name": "daily_reports", "title": "Daily Reports", "link": "/site-management/daily-reports"},
        {"name": "site_inspections", "title": "Site Inspections", "link": "/site-management/inspections"},
        {"name": "site_access", "title": "Site Access Control", "link": "/site-management/access"},
        {"name": "progress_tracking", "title": "Progress Tracking", "link": "/site-management/progress"},
        {"name": "site_diary", "title": "Site Diary", "link": "/site-management/diary"},
      ],
    },
    {
      "name": "tenders",
      "title": "Tenders",
      "link": "/tenders",
      "subMenus": [
        {"name": "active_tenders", "title": "Active Tenders", "link": "/tenders/active"},
        {"name": "tender_applications", "title": "Tender Applications", "link": "/tenders/applications"},
        {"name": "bid_documents", "title": "Bid Documents", "link": "/tenders/bid-documents"},
        {"name": "boq_management", "title": "BOQ Management", "link": "/tenders/boq"},
        {"name": "tender_results", "title": "Tender Results", "link": "/tenders/results"},
        {"name": "prequalification", "title": "Pre-qualification", "link": "/tenders/prequalification"},
      ],
    },
    {
      "name": "project_operations",
      "title": "Project Operations",
      "link": "/project-operations",
      "subMenus": [
        {"name": "task_tracker", "title": "Task Tracker", "link": "/project-operations/tasks"},
        {"name": "milestones", "title": "Milestones", "link": "/project-operations/milestones"},
        {"name": "work_orders", "title": "Work Orders", "link": "/project-operations/work-orders"},
        {"name": "daily_logs", "title": "Daily Logs", "link": "/project-operations/daily-logs"},
        {"name": "change_requests", "title": "Change Requests", "link": "/project-operations/changes"},
        {"name": "snagging_list", "title": "Snagging List", "link": "/project-operations/snagging"},
      ],
    },
    {
      "name": "finance",
      "title": "Finance",
      "link": "/finance",
      "subMenus": [
        {"name": "budget_overview", "title": "Budget Overview", "link": "/finance/budget"},
        {"name": "invoices", "title": "Invoices", "link": "/finance/invoices"},
        {"name": "purchase_orders", "title": "Purchase Orders", "link": "/finance/purchase-orders"},
        {"name": "expense_claims", "title": "Expense Claims", "link": "/finance/expenses"},
        {"name": "petty_cash", "title": "Petty Cash", "link": "/finance/petty-cash"},
        {"name": "payroll", "title": "Payroll", "link": "/finance/payroll"},
      ],
    },
    {
      "name": "architecture",
      "title": "Architecture",
      "link": "/architecture",
      "subMenus": [
        {"name": "drawing_register", "title": "Drawing Register", "link": "/architecture/drawings"},
        {"name": "design_reviews", "title": "Design Reviews", "link": "/architecture/design-reviews"},
        {"name": "revisions_log", "title": "Revisions Log", "link": "/architecture/revisions"},
        {"name": "as_built_drawings", "title": "As-Built Drawings", "link": "/architecture/as-built"},
        {"name": "specifications", "title": "Specifications", "link": "/architecture/specs"},
        {"name": "arch_reports", "title": "Arch. Reports", "link": "/architecture/reports"},
      ],
    },
    {
      "name": "resource_equipment",
      "title": "Resource & Equipment",
      "link": "/resource-equipment",
      "subMenus": [
        {"name": "equipment_list", "title": "Equipment List", "link": "/resource-equipment/equipment"},
        {"name": "material_requests", "title": "Material Requests", "link": "/resource-equipment/materials"},
        {"name": "fuel_logs", "title": "Fuel Logs", "link": "/resource-equipment/fuel"},
        {"name": "equipment_maintenance", "title": "Equipment Maintenance", "link": "/resource-equipment/maintenance"},
        {"name": "plant_register", "title": "Plant Register", "link": "/resource-equipment/plant"},
      ],
    },
  ];

  List<Map<String, dynamic>> filteredMenus = [];

  @override
  void initState() {
    super.initState();
    filteredMenus = List.from(allMenus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        title: const Text(
          "Menus",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddMenuDialog,
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
                onChanged: searchMenus,
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

            const Text(
              "ALL MENUS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: kPrimary,
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.35,
                ),
                itemCount: filteredMenus.length,
                itemBuilder: (context, index) {
                  final menu = filteredMenus[index];
                  final subMenuTitles = (menu["subMenus"] as List)
                      .map((s) => s["title"] as String)
                      .toList();
                  return MenuCard(
                    title: menu["title"],
                    subMenus: subMenuTitles,
                    displayLimit: subMenuDisplayLimit,
                    onEdit: () => showEditMenuDialog(menu),
                    onDelete: () => confirmDelete(menu),
                    onAddSubMenu: (menuTitle) => showAddSubMenuDialog(menu),
                    onDeleteSubMenu: (subMenuTitle) => confirmDeleteSubMenu(menu, subMenuTitle),
                    onSubMenuTap: (subMenuTitle) => showSubMenuDetail(context, menu, subMenuTitle),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchMenus(String query) {
    setState(() {
      filteredMenus = allMenus
          .where((m) => m["title"].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ➕ Add Menu
  void showAddMenuDialog() {
    final nameController = TextEditingController();
    final titleController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Menu", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "e.g. site_management",
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  hintText: "e.g. Site Management",
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: "Link",
                  hintText: "e.g. /site-management",
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  allMenus.add({
                    "name": nameController.text.isEmpty
                        ? titleController.text.toLowerCase().replaceAll(' ', '_')
                        : nameController.text,
                    "title": titleController.text,
                    "link": linkController.text.isEmpty
                        ? "/${titleController.text.toLowerCase().replaceAll(' ', '-')}"
                        : linkController.text,
                    "subMenus": <Map<String, dynamic>>[],
                  });
                  filteredMenus = List.from(allMenus);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
  }

  // ✏️ Edit Menu
  void showEditMenuDialog(Map menu) {
    final nameController = TextEditingController(text: menu["name"]);
    final titleController = TextEditingController(text: menu["title"]);
    final linkController = TextEditingController(text: menu["link"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Menu", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name", isDense: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title", isDense: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: "Link", isDense: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                menu["name"] = nameController.text;
                menu["title"] = titleController.text;
                menu["link"] = linkController.text;
                filteredMenus = List.from(allMenus);
              });
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
  }

  // 🗑 Delete Menu
  void confirmDelete(Map menu) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Menu", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
        content: Text("Delete '${menu["title"]}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                allMenus.remove(menu);
                filteredMenus = List.from(allMenus);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ➕ Add Sub-menu
  void showAddSubMenuDialog(Map menu) {
    final nameController = TextEditingController();
    final titleController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add Sub-menu to\n'${menu["title"]}'",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "e.g. site_overview",
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  hintText: "e.g. Site Overview",
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: "Link",
                  hintText: "e.g. /site-management/overview",
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  (menu["subMenus"] as List).add({
                    "name": nameController.text.isEmpty
                        ? titleController.text.toLowerCase().replaceAll(' ', '_')
                        : nameController.text,
                    "title": titleController.text,
                    "link": linkController.text.isEmpty
                        ? "${menu["link"]}/${titleController.text.toLowerCase().replaceAll(' ', '-')}"
                        : linkController.text,
                  });
                  filteredMenus = List.from(allMenus);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add", style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
  }

  // 🗑 Delete Sub-menu
  void confirmDeleteSubMenu(Map menu, String subMenuTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Sub-menu", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
        content: Text("Delete '$subMenuTitle' from '${menu["title"]}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                (menu["subMenus"] as List).removeWhere((s) => s["title"] == subMenuTitle);
                filteredMenus = List.from(allMenus);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 👁 Sub-menu detail (bottom sheet only, no separate screen)
  void showSubMenuDetail(BuildContext context, Map menu, String subMenuTitle) {
    final subMenu = (menu["subMenus"] as List).firstWhere(
      (s) => s["title"] == subMenuTitle,
      orElse: () => {"name": "", "title": subMenuTitle, "link": ""},
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                          subMenu["title"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Part of: ${menu["title"]}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit sub-menu from detail view
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showEditSubMenuDialog(menu, subMenu);
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Detail rows
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildDetailRow(Icons.label_outline, "Name", subMenu["name"] ?? ""),
                  const SizedBox(height: 10),
                  buildDetailRow(Icons.title, "Title", subMenu["title"] ?? ""),
                  const SizedBox(height: 10),
                  buildDetailRow(Icons.link, "Link", subMenu["link"] ?? ""),
                  const SizedBox(height: 10),
                  buildDetailRow(Icons.folder_outlined, "Parent Menu", menu["title"]),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 16, color: kPrimary),
                  label: const Text("Close", style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600)),
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

  // ✏️ Edit Sub-menu
  void showEditSubMenuDialog(Map menu, Map subMenu) {
    final nameController = TextEditingController(text: subMenu["name"]);
    final titleController = TextEditingController(text: subMenu["title"]);
    final linkController = TextEditingController(text: subMenu["link"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Sub-menu", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name", isDense: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title", isDense: true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(labelText: "Link", isDense: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                subMenu["name"] = nameController.text;
                subMenu["title"] = titleController.text;
                subMenu["link"] = linkController.text;
                filteredMenus = List.from(allMenus);
              });
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: kPrimary)),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: kPrimary),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: kPrimary, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}