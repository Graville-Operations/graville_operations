import 'package:flutter/material.dart';
import 'package:graville_operations/screens/inventory_screen/site_data.dart';
void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false, 
  home: InventoryScreen()
));

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  String selectedSite = 'Plaza 2000 - Nairobi';

  @override
  Widget build(BuildContext context) {
    final data = SiteData.inventory[selectedSite]!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Inventory', 
          style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Construction Site", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
               ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSite,
                  isExpanded: true,
                  menuMaxHeight: 400, // Important for long lists
                  dropdownColor: const Color(0xFFF5F7F9),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                  items: SiteData.inventory.keys.map((String site) {
                    return DropdownMenuItem(value: site, child: Text(site));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedSite = val!),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Materials", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF34495E))),
            const SizedBox(height: 10),

            InventoryCard(children: [
              InventoryTile(icon: Icons.view_in_ar, color: Colors.blue, title: "Cement", value: data['cement']!),
              const Divider(height: 1),
              InventoryTile(icon: Icons.adjust, color: Colors.blue, title: "Steel Rods", value: data['steel']!),
              const Divider(height: 1),
              InventoryTile(icon: Icons.grid_on, color: Colors.blue, title: "Sand", value: data['sand']!),
              const Divider(height: 1),
              InventoryTile(icon: Icons.layers, color: Colors.blue, title: "Bricks", value: data['bricks']!),
              AddButton(label: "Add Material", onTap: () {}),
            ]),

            const SizedBox(height: 25),
            const Text("Hired Tools", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF34495E))),
            const SizedBox(height: 10),

            InventoryCard(children: [
              InventoryTile(icon: Icons.build_circle_outlined, color: Colors.orange, title: "Concrete Mixer", value: data['mixer']!),
              const Divider(height: 1),
              InventoryTile(icon: Icons.electric_bolt_outlined, color: Colors.orange, title: "Electric Drill", value: data['drill']!),
              const Divider(height: 1),
              InventoryTile(icon: Icons.architecture, color: Colors.orange, title: "Scaffolding", value: data['scaffold']!),
              const Divider(height: 1),
              InventoryTile(icon: Icons.bolt, color: Colors.orange, title: "Generator", value: data['gen']!),
              AddButton(label: "Add Hired Tool", onTap: () {}),
            ]),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
class InventoryCard extends StatelessWidget {
  final List<Widget> children;
  const InventoryCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }
}

class InventoryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const InventoryTile({super.key, required this.icon, required this.color, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        // ignore: deprecated_member_use
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50), fontSize: 14)),
    );
  }
}

class AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AddButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.add, size: 18, color: Colors.blue),
          label: Text(label, style: const TextStyle(color: Colors.blue)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}