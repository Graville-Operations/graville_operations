import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:shimmer/shimmer.dart';
import 'package:graville_operations/models/inventory/inventory _model.dart';
import 'package:graville_operations/services/inventory_service.dart';

class _InventoryEntry {
  InventoryModel? selectedInventory;
  final TextEditingController unitController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void fillFrom(InventoryModel item) {
    selectedInventory = item;
    unitController.text = item.unit;
    categoryController.text = item.category;
    quantityController.text = '';
    descriptionController.text = item.description;
  }

  bool get isValid =>
      selectedInventory != null && quantityController.text.isNotEmpty;

  void dispose() {
    unitController.dispose();
    categoryController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
  }
}

class UpdateInventoryScreen extends StatefulWidget {
  final InventoryModel? preSelectedItem;
  const UpdateInventoryScreen({super.key, this.preSelectedItem});

  @override
  UpdateInventoryScreenState createState() => UpdateInventoryScreenState();
}

class UpdateInventoryScreenState extends State<UpdateInventoryScreen> {
  final List<String> allSites = [
    'PLAZA 2000', 'Kimnojun', 'DCC Kibra', 'Huruma', 'Ngei',
    'Timbwani', 'Wanga', 'Mabatini', 'Iremele', 'Shinyalu'
  ];
  String? selectedSite;

  List<InventoryModel> _inventoryItems = [];
  bool _isLoadingItems = true;
  bool _isSubmitting = false;
  String? _loadError;

  final List<_InventoryEntry> _entries = [_InventoryEntry()];
  bool get _isPreSelected => widget.preSelectedItem != null;

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
    if (widget.preSelectedItem != null) {
      _entries.first.fillFrom(widget.preSelectedItem!);
    }
  }

  @override
  void dispose() {
    for (final e in _entries) e.dispose();
    super.dispose();
  }

  Future<void> _loadInventoryItems() async {
    setState(() { _isLoadingItems = true; _loadError = null; });
    try {
      final items = await MaterialService.getAllInventory();
      setState(() {
        _inventoryItems = items;
        _isLoadingItems = false;
        if (widget.preSelectedItem != null) {
          final match = items.where((i) => i.id == widget.preSelectedItem!.id);
          if (match.isNotEmpty) _entries.first.fillFrom(match.first);
        }
      });
    } on MaterialServiceException catch (e) {
      setState(() { _loadError = e.message; _isLoadingItems = false; });
    } catch (_) {
      setState(() { _loadError = 'Failed to load store items.'; _isLoadingItems = false; });
    }
  }

  void _addEntry() => setState(() => _entries.add(_InventoryEntry()));

  void _removeEntry(int index) {
    setState(() { _entries[index].dispose(); _entries.removeAt(index); });
  }

  bool get _isFormValid =>
      (_isPreSelected || selectedSite != null) &&
      _entries.every((e) => e.isValid);

  Future<void> _submit() async {
    if (!_isFormValid) return;
    for (final entry in _entries) {
      final qty = int.tryParse(entry.quantityController.text.trim()) ?? 0;
      if (qty <= 0) {
        _showError('Enter a valid quantity greater than 0 for ${entry.selectedInventory!.name}.');
        return;
      }
      if (qty > entry.selectedInventory!.quantity) {
        _showError('Cannot subtract $qty from ${entry.selectedInventory!.name}. '
            'Current stock is ${entry.selectedInventory!.quantity} ${entry.selectedInventory!.unit}.');
        return;
      }
    }
    setState(() => _isSubmitting = true);
    try {
      for (final entry in _entries) {
        final updated = InventoryModel(
          name: entry.selectedInventory!.name,
          quantity: int.parse(entry.quantityController.text.trim()),
          category: entry.categoryController.text.trim().isNotEmpty
              ? entry.categoryController.text.trim() : entry.selectedInventory!.category,
          unit: entry.unitController.text.trim().isNotEmpty
              ? entry.unitController.text.trim() : entry.selectedInventory!.unit,
          unitPrice: entry.selectedInventory!.unitPrice,
          description: entry.descriptionController.text.trim(),
          operation: 'subtract',
        );
        await MaterialService.updateInventory(entry.selectedInventory!.id!, updated);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${_entries.length} item(s) updated successfully!'),
        backgroundColor: Colors.green.shade600, behavior: SnackBarBehavior.floating,
      ));
      Navigator.pop(context, true);
    } on MaterialServiceException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      debugPrint('Submit error: $e');
      if (e is DioException) debugPrint('Backend says: ${e.response?.data}');
      if (!mounted) return;
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message), backgroundColor: Colors.red.shade600,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          const Icon(Icons.remove_circle_outline, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            _isPreSelected ? 'Subtract — ${widget.preSelectedItem!.name}' : 'Subtract Stock',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ]),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoadingItems
          ? _SubtractSkeleton(isPreSelected: _isPreSelected)
          : _loadError != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(_loadError!, style: TextStyle(color: Colors.red.shade600)),
                  const SizedBox(height: 12),
                  TextButton.icon(onPressed: _loadInventoryItems,
                      icon: const Icon(Icons.refresh), label: const Text('Try Again')),
                ]))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 16),
                    if (!_isPreSelected) ...[
                      const Text('Construction Site',
                          style: TextStyle(color: Colors.black, fontSize: 12)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: CustomDropdown<String>(
                          value: selectedSite, items: allSites,
                          displayMapper: (s) => s,
                          onChanged: (val) => setState(() => selectedSite = val),
                          hint: 'Select site', isExpanded: true, isDense: true,
                          border: InputBorder.none, fillColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    ..._entries.asMap().entries.map((e) => _buildEntryCard(e.key, e.value)),

                    const SizedBox(height: 12),
                    if (!_isPreSelected)
                      OutlinedButton.icon(
                        onPressed: _addEntry,
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: const Text('Add Another Item',
                            style: TextStyle(color: Colors.blue)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: _entries.length > 1
                            ? 'Subtract ${_entries.length} Items' : 'Subtract Stock',
                        backgroundColor: Colors.red, textColor: Colors.white,
                        height: 55, borderRadius: 14, isLoading: _isSubmitting,
                        onPressed: _isFormValid && !_isSubmitting ? _submit : null,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: GestureDetector(
                        onTap: _isSubmitting ? null : () => Navigator.pop(context),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.blue, fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
    );
  }

  Widget _buildEntryCard(int index, _InventoryEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03),
              blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Card header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_isPreSelected ? entry.selectedInventory?.name ?? 'Item' : 'Item ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
                    color: Color(0xFF34495E))),
            if (_entries.length > 1 && !_isPreSelected)
              GestureDetector(onTap: () => _removeEntry(index),
                  child: const Icon(Icons.close, color: Colors.red, size: 20)),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!_isPreSelected) ...[
              const Text('Inventory Item', style: TextStyle(color: Colors.black, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200)),
                child: CustomDropdown<InventoryModel>(
                  value: entry.selectedInventory, items: _inventoryItems,
                  displayMapper: (item) => item.name,
                  onChanged: (item) { if (item != null) setState(() => entry.fillFrom(item)); },
                  hint: 'Select store item', isExpanded: true, isDense: true,
                  border: InputBorder.none, fillColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),
            ],

            if (entry.selectedInventory != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100)),
                child: Row(children: [
                  Icon(Icons.inventory_2_outlined, color: Colors.blue.shade600, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Current stock: ${entry.selectedInventory!.quantity} ${entry.selectedInventory!.unit}',
                    style: TextStyle(color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ]),
              ),
              const SizedBox(height: 14),
            ],

            const Text('Unit type', style: TextStyle(color: Colors.black, fontSize: 12)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Text(entry.unitController.text.isNotEmpty
                  ? entry.unitController.text : '—',
                  style: const TextStyle(fontSize: 15)),
            ),

            const SizedBox(height: 14),
            const Text('Category', style: TextStyle(color: Colors.black, fontSize: 12)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200)),
              child: Text(entry.categoryController.text.isNotEmpty
                  ? entry.categoryController.text : '—',
                  style: const TextStyle(fontSize: 15)),
            ),

            const SizedBox(height: 14),
            const Text('Quantity to Subtract *',
                style: TextStyle(color: Colors.black, fontSize: 12)),
            const SizedBox(height: 6),
            CustomTextInput(
              controller: entry.quantityController,
              hintText: 'Enter quantity used today',
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 14),
            const Text('Description (Optional)',
                style: TextStyle(color: Colors.black, fontSize: 12)),
            const SizedBox(height: 6),
            CustomTextInput(
              controller: entry.descriptionController,
              hintText: 'e.g., Used on Block A foundation',
              maxLines: 3,
            ),
          ]),
        ),
      ]),
    );
  }
}

class _SubtractSkeleton extends StatelessWidget {
  final bool isPreSelected;
  const _SubtractSkeleton({required this.isPreSelected});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),

          // Site dropdown placeholder (only when not pre-selected)
          if (!isPreSelected) ...[
            _SBox(width: 120, height: 12),
            const SizedBox(height: 8),
            _SBox(width: double.infinity, height: 52, radius: 10),
            const SizedBox(height: 20),
          ],

          // Entry card skeleton
          Container(
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Card header
              Container(height: 48,
                  decoration: const BoxDecoration(color: Color(0xFFF5F7F9),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)))),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Item dropdown placeholder
                  if (!isPreSelected) ...[
                    _SBox(width: 100, height: 12),
                    const SizedBox(height: 8),
                    _SBox(width: double.infinity, height: 52, radius: 10),
                    const SizedBox(height: 14),
                  ],

                  // Stock badge placeholder
                  _SBox(width: double.infinity, height: 44, radius: 10),
                  const SizedBox(height: 14),

                  // Unit type
                  _SBox(width: 70, height: 12),
                  const SizedBox(height: 8),
                  _SBox(width: double.infinity, height: 52, radius: 10),
                  const SizedBox(height: 14),

                  // Category
                  _SBox(width: 70, height: 12),
                  const SizedBox(height: 8),
                  _SBox(width: double.infinity, height: 52, radius: 10),
                  const SizedBox(height: 14),

                  // Quantity input
                  _SBox(width: 140, height: 12),
                  const SizedBox(height: 8),
                  _SBox(width: double.infinity, height: 52, radius: 10),
                  const SizedBox(height: 14),

                  // Description input
                  _SBox(width: 130, height: 12),
                  const SizedBox(height: 8),
                  _SBox(width: double.infinity, height: 90, radius: 10),
                ]),
              ),
            ]),
          ),

          const SizedBox(height: 24),
          // Submit button placeholder
          _SBox(width: double.infinity, height: 55, radius: 14),
          const SizedBox(height: 15),
          // Cancel placeholder
          Center(child: _SBox(width: 60, height: 14, radius: 6)),
          const SizedBox(height: 20),
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
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(radius)));
}
