import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/models/works/pick_record_model.dart';
import 'package:graville_operations/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DropMaterialsScreen extends StatefulWidget {
  const DropMaterialsScreen({super.key});

  @override
  State<DropMaterialsScreen> createState() => _DropMaterialsScreenState();
}

class _DropMaterialsScreenState extends State<DropMaterialsScreen> {
  List<PickRecordModel> _pendingPicks = [];
  PickRecordModel? _selectedPick;
  bool _loadingPicks = true;
  File? _sitePhoto;
  bool _submitting = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadPendingPicks();
  }

  Future<void> _loadPendingPicks() async {
    setState(() => _loadingPicks = true);
    try {
      final result = await ApiService.getPendingPicks();
      if (result['success']) {
        final data = result['data'] as List<dynamic>;
        // ─── Filter internal only
        final picks = data
            .map((e) => PickRecordModel.fromJson(e))
            .where((p) => p.isInternal)
            .toList();
        setState(() {
          _pendingPicks = picks;
          _loadingPicks = false;
        });
      } else {
        setState(() => _loadingPicks = false);
      }
    } catch (e) {
      setState(() => _loadingPicks = false);
    }
  }

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _sitePhoto = File(picked.path));
  }

  Future<void> _submit() async {
    if (_selectedPick == null) {
      _showError('Please select a pick record to confirm');
      return;
    }
    if (_sitePhoto == null) {
      _showError('Please take a photo of the materials on site');
      return;
    }

    setState(() => _submitting = true);

    // TODO: upload photo and pass URL — passing null for now
    final result =
        await ApiService.confirmDrop(_selectedPick!.id, null);
    setState(() => _submitting = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Drop confirmed successfully'),
          backgroundColor: Color(0xFF1B8A5A),
        ),
      );
      Navigator.pop(context);
    } else {
      _showError(result['message'] ?? 'Failed to confirm drop');
    }
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
        title: const Text('Internal Drop'),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadPendingPicks,
            tooltip: 'Refresh',
          ),
        ],
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
                Text(_submitting ? 'Submitting...' : 'Confirm Drop'),
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
      body: _loadingPicks
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppColor.primaryBackground),
            )
          : _pendingPicks.isEmpty
              ? _buildEmpty()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ─── Info banner
                    _buildInfoBanner(),
                    const SizedBox(height: 12),

                    // ─── Pending picks list
                    _buildPicksList(),
                    const SizedBox(height: 12),

                    // ─── Selected pick summary
                    if (_selectedPick != null) ...[
                      _buildPickSummary(),
                      const SizedBox(height: 12),
                    ],

                    // ─── Site photo
                    _buildPhotoCard(),
                    const SizedBox(height: 24),
                  ],
                ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'No pending pick records',
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            'Submit an Internal Pick first',
            style: TextStyle(
                color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: Color(0xFF2563EB), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Select the pick record you are confirming delivery for, then take a photo of the materials on site.',
              style:
                  TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicksList() {
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
                Icon(Icons.list_alt_rounded,
                    size: 16, color: AppColor.primaryBackground),
                const SizedBox(width: 8),
                const Text('Pending Pick Records',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827))),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_pendingPicks.length}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ..._pendingPicks.map((pick) {
            final isSelected = _selectedPick?.id == pick.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedPick = pick),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColor.primaryBackground.withOpacity(0.05)
                      : Colors.transparent,
                  border: Border(
                    left: BorderSide(
                      color: isSelected
                          ? AppColor.primaryBackground
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pick.company,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColor.primaryBackground
                                  : const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${pick.siteName} · ${pick.items.length} item${pick.items.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ref: ${pick.refId}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColor.primaryBackground, size: 20)
                    else
                      const Icon(Icons.radio_button_unchecked_rounded,
                          color: Color(0xFFD1D5DB), size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPickSummary() {
    final pick = _selectedPick!;
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
                const Text('Pick Summary',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Read only',
                      style: TextStyle(
                          fontSize: 10, color: Color(0xFF2563EB))),
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
                _SummaryRow(label: 'Supplier', value: pick.company),
                _SummaryRow(
                    label: 'Destination', value: pick.siteName),
                _SummaryRow(
                    label: 'Submitted By',
                    value: pick.submittedBy ?? '—'),
                const SizedBox(height: 8),
                const Text('Materials',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B7280))),
                const SizedBox(height: 6),
                ...pick.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 6, color: Color(0xFF6B7280)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${item.materialName} — qty: ${item.quantity % 1 == 0 ? item.quantity.toInt() : item.quantity}',
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
                const Text('Site Photo',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827))),
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
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 40,
                              color: AppColor.primaryBackground
                                  .withOpacity(0.6)),
                          const SizedBox(height: 12),
                          const Text(
                            'Take photo of materials on site',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to open camera',
                            style: TextStyle(
                              fontSize: 12,
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
                        child: Image.file(_sitePhoto!,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover),
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
                                shape: BoxShape.circle),
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
                                borderRadius:
                                    BorderRadius.circular(8)),
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

// Summary Row

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