import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/core/commons/widgets/custom_bottom_sheet.dart';
import 'package:graville_operations/models/material/inventory_item.dart';
import 'package:graville_operations/services/receive_material_service.dart';

class _InventorySheetItem implements BottomSheetItem {
  final InventoryItem item;
  const _InventorySheetItem(this.item);

  @override
  String get displayTitle => item.name;

  @override
  String? get displaySubtitle => item.unit;

  @override
  Widget? get leadingWidget => null;
}

final _dummyInventory = [
  InventoryItem(id: '1', name: 'Portland Cement',    category: 'Structure and Foundation',   unit: 'Bags'),
  InventoryItem(id: '2', name: 'Steel Rods (12mm)',  category: 'Structure and Foundation',   unit: 'pieces'),
  InventoryItem(id: '3', name: 'River Sand',         category: 'Structure and Foundation',   unit: 'm³'),
  InventoryItem(id: '4', name: 'Concrete Blocks',    category: 'Wall Assembly and Openings', unit: 'pieces'),
  InventoryItem(id: '5', name: 'Roofing Sheets',     category: 'Roof Finish',                unit: 'sheets'),
  InventoryItem(id: '6', name: 'PVC Pipes (50mm)',   category: 'Service Rough-In',           unit: 'meters'),
  InventoryItem(id: '7', name: 'Binding Wire',       category: 'Structure and Foundation',   unit: 'rolls'),
  InventoryItem(id: '8', name: 'Timber (2x4)',       category: 'Roof Finish',                unit: 'pieces'),
  InventoryItem(id: '9', name: 'Paint (White)',      category: 'Interior Build-Out',         unit: 'liters'),
  InventoryItem(id: '10',name: 'Ceramic Tiles',      category: 'Interior Build-Out',         unit: 'm²'),
];

class ReceiveMaterialScreen extends StatefulWidget {
  const ReceiveMaterialScreen({super.key});

  @override
  State<ReceiveMaterialScreen> createState() => _ReceiveMaterialScreenState();
}

class _ReceiveMaterialScreenState extends State<ReceiveMaterialScreen> {
  final _quantityController = TextEditingController();
  final _amountController   = TextEditingController();
  final _supplierController = TextEditingController();
  final _notesController    = TextEditingController();

  InventoryItem? _selectedItem;
  File?          _imageFile;
  bool           _submitting = false;

  bool get _isValid {
    if (_selectedItem == null) return false;
    if (_quantityController.text.trim().isEmpty) return false;
    if (int.tryParse(_quantityController.text.trim()) == null) return false;
    if (_supplierController.text.trim().isEmpty) return false;
    if (_amountController.text.trim().isEmpty) return false;
    if (double.tryParse(_amountController.text.trim()) == null) return false;
    return true;
  }

  Future<void> _openMaterialSheet() async {
    final sheetItems =
        _dummyInventory.map((i) => _InventorySheetItem(i)).toList();

    final selected = await CustomBottomSheet.show<_InventorySheetItem>(
      context: context,
      title: 'Select Material',
      items: sheetItems,
      mode: BottomSheetDisplayMode.list,
      accentColor: Colors.blue,
      searchHint: 'Search materials…',
    );

    if (selected != null && mounted) {
      setState(() => _selectedItem = selected.item);
    }
  }

  Future<void> _submit() async {
    if (!_isValid) {
      _snack('Please fill all required fields.', isError: true);
      return;
    }
    setState(() => _submitting = true);

    final result = await ReceiveMaterialService.receiveFromSupplier(
      materialId:   int.parse(_selectedItem!.id),
      quantity:     int.parse(_quantityController.text.trim()),
      amountPaid:   double.parse(_amountController.text.trim()),
      supplierName: _supplierController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      photo: _imageFile,
    );

    setState(() => _submitting = false);

    if (result['success'] == true) {
      _snack('Material received successfully!');
      if (mounted) Navigator.pop(context, true);
    } else {
      _snack(result['message'] ?? 'Something went wrong.', isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _amountController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            title: Row(
              children: const [
                Icon(Icons.inventory, color: Colors.blue, size: 22),
                SizedBox(width: 8),
                Text('Receive Material',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                MaterialPhotoSection(
                  title: 'Material Photo',
                  onImagePicked: (f) => setState(() => _imageFile = f),
                ),

                const SizedBox(height: 4),

                FormSection(
                  title: 'Material',
                  icon: Icons.inventory_2_outlined,
                  required: true,
                  child: GestureDetector(
                    onTap: _openMaterialSheet,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _selectedItem == null
                                ? Text(
                                    'Select material',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400),
                                  )
                                : Text(
                                    _selectedItem!.name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  ),
                ),
                FormSection(
                  title: 'Quantity Received',
                  icon: Icons.numbers,
                  required: true,
                  child: CustomTextInput(
                    controller: _quantityController,
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                FormSection(
                  title: 'Supplier Name',
                  icon: Icons.person_outline,
                  required: true,
                  child: CustomTextInput(
                    controller: _supplierController,
                    hintText: 'Enter supplier name',
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                FormSection(
                  title: 'Amount Paid (KES)',
                  icon: Icons.account_balance_outlined,
                  required: true,
                  child: CustomTextInput(
                    controller: _amountController,
                    hintText: '0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                FormSection(
                  title: 'Notes / Remarks',
                  icon: Icons.comment_outlined,
                  required: false,
                  child: CustomTextInput(
                    controller: _notesController,
                    hintText: 'Add any additional notes…',
                    maxLines: 4,
                  ),
                ),

                const SizedBox(height: 8),

                CustomButton(
                label: _submitting ? 'Confirming…' : 'Confirm Receipt',
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                backgroundColor: _submitting ? Colors.grey.shade400 : Colors.blue,
                textColor: Colors.white,
                borderRadius: 16,
                height: 55,
                isLoading: _submitting,
                onPressed: _submitting ? null : _submit,
              ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
