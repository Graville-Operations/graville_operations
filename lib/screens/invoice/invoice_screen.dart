import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/services/api_service.dart';
import 'package:graville_operations/screens/invoice/widgets/invoice_photo_picker.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _formKey = GlobalKey<FormState>();

  // Supplier & Reference Details
  final _supplierNameController = TextEditingController();
  final _lpoNumberController = TextEditingController();
  final _invoiceNumberController = TextEditingController();
  final _deliveryNumberController = TextEditingController();

  // Invoice Items
  final List<Map<String, dynamic>> _invoiceItems = [];

  // Total & Attachment
  final _totalAmountController = TextEditingController();
  File? _attachmentImage;
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  // User info
  String _userName = '';
  String _userSite = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _supplierNameController.dispose();
    _lpoNumberController.dispose();
    _invoiceNumberController.dispose();
    _deliveryNumberController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  // ─── Data Methods 

  void _loadUserInfo() async {
    final userId = await ApiService.getUserId();
    if (userId != null) {
      final result = await ApiService.getRefactorMe();
      if (result['success']) {
        final data = result['data'];
        setState(() {
          _userName =
              '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}'.trim();
          final fieldOperator = data['field_operator'];
          if (fieldOperator != null && fieldOperator['site'] != null) {
            _userSite = fieldOperator['site']['name'] ?? 'Not Assigned';
          } else {
            _userSite = 'Not Assigned';
          }
        });
      }
    }
  }

  void _addInvoiceItem() {
    showDialog(
      context: context,
      builder: (_) => _AddItemDialog(
        onAdd: (item) {
          setState(() => _invoiceItems.add(item));
          _recalculateTotal();
        },
      ),
    );
  }

  void _editInvoiceItem(int index) {
    showDialog(
      context: context,
      builder: (_) => _AddItemDialog(
        existingItem: _invoiceItems[index],
        onAdd: (item) {
          setState(() => _invoiceItems[index] = item);
          _recalculateTotal();
        },
      ),
    );
  }

  void _removeInvoiceItem(int index) {
    setState(() => _invoiceItems.removeAt(index));
    _recalculateTotal();
  }

  void _recalculateTotal() {
    double total = 0;
    for (final item in _invoiceItems) {
      total += (item['total_price'] as double? ?? 0);
    }
    setState(() {
      _totalAmountController.text = total.toStringAsFixed(2);
    });
  }

  Future<void> _takeAttachment() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _attachmentImage = File(picked.path));
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColor.primaryBackground,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submitInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    if (_invoiceItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one invoice item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the invoice date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.primaryBackground.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColor.primaryBackground,
                size: 52,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Invoice Submitted!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Invoice #${_invoiceNumberController.text} has been sent to admin and finance for approval.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColor.secondaryText,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Done',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Private Builder Methods 

  Widget _buildOperatorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primaryBackground.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColor.primaryBackground.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.primaryBackground.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.engineering,
                color: AppColor.primaryBackground, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName.isNotEmpty ? _userName : 'Loading...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColor.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 13, color: AppColor.primaryBackground),
                    const SizedBox(width: 4),
                    Text(
                      _userSite.isNotEmpty ? _userSite : 'Loading site...',
                      style: const TextStyle(
                          color: AppColor.secondaryText, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today,
                color: AppColor.primaryBackground, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? 'Date'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                style: TextStyle(
                  color: _selectedDate == null
                      ? AppColor.secondaryText
                      : AppColor.primaryText,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItemsSection() {
    return Column(
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _SectionLabel(label: 'Invoice Items'),
            GestureDetector(
              onTap: _addInvoiceItem,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.primaryBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Add Item',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Empty state or items list
        if (_invoiceItems.isEmpty)
          _buildEmptyItemsPlaceholder()
        else
          _buildItemsTable(),
      ],
    );
  }

  Widget _buildEmptyItemsPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.add_box_outlined,
              size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            'No items added yet',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "Add Item" to add invoice items',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.primaryBackground.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Particulars',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColor.primaryBackground))),
                Expanded(
                    flex: 1,
                    child: Text('Qty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColor.primaryBackground))),
                Expanded(
                    flex: 2,
                    child: Text('Unit Price',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColor.primaryBackground))),
                Expanded(
                    flex: 2,
                    child: Text('Total',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColor.primaryBackground))),
                SizedBox(width: 32),
              ],
            ),
          ),
          // Table rows
          ...List.generate(_invoiceItems.length, (index) {
            final item = _invoiceItems[index];
            return Column(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          item['particular'] ?? '',
                          style: const TextStyle(
                              fontSize: 13, color: AppColor.primaryText),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${item['quantity']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'KES ${(item['unit_price'] as double).toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'KES ${(item['total_price'] as double).toStringAsFixed(0)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBackground,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert,
                            size: 18, color: AppColor.secondaryText),
                        onSelected: (v) {
                          if (v == 'edit') {
                            _editInvoiceItem(index);
                          } else {
                            _removeInvoiceItem(index);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                              value: 'edit',
                              child: Row(children: [
                                Icon(Icons.edit, size: 16),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ])),
                          const PopupMenuItem(
                              value: 'delete',
                              child: Row(children: [
                                Icon(Icons.delete,
                                    size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Remove',
                                    style: TextStyle(color: Colors.red)),
                              ])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryBackground.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColor.primaryBackground.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.payments,
              color: AppColor.primaryBackground, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Amount (KES)',
                  style: TextStyle(
                    color: AppColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _totalAmountController.text.isEmpty
                      ? '0.00'
                      : _totalAmountController.text,
                  style: const TextStyle(
                    color: AppColor.primaryBackground,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.primaryBackground.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Auto',
              style: TextStyle(
                color: AppColor.primaryBackground,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitInvoice,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryBackground,
          disabledBackgroundColor:
              AppColor.primaryBackground.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Submit for Approval',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ─── Build 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Submit Invoice'),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ─── Operator Info
              _buildOperatorInfo(),
              const SizedBox(height: 24),

              // ─── Supplier & Reference Details
              const _SectionLabel(label: 'Supplier & Reference Details'),
              const SizedBox(height: 12),

              _FormField(
                controller: _supplierNameController,
                label: 'Supplier Name',
                hint: 'e.g. Bamburi Cement Ltd',
                icon: Icons.business,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Supplier name is required' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _FormField(
                      controller: _lpoNumberController,
                      label: 'L.P.O No.',
                      hint: 'e.g. LPO-2026-001',
                      icon: Icons.assignment,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FormField(
                      controller: _invoiceNumberController,
                      label: 'Invoice No.',
                      hint: 'e.g. INV-2026-001',
                      icon: Icons.receipt_long,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FormField(
                      controller: _deliveryNumberController,
                      label: 'Delivery No.',
                      hint: 'e.g. DN-2026-001',
                      icon: Icons.local_shipping,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDatePicker()),
                ],
              ),
              const SizedBox(height: 24),

              // ─── Invoice Items
              _buildInvoiceItemsSection(),
              const SizedBox(height: 24),

              // ─── Total Invoice Amount
              const _SectionLabel(label: 'Total Invoice Amount'),
              const SizedBox(height: 12),
              _buildTotalAmount(),
              const SizedBox(height: 24),

              // ─── Attachments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel(label: 'Attachments'),
                  Text(
                    'Optional',
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Attach delivery note, receipt or any supporting document',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 12),

              InvoicePhotoPicker(
                image: _attachmentImage,
                onTap: _takeAttachment,
              ),
              const SizedBox(height: 32),

              // ─── Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primaryBackground.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColor.primaryBackground.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColor.primaryBackground, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This invoice will be sent to the admin and finance team for review and approval.',
                        style: TextStyle(
                            color: AppColor.primaryBackground, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add Item Dialog 

class _AddItemDialog extends StatefulWidget {
  final Map<String, dynamic>? existingItem;
  final Function(Map<String, dynamic>) onAdd;

  const _AddItemDialog({this.existingItem, required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _particularController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _particularController.text = widget.existingItem!['particular'] ?? '';
      _quantityController.text = '${widget.existingItem!['quantity'] ?? ''}';
      _unitPriceController.text =
          '${widget.existingItem!['unit_price'] ?? ''}';
      _totalPrice = widget.existingItem!['total_price'] ?? 0;
    }
    _quantityController.addListener(_calculate);
    _unitPriceController.addListener(_calculate);
  }

  @override
  void dispose() {
    _particularController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _calculate() {
    final qty = double.tryParse(_quantityController.text) ?? 0;
    final price = double.tryParse(_unitPriceController.text) ?? 0;
    setState(() => _totalPrice = qty * price);
  }

  /// Shared decoration for dialog text fields.
  InputDecoration _dialogFieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon:
          Icon(icon, color: AppColor.primaryBackground, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColor.primaryBackground, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingItem == null ? 'Add Item' : 'Edit Item',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _particularController,
                decoration: _dialogFieldDecoration(
                  label: 'Particulars',
                  hint: 'e.g. Ballast, Cement, Steel Rods',
                  icon: Icons.category,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: _dialogFieldDecoration(
                        label: 'Quantity',
                        hint: '0',
                        icon: Icons.numbers,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitPriceController,
                      keyboardType: TextInputType.number,
                      decoration: _dialogFieldDecoration(
                        label: 'Unit Price',
                        hint: '0.00',
                        icon: Icons.payments,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColor.primaryBackground.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColor.primaryBackground.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calculate,
                            color: AppColor.primaryBackground, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Total Price',
                          style: TextStyle(
                            color: AppColor.primaryBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'KES ${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColor.primaryBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onAdd({
                        'particular': _particularController.text.trim(),
                        'quantity': double.parse(_quantityController.text),
                        'unit_price':
                            double.parse(_unitPriceController.text),
                        'total_price': _totalPrice,
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.existingItem == null ? 'Add Item' : 'Update Item',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Label 

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColor.primaryBackground,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColor.primaryText,
          ),
        ),
      ],
    );
  }
}

// ─── Form Field

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: AppColor.secondaryText),
          labelStyle: const TextStyle(color: AppColor.secondaryText),
          prefixIcon:
              Icon(icon, color: AppColor.primaryBackground, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: validator,
      ),
    );
  }
}