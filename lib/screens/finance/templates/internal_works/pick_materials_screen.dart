import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/models/site/site_model.dart';
import 'package:graville_operations/screens/finance/templates/internal_works/drop_materials_screen.dart';
import 'package:graville_operations/services/site_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PickMaterialsScreen extends StatefulWidget {
  const PickMaterialsScreen({super.key});

  @override
  State<PickMaterialsScreen> createState() => _PickMaterialsScreenState();
}

class _PickMaterialsScreenState extends State<PickMaterialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final List<_MaterialEntry> _materials = [_MaterialEntry()];
  SiteModel? _selectedSite;
  List<SiteModel> _sites = [];
  bool _loadingSites = true;
  File? _vehiclePhoto;
  File? _attachmentPhoto;
  bool _submitting = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  @override
  void dispose() {
    _companyController.dispose();
    for (final e in _materials) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSites() async {
    try {
      final sites = await SiteService.getAllSites();
      setState(() {
        _sites = sites;
        _loadingSites = false;
      });
    } catch (e) {
      setState(() => _loadingSites = false);
    }
  }

  Future<void> _pickPhoto({required bool isVehicle}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        if (isVehicle) {
          _vehiclePhoto = File(picked.path);
        } else {
          _attachmentPhoto = File(picked.path);
        }
      });
    }
  }

  void _addMaterial() {
    setState(() => _materials.add(_MaterialEntry()));
  }

  void _removeMaterial(int index) {
    if (_materials.length == 1) return;
    setState(() {
      _materials[index].dispose();
      _materials.removeAt(index);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSite == null) {
      _showError('Please select a destination site');
      return;
    }
    if (_vehiclePhoto == null) {
      _showError('Please take a photo of the loaded vehicle');
      return;
    }

    // Build payload
    final payload = {
      'company': _companyController.text.trim(),
      'site_id': _selectedSite!.id,
      'site_name': _selectedSite!.name,
      'materials': _materials
          .map((e) => {
                'name': e.nameController.text.trim(),
                'quantity': double.tryParse(e.quantityController.text) ?? 0,
              })
          .toList(),
      'vehicle_photo': _vehiclePhoto!.path,
      'attachment_photo': _attachmentPhoto?.path,
    };

    // Navigate to Drop screen passing the payload
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DropMaterialsScreen(pickData: payload),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Pick Materials'),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── Company
            _SectionCard(
              title: 'Supplier',
              icon: Icons.business_rounded,
              child: _buildTextField(
                controller: _companyController,
                label: 'Company / Supplier Name',
                hint: 'e.g. Bamburi Cement Ltd',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(height: 12),

            // ─── Materials
            _SectionCard(
              title: 'Materials',
              icon: Icons.inventory_2_rounded,
              trailing: TextButton.icon(
                onPressed: _addMaterial,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primaryBackground,
                ),
              ),
              child: Column(
                children: List.generate(
                  _materials.length,
                  (i) => _MaterialRow(
                    entry: _materials[i],
                    index: i,
                    canRemove: _materials.length > 1,
                    onRemove: () => _removeMaterial(i),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ─── Site dropdown
            _SectionCard(
              title: 'Destination Site',
              icon: Icons.location_on_rounded,
              child: _loadingSites
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          color: AppColor.primaryBackground,
                        ),
                      ),
                    )
                  : DropdownButtonFormField<SiteModel>(
                      value: _selectedSite,
                      hint: const Text('Select site',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF9CA3AF))),
                      decoration: _inputDecoration(''),
                      items: _sites
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name ?? 'Unnamed',
                                    style: const TextStyle(fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedSite = v),
                      validator: (v) => v == null ? 'Required' : null,
                    ),
            ),
            const SizedBox(height: 12),

            // ─── Vehicle photo (required)
            _PhotoCard(
              title: 'Vehicle Photo',
              subtitle: 'Photo of materials loaded in vehicle',
              required: true,
              photo: _vehiclePhoto,
              onTake: () => _pickPhoto(isVehicle: true),
              onRemove: () => setState(() => _vehiclePhoto = null),
            ),
            const SizedBox(height: 12),

            // ─── Attachment photo (optional)
            _PhotoCard(
              title: 'Attachment',
              subtitle: 'Optional supporting document / photo',
              required: false,
              photo: _attachmentPhoto,
              onTake: () => _pickPhoto(isVehicle: false),
              onRemove: () => setState(() => _attachmentPhoto = null),
            ),
            const SizedBox(height: 24),

            // ─── Submit
            ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Proceed to Drop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBackground,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 13),
      decoration: _inputDecoration(label, hint: hint),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      hintText: hint,
      hintStyle:
          const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
      labelStyle:
          const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppColor.primaryBackground, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}


class _MaterialEntry {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
  }
}


class _MaterialRow extends StatelessWidget {
  final _MaterialEntry entry;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  const _MaterialRow({
    required this.entry,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: entry.nameController,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Material name',
                hintStyle: const TextStyle(
                    fontSize: 13, color: Color(0xFF9CA3AF)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColor.primaryBackground, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: entry.quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Qty',
                hintStyle: const TextStyle(
                    fontSize: 13, color: Color(0xFF9CA3AF)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColor.primaryBackground, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
          ),
          if (canRemove) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.remove_circle_outline,
                  color: Color(0xFFDC2626), size: 22),
              padding: const EdgeInsets.only(top: 4),
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}


class _PhotoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool required;
  final File? photo;
  final VoidCallback onTake;
  final VoidCallback onRemove;

  const _PhotoCard({
    required this.title,
    required this.subtitle,
    required this.required,
    required this.photo,
    required this.onTake,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.camera_alt_rounded,
                    size: 16, color: AppColor.primaryBackground),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                if (required)
                  const Text(' *',
                      style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.bold)),
                if (!required)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Optional',
                        style: TextStyle(
                            fontSize: 10, color: Color(0xFF6B7280))),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: photo == null
                ? GestureDetector(
                    onTap: onTake,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              size: 32,
                              color: AppColor.primaryBackground
                                  .withOpacity(0.6)),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to take photo',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColor.primaryBackground
                                  .withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          photo!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onTake,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.refresh_rounded,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text('Retake',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}


class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColor.primaryBackground),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}