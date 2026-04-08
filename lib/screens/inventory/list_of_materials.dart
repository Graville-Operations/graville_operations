import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/inventory/add_material.dart';
import 'package:graville_operations/services/inventory_service.dart';

class MaterialsListScreen extends StatefulWidget {
  const MaterialsListScreen({super.key});

  @override
  State<MaterialsListScreen> createState() => _MaterialsListScreenState();
}

class _MaterialsListScreenState extends State<MaterialsListScreen> {
  List<InventoryModel> _materials = [];
  List<InventoryModel> _filteredMaterials = [];
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  void _onSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredMaterials = query.isEmpty ? _materials
          : _materials.where((m) =>
              m.name.toLowerCase().contains(query) ||
              m.unit.toLowerCase().contains(query) ||
              m.category.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final materials = await MaterialService.getMaterials();
      setState(() { _materials = materials; _filteredMaterials = materials; _isLoading = false; });
    } on MaterialServiceException catch (e) {
      setState(() { _errorMessage = e.message; _isLoading = false; });
    } catch (_) {
      setState(() { _errorMessage = 'Failed to load materials. Please try again.'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Materials List',
            style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: _loadData, tooltip: 'Refresh'),
        ],
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
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('List of Materials in the system',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF34495E))),
                  SizedBox(width: 160,
                      child: _SearchField(controller: _searchController, hint: 'Search material...')),
                ]),
                const SizedBox(height: 10),
                Expanded(
                  child: _isLoading
                      ? _ShimmerMaterialsList()
                      : _MaterialsCard(children: [
                          const _TableHeader(columns: ['Material', 'Unit', 'Category']),
                          if (_filteredMaterials.isEmpty)
                            const Padding(padding: EdgeInsets.all(16),
                                child: Text('No materials found.',
                                    style: TextStyle(color: Colors.grey)))
                          else
                            ..._filteredMaterials.map((m) => Column(children: [
                              _MaterialTile(icon: _getMaterialIcon(m.name),
                                  title: m.name, value: m.unit, extra: m.category),
                              const Divider(height: 1),
                            ])),
                          _AddButton(label: 'Add Material', onTap: () async {
                            await context.push(const AddMaterialScreen());
                            _loadData();
                          }),
                        ]),
                ),
                const SizedBox(height: 20),
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

class _ShimmerMaterialsList extends StatelessWidget {
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
          ...List.generate(6, (_) => Column(children: [
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
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 12)),
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

class _MaterialsCard extends StatelessWidget {
  final List<Widget> children;
  const _MaterialsCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03),
            blurRadius: 10, offset: const Offset(0, 4))]),
    child: SingleChildScrollView(child: Column(children: children)),
  );
}

class _MaterialTile extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final String? extra;
  const _MaterialTile({required this.icon, required this.title,
      required this.value, this.extra});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(children: [
      Container(width: 32, height: 32, padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.blue, size: 20)),
      const SizedBox(width: 10),
      Expanded(flex: 3, child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
      Expanded(flex: 2, child: Text(value, textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50), fontSize: 14))),
      Expanded(flex: 2, child: Text(extra ?? '-', textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black))),
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
      controller: controller, style: const TextStyle(fontSize: 13),
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