import 'package:flutter/material.dart';
import 'package:graville_operations/models/Inventory.dart';
import 'package:graville_operations/models/material/material_data.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/inventory/widgets/inventory_card.dart';
import 'package:graville_operations/screens/inventory/widgets/inventory_tile.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Inventory? selectedInventory;

  final List<Inventory> inventoryData = [
    Inventory(
      site: "Plaza 2000 - Nairobi",
      materials: [
        MaterialData(name: "Cement", quantity: "450", unit: "bags"),
        MaterialData(name: "Steel Rods", quantity: "2,340", unit: "units"),
        MaterialData(name: "Sand", quantity: "85", unit: "tons"),
        MaterialData(name: "Bricks", quantity: "12,500", unit: "units"),
      ],
      hiredTools: [
        MaterialData(name: "Concrete Mixer", quantity: "3", unit: "units"),
        MaterialData(name: "Electric Drill", quantity: "8", unit: "units"),
        MaterialData(name: "Scaffolding", quantity: "12", unit: "units"),
        MaterialData(name: "Generator", quantity: "2", unit: "units"),
      ],
      createdAt: DateTime.now(),
    ),
    Inventory(
      site: "Huruma",
      materials: [
        MaterialData(name: "Cement", quantity: "300", unit: "bags"),
        MaterialData(name: "Steel Rods", quantity: "1,500", unit: "units"),
        MaterialData(name: "Sand", quantity: "50", unit: "tons"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
        MaterialData(name: "Bricks", quantity: "8,000", unit: "units"),
      ],
      hiredTools: [
        MaterialData(name: "Concrete Mixer", quantity: "2", unit: "units"),
      ],
      createdAt: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Optional: start with first site selected
    if (inventoryData.isNotEmpty) {
      selectedInventory = inventoryData.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final materials = selectedInventory?.materials ?? [];
    final tools = selectedInventory?.hiredTools ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Construction Site",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: CustomDropdown<Inventory>(
                value: selectedInventory,
                items: inventoryData,
                displayMapper: (inv) => inv.site,
                onChanged: (Inventory? newValue) {
                  setState(() => selectedInventory = newValue);
                },
                hint: "Select site",
                isExpanded: true,
                isDense: true,
                border: InputBorder.none,
                fillColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Materials",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF34495E),
              ),
            ),
            const SizedBox(height: 10),

            InventoryCard(
              children: [
                ...materials.map(
                  (m) => Column(
                    children: [
                      InventoryTile(
                        icon: _getMaterialIcon(m.name),
                        color: Colors.blue,
                        title: m.name,
                        value: "${m.quantity} ${m.unit}",
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),
                AddButton(label: "Add Material", onTap: () {}),
              ],
            ),

            const SizedBox(height: 25),
            const Text(
              "Hired Tools",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF34495E),
              ),
            ),
            const SizedBox(height: 10),
            InventoryCard(
              children: [
                ...tools.map(
                  (t) => Column(
                    children: [
                      InventoryTile(
                        icon: _getToolIcon(t.name),
                        color: Colors.orange,
                        title: t.name,
                        value: "${t.quantity} ${t.unit}",
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),
                AddButton(label: "Add Hired Tool", onTap: () {}),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  IconData _getMaterialIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('cement')) return Icons.view_in_ar;
    if (lower.contains('steel') || lower.contains('rod')) return Icons.adjust;
    if (lower.contains('sand')) return Icons.grid_on;
    if (lower.contains('brick')) return Icons.layers;
    return Icons.inventory_2_outlined;
  }

  IconData _getToolIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('mixer')) return Icons.build_circle_outlined;
    if (lower.contains('drill')) return Icons.electric_bolt_outlined;
    if (lower.contains('scaffold')) return Icons.architecture;
    if (lower.contains('generator') || lower.contains('gen')) return Icons.bolt;
    return Icons.construction;
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
