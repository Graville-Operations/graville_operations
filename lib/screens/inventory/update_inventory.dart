import 'package:flutter/material.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/services/inventory_service.dart';

enum InventoryOperation { add, subtract }

class UpdateInventoryScreen extends StatefulWidget {
  const UpdateInventoryScreen({super.key});

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
  InventoryModel? _selectedInventory;
  bool _isLoadingItems = true;
  bool _isSubmitting = false;
  String? _loadError;

  InventoryOperation _operation = InventoryOperation.subtract;

  final TextEditingController unitController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInventoryItems();
  }

  @override
  void dispose() {
    unitController.dispose();
    categoryController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadInventoryItems() async {
    setState(() {
      _isLoadingItems = true;
      _loadError = null;
    });
    try {
      final List<InventoryModel> items = await MaterialService.getAllInventory();
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

  void _onInventorySelected(InventoryModel? item) {
    setState(() {
      _selectedInventory = item;
      unitController.text = item?.unitType ?? '';
      categoryController.text = item?.category ?? '';
      quantityController.text = '';
      unitPriceController.text = item != null ? item.unitPrice.toString() : '';
      descriptionController.text = item?.description ?? '';
    });
  }

  bool get _isFormValid =>
      _selectedInventory != null && quantityController.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_isFormValid) return;

    final enteredQty = int.tryParse(quantityController.text.trim()) ?? 0;

    if (_operation == InventoryOperation.subtract &&
        enteredQty > _selectedInventory!.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot subtract $enteredQty. Current stock is ${_selectedInventory!.quantity}.',
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final updated = InventoryModel(
      name: _selectedInventory!.name,
      quantity: enteredQty,
      category: categoryController.text.trim().isNotEmpty
          ? categoryController.text.trim()
          : _selectedInventory!.category,
      unitType: unitController.text.trim().isNotEmpty
          ? unitController.text.trim()
          : _selectedInventory!.unitType,
      unitPrice: double.tryParse(unitPriceController.text.trim()) ??
          _selectedInventory!.unitPrice,
      description: descriptionController.text.trim(),
      operation: _operation == InventoryOperation.subtract ? 'subtract' : 'add',
    );

    try {
      await MaterialService.updateInventory(_selectedInventory!.id!, updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedInventory!.name} updated successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } on MaterialServiceException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred. Please try again.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                      Text(_loadError!,
                          style: TextStyle(color: Colors.red.shade600)),
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

                      const Text(
                        'Construction Site *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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

                      const Text(
                        'Inventory Item *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      CustomDropdown<InventoryModel>(
                        value: _selectedInventory,
                        items: _inventoryItems,
                        displayMapper: (item) => item.name,
                        onChanged: _onInventorySelected,
                        hint: 'Select inventory item',
                        isExpanded: true,
                        isDense: true,
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),

                      if (_selectedInventory != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Text(
                            'Current stock: ${_selectedInventory!.quantity} ${_selectedInventory!.unitType}',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                    
                      const Text(
                        'Operation *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // Add option
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _operation = InventoryOperation.subtract),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _operation == InventoryOperation.subtract
                                        ? Colors.red
                                        : Colors.white,
                                    borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(14)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.remove_circle_outline,
                                        size: 18,
                                        color: _operation ==
                                                InventoryOperation.subtract
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Subtract Stock',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _operation ==
                                                  InventoryOperation.subtract
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() =>
                                    _operation = InventoryOperation.add),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _operation ==
                                            InventoryOperation.add
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(14)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        size: 18,
                                        color: _operation ==
                                                InventoryOperation.add
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Add Stock',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _operation ==
                                                  InventoryOperation.add
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Unit type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: unitController,
                        readOnly: true,
                        decoration: _inputDecoration(),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Category',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: categoryController,
                        readOnly: true,
                        decoration: _inputDecoration(),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        _operation == InventoryOperation.subtract
                            ? 'Quantity to Subtract *'
                            : 'Quantity to Add *',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: _inputDecoration(
                          hintText: _operation == InventoryOperation.subtract
                              ? 'Enter quantity to subtract'
                              : 'Enter quantity to add',
                        ),
                      ),

                      // const SizedBox(height: 20),

                      // const Text(
                      //   'Unit price (Optional)',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      // const SizedBox(height: 6),
                      // TextField(
                      //   controller: unitPriceController,
                      //   keyboardType: TextInputType.number,
                      //   decoration: _inputDecoration(hintText: 'Enter price'),
                      // ),

                      const SizedBox(height: 20),

                      const Text(
                        'Description (Optional)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: descriptionController,
                        maxLines: 2,
                        decoration: _inputDecoration(
                          hintText: 'e.g., Delivered by XYZ supplier',
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: _operation == InventoryOperation.add
                                  ? 'Add Stock'
                                  : 'Subtract Stock',
                              backgroundColor:
                                  _operation == InventoryOperation.add
                                      ? Colors.green
                                      : Colors.red,
                              textColor: Colors.white,
                              height: 55,
                              borderRadius: 14,
                              isLoading: _isSubmitting,
                              onPressed: _isFormValid && !_isSubmitting
                                  ? _submit
                                  : null,
                            ),
                          ),
                        ],
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

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}