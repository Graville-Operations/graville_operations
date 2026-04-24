import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/destination_info.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/core/commons/widgets/sections/material_info_section.dart';
import 'package:graville_operations/core/commons/widgets/sections/transport_info.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/transport_mode.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class TransferMaterialScreen extends StatefulWidget {
  const TransferMaterialScreen({super.key});

  @override
  State<TransferMaterialScreen> createState() => _TransferMaterialScreenState();
}

class _TransferMaterialScreenState extends State<TransferMaterialScreen> {
  final _quantityController = TextEditingController();
  final _priceController    = TextEditingController();
  final _driverController   = TextEditingController();
  final _notesController    = TextEditingController();

  AppMaterial?     _selectedMaterial;
  DestinationSite? _selectedDestination;
  TransportMode?   _selectedMode;
  File?            _imageFile;

  bool _submitting = false;

  bool get _isOthersMode => _selectedMode?.name == 'Others';

  bool get _othersTextMissing =>
      _isOthersMode &&
      (_selectedMode?.category == 'Other') &&
      (_selectedMode?.id == '0' || _selectedMode?.name == 'Others');

  int? get _transportModeId {
    if (_selectedMode == null) return null;
    final parsed = int.tryParse(_selectedMode!.id);
    if (parsed == null || parsed == 0) return null;
    return parsed;
  }

  String? get _resolvedNotes {
    final base = _notesController.text.trim();
    if (_isOthersMode && _selectedMode!.name != 'Others') {
      final transport = 'Transport: ${_selectedMode!.name}';
      return base.isEmpty ? transport : '$transport\n$base';
    }
    return base.isEmpty ? null : base;
  }

  bool get _isValid {
    if (_selectedMaterial == null) return false;
    if (_selectedDestination == null) return false;
    if (_quantityController.text.trim().isEmpty) return false;
    if (double.tryParse(_quantityController.text.trim()) == null) return false;
    if (_priceController.text.trim().isNotEmpty &&
        double.tryParse(_priceController.text.trim()) == null) return false;
    // If Others selected, require them to have typed something
    if (_isOthersMode && _selectedMode!.name == 'Others') return false;
    return true;
  }

  Future<void> _submit() async {
    if (!_isValid) {
      _showSnack('Please fill all required fields correctly.', isError: true);
      return;
    }

    setState(() => _submitting = true);

    final result = await TransferMaterialService.submitTransfer(
      materialId:      int.parse(_selectedMaterial!.id),
      toSiteId:        int.parse(_selectedDestination!.id),
      quantity:        double.parse(_quantityController.text.trim()),
      pricePerUnit:    _priceController.text.trim().isEmpty
                           ? 0.0
                           : double.parse(_priceController.text.trim()),
      transportModeId: _transportModeId,   // ← null-safe, 0 becomes null
      driverDetails:   _driverController.text.trim().isEmpty
                           ? null
                           : _driverController.text.trim(),
      notes:           _resolvedNotes,     // ← includes Others custom name
      imageFile:       _imageFile,
    );

    setState(() => _submitting = false);

    if (result['success'] == true) {
      _showSnack('Transfer confirmed successfully!');
      if (mounted) Navigator.pop(context, true);
    } else {
      _showSnack(result['message'] ?? 'Transfer failed. Try again.',
          isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _driverController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            title: Row(
              children: const [
                Icon(Icons.local_shipping, color: Colors.blue, size: 22),
                SizedBox(width: 8),
                Text(
                  'Transfer Material',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Photo
                MaterialPhotoSection(
                  onImagePicked: (file) =>
                      setState(() => _imageFile = file),
                ),

                MaterialInfoSection(
                  selectedMaterial: _selectedMaterial,
                  onChanged: (material) =>
                      setState(() => _selectedMaterial = material),
                ),

                FormSection(
                  title: 'Quantity',
                  icon: Icons.numbers,
                  required: true,
                  child: CustomTextInput(
                    controller: _quantityController,
                    hintText: 'Enter Quantity',
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                FormSection(
                  title: 'Price per unit',
                  icon: Icons.numbers,
                  required: false,
                  child: CustomTextInput(
                    controller: _priceController,
                    hintText: '0',
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                DestinationInfo(
                  selectedDestination: _selectedDestination,
                  onChanged: (destination) =>
                      setState(() => _selectedDestination = destination),
                ),

                TransportInfo(
                  selectedMode: _selectedMode,
                  onChanged: (mode) =>
                      setState(() => _selectedMode = mode),
                ),

                FormSection(
                  title: "Driver's Name/Transport Details",
                  required: false,
                  child: CustomTextInput(
                    controller: _driverController,
                    hintText: "Enter Driver's name or transport details",
                  ),
                ),
                FormSection(
                  title: 'Notes',
                  icon: Icons.comment,
                  required: false,
                  child: CustomTextInput(
                    controller: _notesController,
                    hintText: 'Add any additional notes or remarks...',
                    maxLines: 5,
                  ),
                ),

                const SizedBox(height: 15),

                CustomButton(
                  label: _submitting ? 'Submitting...' : 'Confirm Transfer',
                  backgroundColor: _isValid && !_submitting
                      ? Colors.orange
                      : Colors.grey.shade400,
                  textColor: Colors.white,
                  borderRadius: 16,
                  height: 55,
                  onPressed: _isValid && !_submitting ? _submit : null,
                ),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}