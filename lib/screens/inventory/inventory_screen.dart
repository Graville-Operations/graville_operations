import 'package:flutter/material.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
//import 'package:graville_operations/models/material/material_model.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/material/hired_materials.dart';
import 'package:graville_operations/services/inventory_service.dart';
//import 'package:graville_operations/services/material_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<String> sites = [
    'Plaza 2000 - Nairobi',
    'Huruma',
    'Mabatini',
    'Mishi Mboko',
    'DCC Kibra',
    'Iremele',
  ];
  String? selectedSite;

  List<InventoryModel> _inventory = [];
  List<MaterialModel> _materials = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        MaterialService.getAllInventory(),
        MaterialService.getMaterials(),
      ]);

      setState(() {
        _inventory = results[0] as List<InventoryModel>;
        _materials = results[1] as List<MaterialModel>;
        _isLoading = false;
      });
    } on MaterialServiceException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'Failed to load inventory. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade400,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _loadData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Construction Site',
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
                    child: CustomDropdown<String>(
                      value: selectedSite,
                      items: sites,
                      displayMapper: (s) => s,
                      onChanged: (val) => setState(() => selectedSite = val),
                      hint: 'Select site',
                      isExpanded: true,
                      isDense: true,
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Materials',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34495E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _InventoryCard(
                    children: [
                      if (_materials.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No materials found.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        ..._materials.map(
                          (m) => Column(
                            children: [
                              _InventoryTile(
                                icon: _getMaterialIcon(m.name),
                                color: Colors.blue,
                                title: m.name,
                                value: m.unit,
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        ),
                      _AddButton(
                        label: 'Add Material',
                        onTap: () async {
                          await context.push(const AddMaterialScreenRoute());
                          _loadData();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Inventory Stock',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34495E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _InventoryCard(
                    children: [
                      if (_inventory.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No inventory records found.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        ..._inventory.map(
                          (item) => Column(
                            children: [
                              _InventoryTile(
                                icon: _getMaterialIcon(item.name),
                                color: Colors.orange,
                                title: item.name,
                                value: '${item.quantity} ${item.unitType}',
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        ),
                      _AddButton(
                        label: 'Add Hired Tool',
                        onTap: () => context.push(HiredMaterialScreen()),
                      ),
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
}

class _InventoryCard extends StatelessWidget {
  final List<Widget> children;
  const _InventoryCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const _InventoryTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
          fontSize: 14,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
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

class AddMaterialScreenRoute extends StatelessWidget {
  const AddMaterialScreenRoute({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
