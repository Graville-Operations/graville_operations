import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/destination_info.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/core/commons/widgets/sections/material_info_section.dart';
import 'package:graville_operations/core/commons/widgets/sections/source_site_info.dart';
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
  final _othersController   = TextEditingController();

  List<AppMaterial>     _materials = [];
  List<DestinationSite> _sites     = [];
  List<TransportMode>   _modes     = [];
  bool    _dataLoading = true;
  String? _dataError;

  AppMaterial?     _selectedMaterial;
  DestinationSite? _selectedFromSite;
  DestinationSite? _selectedDestination;
  TransportMode?   _selectedMode;
  File?            _imageFile;
  bool             _submitting = false;

  @override
  void initState() {
    super.initState();
    _prefetch();
  }

  Future<void> _prefetch() async {
    setState(() { _dataLoading = true; _dataError = null; });
    try {
      final results = await Future.wait([
        TransferMaterialService.fetchMaterials(),
        TransferMaterialService.fetchSites(),
        TransferMaterialService.fetchTransportModes(),
      ]);
      if (mounted) {
        setState(() {
          _materials   = results[0] as List<AppMaterial>;
          _sites       = results[1] as List<DestinationSite>;
          _modes       = results[2] as List<TransportMode>;
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
  bool get _isOthersMode => _selectedMode?.name == 'Others';

  int? get _transportModeId {
    if (_selectedMode == null) return null;
    final parsed = int.tryParse(_selectedMode!.id);
    return (parsed == null || parsed == 0) ? null : parsed;
  }

  String? get _resolvedNotes {
    final base = _notesController.text.trim();
    if (_isOthersMode && _selectedMode!.name != 'Others') {
      final t = 'Transport: ${_selectedMode!.name}';
      return base.isEmpty ? t : '$t\n$base';
    }
    return base.isEmpty ? null : base;
  }

  bool get _sameSite =>
      _selectedFromSite != null &&
      _selectedDestination != null &&
      _selectedFromSite!.id == _selectedDestination!.id;

  bool get _isValid =>
      !_dataLoading &&
      _selectedMaterial != null &&
      _selectedFromSite != null &&
      _selectedDestination != null &&
      !_sameSite &&
      _quantityController.text.trim().isNotEmpty &&
      double.tryParse(_quantityController.text.trim()) != null &&
      (_priceController.text.trim().isEmpty ||
          double.tryParse(_priceController.text.trim()) != null) &&
      !(_isOthersMode && _selectedMode!.name == 'Others');

  Future<void> _submit() async {
    if (_sameSite) {
      _snack('Source and destination sites cannot be the same.', isError: true);
      return;
    }
    if (!_isValid) {
      _snack('Please fill all required fields correctly.', isError: true);
      return;
    }
    setState(() => _submitting = true);

    final result = await TransferMaterialService.submitTransfer(
      materialId:      int.parse(_selectedMaterial!.id),
      fromSiteId:      int.parse(_selectedFromSite!.id),
      toSiteId:        int.parse(_selectedDestination!.id),
      quantity:        double.parse(_quantityController.text.trim()),
      pricePerUnit:    _priceController.text.trim().isEmpty
                           ? 0.0
                           : double.parse(_priceController.text.trim()),
      transportModeId: _transportModeId,
      driverDetails:   _driverController.text.trim().isEmpty
                           ? null : _driverController.text.trim(),
      notes:           _resolvedNotes,
      imageFile:       _imageFile,
    );

    setState(() => _submitting = false);

    if (result['success'] == true) {
      _snack('Transfer confirmed successfully!');
      if (mounted) Navigator.pop(context, true);
    } else {
      _snack(result['message'] ?? 'Transfer failed. Try again.', isError: true);
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
    _priceController.dispose();
    _driverController.dispose();
    _notesController.dispose();
    _othersController.dispose();
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
                Text('Transfer Material',
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
                              style:
                                  TextStyle(color: Colors.red.shade700)),
                        ),
                      ]),
                    ),
                  )

                else ...[
                  MaterialPhotoSection(
                    onImagePicked: (f) => setState(() => _imageFile = f),
                  ),

                  MaterialInfoSection(
                    selectedMaterial: _selectedMaterial,
                    items: _materials,
                    onChanged: (m) =>
                        setState(() => _selectedMaterial = m),
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

                  SourceSiteInfo(
                    selectedSite: _selectedFromSite,
                    items: _sites,
                    onChanged: (s) =>
                        setState(() => _selectedFromSite = s),
                  ),

                  if (_selectedFromSite != null ||
                      _selectedDestination != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            _selectedFromSite?.name ?? '—',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              color: _sameSite
                                  ? Colors.red
                                  : Colors.blue,
                              size: 20),
                        ),
                        Expanded(
                          child: Text(
                            _selectedDestination?.name ?? '—',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ),

                  if (_sameSite)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.red.shade400, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Source and destination cannot be the same.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.red),
                          ),
                        ),
                      ]),
                    ),

                  DestinationInfo(
                    selectedDestination: _selectedDestination,
                    items: _sites,
                    onChanged: (d) =>
                        setState(() => _selectedDestination = d),
                  ),

                  TransportInfo(
                    selectedMode: _selectedMode,
                    items: _modes,
                    othersController: _othersController,
                    onChanged: (m) => setState(() => _selectedMode = m),
                    onAddNew: () async {
                      // Clear cache and re-fetch modes only
                      TransferMaterialService.clearCache();
                      final fresh =
                          await TransferMaterialService.fetchTransportModes();
                      if (mounted) setState(() => _modes = fresh);
                    },
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
                    label: _submitting
                        ? 'Submitting...'
                        : 'Confirm Transfer',
                    backgroundColor: _isValid && !_submitting
                        ? Colors.orange
                        : Colors.grey.shade400,
                    textColor: Colors.white,
                    borderRadius: 16,
                    height: 55,
                    onPressed:
                        _isValid && !_submitting ? _submit : null,
                  ),

                  const SizedBox(height: 24),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}