import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graville_operations/core/style/color.dart';
//import 'package:graville_operations/screens/commons/widgets/custom_button.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  File? _invoiceImage;
  DateTime? _selectedDate;
  String? _selectedSite;
  bool _isSubmitting = false;

  final List<String> _sites = [
    'Mabatini',
    'Mishi Mboko', 
    'Huruma',
    'DCC Kibra',
    'Ngei',
    'Iremele',
  ];

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _invoiceImage = File(picked.path));
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primaryBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitInvoice() async {
    if (!_formKey.currentState!.validate()) return;

    if (_invoiceImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please take a photo of the invoice'),
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

    if (_selectedSite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a site'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate submission — replace with real API call later
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    // Show success dialog
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

              // Invoice Photo Section
              const _SectionLabel(label: 'Invoice Photo'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _invoiceImage == null
                          ? AppColor.borderColor
                          : AppColor.primaryBackground,
                      width: _invoiceImage == null ? 1.5 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _invoiceImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColor.primaryBackground
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 36,
                                color: AppColor.primaryBackground,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Tap to take a photo',
                              style: TextStyle(
                                color: AppColor.primaryBackground,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Take a clear photo of the invoice',
                              style: TextStyle(
                                color: AppColor.secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _invoiceImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColor.primaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Invoice Details Section
              const _SectionLabel(label: 'Invoice Details'),
              const SizedBox(height: 12),

              // Invoice Number
              _FormField(
                controller: _invoiceNumberController,
                label: 'Invoice Number',
                hint: 'e.g. INV-2026-001',
                icon: Icons.receipt_long,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Invoice number is required' : null,
              ),
              const SizedBox(height: 12),

              // Date Picker
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
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
                      const Icon(
                        Icons.calendar_today,
                        color: AppColor.primaryBackground,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Select Invoice Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? AppColor.secondaryText
                              : AppColor.primaryText,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColor.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Amount
              _FormField(
                controller: _amountController,
                label: 'Amount (KES)',
                hint: 'e.g. 45000',
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  if (double.tryParse(v) == null) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Site Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSite,
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColor.primaryBackground,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Select Site',
                          style: TextStyle(
                            color: AppColor.secondaryText,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    items: _sites
                        .map((site) => DropdownMenuItem(
                              value: site,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColor.primaryBackground,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(site),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSite = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Container(
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
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe what this invoice is for...',
                    hintStyle: TextStyle(color: AppColor.secondaryText),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(
                        Icons.description,
                        color: AppColor.primaryBackground,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Description is required' : null,
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
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
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
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
              ),

              const SizedBox(height: 16),

              // Info note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColor.primaryBackground.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor.primaryBackground.withOpacity(0.2),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColor.primaryBackground,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This invoice will be sent to the admin and finance team for review and approval.',
                        style: TextStyle(
                          color: AppColor.primaryBackground,
                          fontSize: 12,
                        ),
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
          prefixIcon: Icon(icon, color: AppColor.primaryBackground, size: 20),
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