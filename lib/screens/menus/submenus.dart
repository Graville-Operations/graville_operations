import 'package:flutter/material.dart';

class MenusScreen extends StatefulWidget {
  const MenusScreen({super.key});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {

  // ✅ ALL 3 MENUS RESTORED
  List<Map<String, dynamic>> menus = [
    {
      "title": "Site Management",
      "subMenus": [
        "Site Overview",
        "Site Reports",
        "Site Inspections"
      ]
    },
    {
      "title": "Project Operations",
      "subMenus": [
        "Task Tracker",
        "Milestones",
        "Work Orders",
        "Daily Logs"
      ]
    },
    {
      "title": "Resource & Equipment",
      "subMenus": [
        "Equipment List",
        "Material Requests"
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      // 🔙 BACK BUTTON
      appBar: AppBar(
        title: const Text("Menus"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ➕ ADD BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuDialog,
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search Menus...",
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🧾 ALL MENUS TEXT
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ALL MENUS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📋 MENU LIST
            Expanded(
              child: ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];

                  return ExpandableMenuCard(
                    title: menu["title"],
                    subMenus: List<String>.from(menu["subMenus"]),
                    onDelete: () => _deleteMenu(index),
                    onEdit: () => _showEditMenuDialog(index),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // ➕ ADD MENU
  void _showAddMenuDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Menu"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Menu name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  menus.add({
                    "title": controller.text,
                    "subMenus": ["New Submenu"] // optional default
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // ✏️ EDIT MENU
  void _showEditMenuDialog(int index) {
    TextEditingController controller =
        TextEditingController(text: menus[index]["title"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Menu"),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                menus[index]["title"] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // 🗑 DELETE MENU
  void _deleteMenu(int index) {
    setState(() {
      menus.removeAt(index);
    });
  }
}

class ExpandableMenuCard extends StatefulWidget {
  final String title;
  final List<String> subMenus;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ExpandableMenuCard({
    super.key,
    required this.title,
    required this.subMenus,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<ExpandableMenuCard> createState() => _ExpandableMenuCardState();
}

class _ExpandableMenuCardState extends State<ExpandableMenuCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.business, color: Colors.blue),
            title: Text(widget.title),
            subtitle:
                Text("${widget.subMenus.length} sub-menus linked"),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✏️ EDIT
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: widget.onEdit,
                ),

                // 🗑 DELETE
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),

                // ⬇️ EXPAND
                IconButton(
                  icon: Icon(isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                )
              ],
            ),
          ),

          if (isExpanded) ...[
            const Divider(height: 1),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SUB-MENUS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...widget.subMenus.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 8, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(e),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}