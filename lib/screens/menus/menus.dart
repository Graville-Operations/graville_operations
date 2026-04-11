import 'package:flutter/material.dart';

class MenusScreen extends StatefulWidget {
  const MenusScreen({super.key});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {

  // 🔵 ORIGINAL DATA
  List<Map<String, dynamic>> allMenus = [
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

  // 🔍 FILTERED DATA
  List<Map<String, dynamic>> filteredMenus = [];

  @override
  void initState() {
    super.initState();
    filteredMenus = List.from(allMenus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),

      appBar: AppBar(
        title: const Text("Menus"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenuDialog,
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 SEARCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: _searchMenus,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: "Search Menus...",
                ),
              ),
            ),

            const SizedBox(height: 16),

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

            Expanded(
              child: ListView.builder(
                itemCount: filteredMenus.length,
                itemBuilder: (context, index) {
                  final menu = filteredMenus[index];

                  return ExpandableMenuCard(
                    title: menu["title"],
                    subMenus: List<String>.from(menu["subMenus"]),
                    onDelete: () => _confirmDelete(menu),
                    onEdit: () => _showEditMenuDialog(menu),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🔍 SEARCH FUNCTION
  void _searchMenus(String query) {
    setState(() {
      filteredMenus = allMenus
          .where((menu) =>
              menu["title"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ➕ ADD
  void _showAddMenuDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Menu"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  allMenus.add({
                    "title": controller.text,
                    "subMenus": ["New Submenu"]
                  });
                  filteredMenus = List.from(allMenus);
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

  // ✏️ EDIT
  void _showEditMenuDialog(Map menu) {
    TextEditingController controller =
        TextEditingController(text: menu["title"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Menu"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                menu["title"] = controller.text;
                filteredMenus = List.from(allMenus);
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // 🗑 CONFIRM DELETE
  void _confirmDelete(Map menu) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Menu"),
        content: Text("Are you sure you want to delete ${menu["title"]}?"),
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
}

// 🔽 CARD
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
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            subtitle:
                Text("${widget.subMenus.length} sub-menus linked"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
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

          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.subMenus
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text("• $e"),
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}