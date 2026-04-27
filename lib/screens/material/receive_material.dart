import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/inventory_item.dart';
import 'package:graville_operations/services/receive_material_service.dart';

enum ReceiveSourceType { supplier, site }

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

  List<InventoryItem>   _inventory = [];
  List<DestinationSite> _sites     = [];
  bool    _dataLoading = true;
  String? _dataError;

  InventoryItem?       _selectedItem;
  DestinationSite?     _selectedFromSite;
  ReceiveSourceType    _sourceType = ReceiveSourceType.supplier;
  File?                _imageFile;
  bool                 _submitting = false;

  @override
  void initState() {
    super.initState();
    _prefetch();
  }

  Future<void> _prefetch() async {
    setState(() { _dataLoading = true; _dataError = null; });
    try {
      final results = await Future.wait([
        ReceiveMaterialService.fetchInventory(),
        ReceiveMaterialService.fetchSites(),
      ]);
      if (mounted) {
        setState(() {
          _inventory   = results[0] as List<InventoryItem>;
          _sites       = results[1] as List<DestinationSite>;
          _dataLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _dataError   = 'Failed to load data. Tap to retry.';
          _dataLoading = false;
        });
      }
    }
  }
  bool get _isValid {
    if (_selectedItem == null) return false;
    if (_quantityController.text.trim().isEmpty) return false;
    if (int.tryParse(_quantityController.text.trim()) == null) return false;
    if (_sourceType == ReceiveSourceType.supplier) {
      if (_supplierController.text.trim().isEmpty) return false;
      if (_amountController.text.trim().isEmpty) return false;
      if (double.tryParse(_amountController.text.trim()) == null) return false;
    } else {
      if (_selectedFromSite == null) return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_isValid) {
      _snack('Please fill all required fields.', isError: true);
      return;
    }
    setState(() => _submitting = true);

    Map<String, dynamic> result;

    if (_sourceType == ReceiveSourceType.supplier) {
      result = await ReceiveMaterialService.receiveFromSupplier(
        inventoryId:  int.parse(_selectedItem!.id),
        quantity:     int.parse(_quantityController.text.trim()),
        amountPaid:   double.parse(_amountController.text.trim()),
        supplierName: _supplierController.text.trim(),
        notes:        _notesController.text.trim().isEmpty
                          ? null : _notesController.text.trim(),
        photo:        _imageFile,
      );
    } else {
      result = await ReceiveMaterialService.receiveFromSite(
        inventoryId: int.parse(_selectedItem!.id),
        quantity:    int.parse(_quantityController.text.trim()),
        fromSiteId:  int.parse(_selectedFromSite!.id),
        amountPaid:  _amountController.text.trim().isEmpty
                         ? 0.0
                         : double.parse(_amountController.text.trim()),
        notes:       _notesController.text.trim().isEmpty
                         ? null : _notesController.text.trim(),
        photo:       _imageFile,
      );
    }

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

  Widget _label(IconData icon, String text) => Row(children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
      ]);

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

                if (_dataLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )

                else if (_dataError != null)
                  GestureDetector(
                    onTap: _prefetch,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(children: [
                        Icon(Icons.refresh, color: Colors.red.shade400),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(_dataError!,
                              style: TextStyle(
                                  color: Colors.red.shade700)),
                        ),
                      ]),
                    ),
                  )

                else ...[

                  // Photo
                  MaterialPhotoSection(
                    title: 'Material Photo',
                    onImagePicked: (f) =>
                        setState(() => _imageFile = f),
                  ),

                  const SizedBox(height: 4),

                  FormSection(
                    title: 'Material',
                    icon: Icons.inventory_2_outlined,
                    required: true,
                    child: CustomDropdown<InventoryItem>(
                      hint: 'Select material',
                      value: _selectedItem,
                      items: _inventory,
                      displayMapper: (i) => i.name,
                      onChanged: (item) =>
                          setState(() => _selectedItem = item),
                    ),
                  ),

                  // Auto-fill: category + unit + current stock
                  if (_selectedItem != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(children: [
                        _InfoChip(
                            label: 'Category',
                            value: _selectedItem!.category),
                        const SizedBox(width: 12),
                        _InfoChip(
                            label: 'Unit',
                            value: _selectedItem!.unit),
                        const SizedBox(width: 12),
                        _InfoChip(
                            label: 'In Stock',
                            value: _selectedItem!.quantity
                                .toStringAsFixed(1)),
                      ]),
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

                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(Icons.swap_horiz_rounded, 'Source'),
                        const SizedBox(height: 10),
                        Row(children: [
                          _SourceToggle(
                            icon: Icons.storefront_outlined,
                            label: 'Supplier',
                            selected: _sourceType ==
                                ReceiveSourceType.supplier,
                            color: Colors.blue,
                            onTap: () => setState(() {
                              _sourceType =
                                  ReceiveSourceType.supplier;
                              _selectedFromSite = null;
                            }),
                          ),
                          const SizedBox(width: 12),
                          _SourceToggle(
                            icon: Icons.location_city_outlined,
                            label: 'Another Site',
                            selected: _sourceType ==
                                ReceiveSourceType.site,
                            color: Colors.orange,
                            onTap: () => setState(() {
                              _sourceType = ReceiveSourceType.site;
                              _supplierController.clear();
                              _amountController.clear();
                            }),
                          ),
                        ]),
                      ],
                    ),
                  ),

                  if (_sourceType == ReceiveSourceType.supplier) ...[
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
                            const TextInputType.numberWithOptions(
                                decimal: true),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],

                  if (_sourceType == ReceiveSourceType.site) ...[
                    FormSection(
                      title: 'From Site',
                      icon: Icons.location_on_outlined,
                      required: true,
                      child: CustomDropdown<DestinationSite>(
                        hint: 'Select source site',
                        value: _selectedFromSite,
                        items: _sites,
                        displayMapper: (s) => s.name,
                        onChanged: (s) =>
                            setState(() => _selectedFromSite = s),
                      ),
                    ),
                    FormSection(
                      title: 'Amount Paid (KES)',
                      icon: Icons.account_balance_outlined,
                      required: false,
                      child: CustomTextInput(
                        controller: _amountController,
                        hintText: '0.00 (optional for site transfers)',
                        keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],

                  FormSection(
                    title: 'Notes / Remarks',
                    icon: Icons.comment_outlined,
                    required: false,
                    child: CustomTextInput(
                      controller: _notesController,
                      hintText: 'Add any additional notes...',
                      maxLines: 4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  CustomButton(
                    label: _submitting
                        ? 'Confirming...'
                        : 'Confirm Receipt',
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 20),
                    backgroundColor: _isValid && !_submitting
                        ? Colors.blue
                        : Colors.grey.shade400,
                    textColor: Colors.white,
                    borderRadius: 16,
                    height: 55,
                    isLoading: _submitting,
                    onPressed:
                        _isValid && !_submitting ? _submit : null,
                  ),

                  const SizedBox(height: 32),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}


class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10, color: Colors.blue.shade400)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _SourceToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SourceToggle({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? color.withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 22,
                  color: selected ? color : Colors.grey),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? color : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}