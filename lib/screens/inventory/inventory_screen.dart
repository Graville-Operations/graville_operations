import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/inventory/list_of_materials.dart';
import 'package:graville_operations/screens/inventory/update_inventory.dart';
import 'package:graville_operations/screens/material/hired_materials.dart';
import 'package:graville_operations/services/inventory_service.dart';
import 'package:graville_operations/screens/inventory/inventory_details_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<String> sites = [
    'Plaza 2000 - Nairobi', 'Huruma', 'Mabatini', 'Mishi Mboko', 'DCC Kibra', 'Iremele',
  ];
  String? selectedSite;

  List<InventoryModel> _inventory = [];
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _inventorySearchController = TextEditingController();
  List<InventoryModel> _filteredInventory = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _inventorySearchController.addListener(_onInventorySearch);
  }

  @override
  void dispose() { _inventorySearchController.dispose(); super.dispose(); }

  void _onInventorySearch() {
    final query = _inventorySearchController.text.toLowerCase().trim();
    setState(() {
      _filteredInventory = query.isEmpty ? _inventory
          : _inventory.where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.unit.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final inventory = await MaterialService.getAllInventory();
      setState(() { _inventory = inventory; _filteredInventory = inventory; _isLoading = false; });
    } on MaterialServiceException catch (e) {
      setState(() { _errorMessage = e.message; _isLoading = false; });
    } catch (_) {
      setState(() { _errorMessage = 'Failed to load inventory. Please try again.'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        title: const Row(children: [
          Icon(Icons.store, color: Colors.blue), SizedBox(width: 10),
          Text("Store", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: _loadData, tooltip: 'Refresh Inventory'),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push(const MaterialsListScreen()),
                icon: const Icon(Icons.inventory_2_outlined, size: 18),
                label: const Text('View Materials List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50), foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _errorMessage != null
          ? Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                const SizedBox(height: 12),
                Text(_errorMessage!, textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade600)),
                const SizedBox(height: 16),
                TextButton.icon(onPressed: _loadData,
                    icon: const Icon(Icons.refresh), label: const Text('Try Again')),
              ]),
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                const SizedBox(height: 16),
                const Text('Construction Site', style: TextStyle(color: Colors.black, fontSize: 12)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: CustomDropdown<String>(
                    value: selectedSite, items: sites, displayMapper: (s) => s,
                    onChanged: (val) => setState(() => selectedSite = val),
                    hint: 'Select site', isExpanded: true, isDense: true,
                    border: InputBorder.none, fillColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 25),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Inventory Stock',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF34495E))),
                  SizedBox(width: 160,
                      child: _SearchField(controller: _inventorySearchController, hint: 'Search stock...')),
                ]),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final updated = await context.push(const UpdateInventoryScreen(preSelectedItem: null));
                      if (updated == true) _loadData();
                    },
                    icon: const Icon(Icons.remove_circle_outline, size: 18),
                    label: const Text('Subtract Stock'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                _isLoading
                    ? _ShimmerInventoryList()
                    : _InventoryCard(children: [
                        const _TableHeader(columns: ['Material', 'Quantity', 'Status']),
                        if (_filteredInventory.isEmpty)
                          const Padding(padding: EdgeInsets.all(16),
                              child: Text('No inventory records found.',
                                  style: TextStyle(color: Colors.grey)))
                        else
                          ..._filteredInventory.map((item) => Column(children: [
                            GestureDetector(
                              onTap: () async {
                                final updated = await context.push(InventoryDetailScreen(item: item));
                                if (updated == true) _loadData();
                              },
                              child: _InventoryTile(
                                icon: _getMaterialIcon(item.name), color: Colors.orange,
                                title: item.name, value: '${item.quantity} ${item.unit}',
                                extra: item.quantity > 10 ? 'In Stock' : 'Low Stock',
                              ),
                            ),
                            const Divider(height: 1),
                          ])),
                      ]),

                const SizedBox(height: 25),
                const Text('Hired Tools',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF34495E))),
                const SizedBox(height: 10),

                _InventoryCard(children: [
                  _AddButton(label: 'Add Hired Tool',
                      onTap: () => context.push(HiredMaterialScreen())),
                ]),

                const SizedBox(height: 30),
              ]),
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
}

class _ShimmerInventoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(children: [
          Container(height: 40,
              decoration: const BoxDecoration(color: Color(0xFFF5F7F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)))),
          const Divider(height: 1),
          ...List.generate(5, (_) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(children: [
                Container(width: 32, height: 32,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 10),
                Expanded(flex: 3, child: _SBox(width: double.infinity, height: 12)),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 12)),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 20, radius: 10)),
              ]),
            ),
            const Divider(height: 1),
          ])),
        ]),
      ),
    );
  }
}

class _SBox extends StatelessWidget {
  final double width, height;
  final double radius;
  const _SBox({required this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) => Container(
      width: width, height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)));
}

class _InventoryCard extends StatelessWidget {
  final List<Widget> children;
  const _InventoryCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03),
            blurRadius: 10, offset: const Offset(0, 4))]),
    child: Column(children: children),
  );
}

class _InventoryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, value;
  final String? extra;
  const _InventoryTile({required this.icon, required this.color,
      required this.title, required this.value, this.extra});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(children: [
      Container(width: 32, height: 32, padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 20)),
      const SizedBox(width: 10),
      Expanded(flex: 3, child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
      Expanded(flex: 2, child: Text(value, textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50), fontSize: 14))),
      Expanded(flex: 2, child: Text(extra ?? '-', textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,
              color: extra == 'In Stock' ? Colors.green
                  : extra == 'Low Stock' ? Colors.red : Colors.black))),
    ]),
  );
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: SizedBox(width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add, size: 18, color: Colors.blue),
        label: Text(label, style: const TextStyle(color: Colors.blue)),
        style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12)),
      ),
    ),
  );
}

class _TableHeader extends StatelessWidget {
  final List<String> columns;
  const _TableHeader({required this.columns});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: const BoxDecoration(color: Color(0xFFF5F7F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    child: Row(children: [
      const SizedBox(width: 32), const SizedBox(width: 10),
      ...columns.map((col) => Expanded(
        flex: col == columns.first ? 3 : 2,
        child: Text(col,
          textAlign: col == columns.first ? TextAlign.left
              : col == columns.last ? TextAlign.right : TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
              color: Colors.black, letterSpacing: 0.5)),
      )),
    ]),
  );
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const _SearchField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint, hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isNotEmpty
              ? GestureDetector(onTap: () => controller.clear(),
                  child: const Icon(Icons.close, size: 16, color: Colors.grey))
              : const SizedBox.shrink(),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        filled: true, fillColor: const Color(0xFFF5F7F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue)),
      ),
    ),
  );
}