import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:graville_operations/models/inventory/inventory _model.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
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
  const UpdateInventoryScreen({super.key, InventoryModel? preSelectedItem});

  @override
  UpdateInventoryScreenState createState() => UpdateInventoryScreenState();
}

class UpdateInventoryScreenState extends State<UpdateInventoryScreen> {
  final List<String> allSites = [
    'PLAZA 2000',
    'Kimnojun',
    'DCC Kibra',
    'Huruma',
  ];
  String? selectedSite;

  List<InventoryModel> _inventoryItems = [];
  bool _isLoadingItems = true;
  bool _isSubmitting = false;
  String? _loadError;

  // List of entries  starts with one
  final List<_InventoryEntry> _entries = [_InventoryEntry()];

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _loadInventoryItems() async {
    setState(() {
      _isLoadingItems = true;
      _loadError = null;
    });
    try {
      final List<InventoryModel> items =
          await MaterialService.getAllInventory();
      setState(() {
        _inventoryItems = items;
        _isLoadingItems = false;
      });
    } on MaterialServiceException catch (e) {
      setState(() {
        _loadError = e.message;
        _isLoadingItems = false;
      });
    } catch (_) {
      setState(() {
        _loadError = 'Failed to load inventory items.';
        _isLoadingItems = false;
      });
    }
  }

  void _addEntry() {
    setState(() => _entries.add(_InventoryEntry()));
  }

  void _removeEntry(int index) {
    setState(() {
      _entries[index].dispose();
      _entries.removeAt(index);
    });
  }

  bool get _isFormValid =>
      selectedSite != null && _entries.every((e) => e.isValid);

  Future<void> _submit() async {
    if (!_isFormValid) return;

    // Validate quantities
    for (final entry in _entries) {
      final enteredQty =
          int.tryParse(entry.quantityController.text.trim()) ?? 0;
      if (enteredQty <= 0) {
        _showError(
            'Enter a valid quantity greater than 0 for ${entry.selectedInventory!.name}.');
        return;
      }
      if (enteredQty > entry.selectedInventory!.quantity) {
        _showError(
            'Cannot subtract $enteredQty from ${entry.selectedInventory!.name}. Current stock is ${entry.selectedInventory!.quantity}.');
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      // Submit all entries
      for (final entry in _entries) {
        final updated = InventoryModel(
          name: entry.selectedInventory!.name,
          quantity: int.parse(entry.quantityController.text.trim()),
          category: entry.categoryController.text.trim().isNotEmpty
              ? entry.categoryController.text.trim()
              : entry.selectedInventory!.category,
          unit: entry.unitController.text.trim().isNotEmpty
              ? entry.unitController.text.trim()
              : entry.selectedInventory!.unit,
          unitPrice: entry.selectedInventory!.unitPrice,
          description: entry.descriptionController.text.trim(),
          operation: 'subtract',
        );
        await MaterialService.updateInventory(
            entry.selectedInventory!.id!, updated);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_entries.length} item(s) updated successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } on MaterialServiceException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      debugPrint('Submit error: $e');
      if (e is DioException) {
        debugPrint('Backend says: ${e.response?.data}');
      }
      if (!mounted) return;
      _showError('An unexpected error occurred. Please try again.');
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Update Inventory',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoadingItems
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _loadError!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _loadInventoryItems,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Construction Site (once at top) ──
                      const Text('Construction Site *',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      CustomDropdown<String>(
                        value: selectedSite,
                        items: allSites,
                        displayMapper: (site) => site,
                        onChanged: (val) => setState(() => selectedSite = val),
                        hint: 'Select site',
                        isExpanded: true,
                        isDense: true,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),

                      const SizedBox(height: 20),

                      // ── Dynamic entries ──
                      ..._entries.asMap().entries.map((mapEntry) {
                        final index = mapEntry.key;
                        final entry = mapEntry.value;
                        return _buildEntryCard(index, entry);
                      }),

                      const SizedBox(height: 12),

                      // ── Add Another Item button ──
                      OutlinedButton.icon(
                        onPressed: _addEntry,
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: const Text(
                          ' Add Another Item',
                          style: TextStyle(color: Colors.blue),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Submit ──
                      Center(
                        child: CustomButton(
                          label: _entries.length > 1
                              ? 'Subtract ${_entries.length} Items'
                              : 'Subtract Stock',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          height: 55,
                          borderRadius: 14,
                          isLoading: _isSubmitting,
                          onPressed:
                              _isFormValid && !_isSubmitting ? _submit : null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: GestureDetector(
                          onTap: _isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }

  Widget _buildEntryCard(int index, _InventoryEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              if (_entries.length > 1)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeEntry(index),
                  tooltip: 'Remove item',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          const SizedBox(height: 10),

          const Text('Inventory Item *',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          CustomDropdown<InventoryModel>(
            value: entry.selectedInventory,
            items: _inventoryItems,
            displayMapper: (item) => item.name,
            onChanged: (item) {
              if (item != null) {
                setState(() => entry.fillFrom(item));
              }
            },
            hint: 'Select inventory item',
            isExpanded: true,
            isDense: true,
            border: InputBorder.none,
            fillColor: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),

          if (entry.selectedInventory != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                'Current stock: ${entry.selectedInventory!.quantity} ${entry.selectedInventory!.unit}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),
          const Text('Unit type',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
              controller: entry.unitController,
              readOnly: true,
              decoration: _inputDecoration()),

          const SizedBox(height: 14),

          // Category
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
              controller: entry.categoryController,
              readOnly: true,
              decoration: _inputDecoration()),

          const SizedBox(height: 14),

          // Quantity
          const Text('Quantity to Subtract *',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: entry.quantityController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration:
                _inputDecoration(hintText: 'Enter quantity to subtract'),
          ),

          const SizedBox(height: 14),

          // Description
          const Text('Description (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: entry.descriptionController,
            maxLines: 2,
            decoration:
                _inputDecoration(hintText: 'e.g., Used on Block A foundation'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
