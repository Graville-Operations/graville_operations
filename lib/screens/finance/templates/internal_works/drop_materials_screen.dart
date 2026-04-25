import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DropMaterialsScreen extends StatefulWidget {
  final Map<String, dynamic> pickData;

  const DropMaterialsScreen({super.key, required this.pickData});

  @override
  State<DropMaterialsScreen> createState() => _DropMaterialsScreenState();
}

class _DropMaterialsScreenState extends State<DropMaterialsScreen> {
  File? _sitePhoto;
  bool _submitting = false;
  final _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _sitePhoto = File(picked.path));
    }
  }

  void _submit() async {
    if (_sitePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please take a photo of the materials on site'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _submitting = true);

    // Build final payload combining pick + drop data
    final finalPayload = {
      ...widget.pickData,
      'drop_photo': _sitePhoto!.path,
    };

    // TODO: submit finalPayload to your API
    debugPrint('Final payload: $finalPayload');

    await Future.delayed(const Duration(seconds: 1)); // simulate

    setState(() => _submitting = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Internal works record submitted successfully'),
        backgroundColor: Color(0xFF1B8A5A),
      ),
    );

    // Pop back to templates screen
    Navigator.popUntil(context, (route) => route.isFirst || 
        route.settings.name == '/finance/templates');
  }

  @override
  Widget build(BuildContext context) {
    final siteName = widget.pickData['site_name'] ?? '—';
    final company = widget.pickData['company'] ?? '—';
    final materials =
        (widget.pickData['materials'] as List<dynamic>? ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Drop Materials'),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ElevatedButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline_rounded),
            label:
                Text(_submitting ? 'Submitting...' : 'Submit Drop Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBackground,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── Pick summary (read-only)
          _buildSummaryCard(siteName, company, materials),
          const SizedBox(height: 12),

          // ─── Site photo (required)
          _buildPhotoCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String siteName, String company, List<dynamic> materials) {
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
                Icon(Icons.summarize_rounded,
                    size: 16, color: AppColor.primaryBackground),
                const SizedBox(width: 8),
                const Text(
                  'Pick Summary',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Read only',
                    style: TextStyle(
                        fontSize: 10, color: Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(label: 'Supplier', value: company),
                _SummaryRow(label: 'Destination', value: siteName),
                const SizedBox(height: 8),
                const Text(
                  'Materials',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 6),
                ...materials.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 6, color: Color(0xFF6B7280)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${m['name']} — qty: ${m['quantity']}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF111827)),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard() {
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
                const Text(
                  'Site Photo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const Text(' *',
                    style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _sitePhoto == null
                ? GestureDetector(
                    onTap: _takePhoto,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 36,
                              color: AppColor.primaryBackground
                                  .withOpacity(0.6)),
                          const SizedBox(height: 10),
                          const Text(
                            'Take photo of materials on site',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to open camera',
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
                          _sitePhoto!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _sitePhoto = null),
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
                          onTap: _takePhoto,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}