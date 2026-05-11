import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:graville_operations/models/checkin_item_state.dart';
import 'package:graville_operations/services/store_checkin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInDateGuard {
  static String _key(int storeId) => 'last_checkin_date_store_$storeId';

  static Future<bool> hasCheckedInToday(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key(storeId));
    if (stored == null) return false;
    final storedDate = DateTime.tryParse(stored);
    if (storedDate == null) return false;
    final today = DateTime.now();
    return storedDate.year == today.year &&
        storedDate.month == today.month &&
        storedDate.day == today.day;
  }

  static Future<void> markCheckedInToday(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(storeId), DateTime.now().toIso8601String());
  }

  static Future<void> reset(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(storeId));
  }
}

class StoreCheckInScreen extends StatefulWidget {
  final int storeId;
  const StoreCheckInScreen({super.key, required this.storeId});

  @override
  State<StoreCheckInScreen> createState() => _StoreCheckInScreenState();
}

class _StoreCheckInScreenState extends State<StoreCheckInScreen> {
  final _service = StoreCheckInService();

  List<CheckInItemState> _materials = [];
  List<CheckInItemState> _tools = [];

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _alreadyCheckedIn = false;
  String? _errorMessage;

  static const _blue = Color(0xFF1565C0);
  static const _teal = Color(0xFF00695C);
  static const _red = Color(0xFFC62828);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final done = await CheckInDateGuard.hasCheckedInToday(widget.storeId);
    if (done && mounted) {
      setState(() {
        _alreadyCheckedIn = true;
        _isLoading = false;
      });
      return;
    }
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait([
        _service.fetchMaterials(widget.storeId),
        _service.fetchTools(widget.storeId),
      ]);
      setState(() {
        _materials = results[0].map((i) => CheckInItemState(item: i)).toList();
        _tools = results[1].map((i) => CheckInItemState(item: i)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<CheckInItemState> get _allItems => [..._materials, ..._tools];
  int get _totalItems => _allItems.length;
  int get _resolvedItems =>
      _allItems.where((s) => s.status != CheckInStatus.pending).length;

  void _toggle(CheckInItemState s) {
    setState(() {
      if (s.status == CheckInStatus.checkedIn) {
        s.status = CheckInStatus.pending;
      } else {
        s.status = CheckInStatus.checkedIn;
        s.issueComment = null;
      }
    });
  }

  void _showIssueModal(CheckInItemState s) {
    final controller = TextEditingController(text: s.issueComment);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IssueBottomSheet(
        itemName: s.item.displayName,
        controller: controller,
        onSubmit: (comment) {
          setState(() {
            s.status = CheckInStatus.hasIssue;
            s.issueComment = comment;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (_resolvedItems < _totalItems) {
      final remaining = _totalItems - _resolvedItems;
      _showSnack(
        '$remaining item(s) still need a check-in or issue report.',
        isError: true,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final payload = {
      'store_id': widget.storeId,
      'checked_at': DateTime.now().toIso8601String(),
      'items': _allItems.map((s) => s.toJson()).toList(),
    };
    final response = await http.post(
      Uri.parse(
          'https://j6bxcq4z-8000.uks1.devtunnels.ms/api/v1/store/checkin'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    setState(() => _isSubmitting = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await CheckInDateGuard.markCheckedInToday(widget.storeId);
      _showSnack('Check-in recorded successfully!');
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);
    } else {
      _showSnack('Check-in failed (${response.statusCode}): ${response.body}',
          isError: true);
    }

    await Future.delayed(const Duration(milliseconds: 800));
    await CheckInDateGuard.markCheckedInToday(widget.storeId);

    // if (mounted) {
    //   setState(() => _isSubmitting = false);
    //   _showSnack('Check-in recorded successfully!');
    //   await Future.delayed(const Duration(milliseconds: 500));
    //   if (mounted) Navigator.pop(context);
    // }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? _red : Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Store Check-in',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          if (!_isLoading && !_alreadyCheckedIn && _totalItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(
                child: Text(
                  '$_resolvedItems / $_totalItems',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_alreadyCheckedIn) {
      return _AlreadyCheckedInView(
        onReset: () async {
          await CheckInDateGuard.reset(widget.storeId);
          setState(() => _alreadyCheckedIn = false);
          _loadData();
        },
      );
    }

    if (_errorMessage != null) {
      return _ErrorView(message: _errorMessage!, onRetry: _loadData);
    }

    if (_materials.isEmpty && _tools.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'No items found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Store #${widget.storeId} has no materials or tools assigned yet.\nAdd them via the backend first.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        LinearProgressIndicator(
          value: _totalItems == 0 ? 0 : _resolvedItems / _totalItems,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(_blue),
          minHeight: 3,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              children: [
                if (_materials.isNotEmpty) ...[
                  _SectionHeader(
                      label: 'Materials',
                      count: _materials.length,
                      color: _blue),
                  const SizedBox(height: 10),
                  ..._materials.map((s) => _StoreItemCard(
                        state: s,
                        onCheckIn: () => _toggle(s),
                        onIssue: () => _showIssueModal(s),
                      )),
                  const SizedBox(height: 18),
                ],
                if (_tools.isNotEmpty) ...[
                  _SectionHeader(
                      label: 'Tools', count: _tools.length, color: _teal),
                  const SizedBox(height: 10),
                  ..._tools.map((s) => _StoreItemCard(
                        state: s,
                        onCheckIn: () => _toggle(s),
                        onIssue: () => _showIssueModal(s),
                      )),
                ],
              ],
            ),
          ),
        ),
        _BottomBar(
          isSubmitting: _isSubmitting,
          onCancel: () => Navigator.pop(context),
          onCheckIn: _submit,
        ),
      ],
    );
  }
}

class _StoreItemCard extends StatelessWidget {
  final CheckInItemState state;
  final VoidCallback onCheckIn;
  final VoidCallback onIssue;

  const _StoreItemCard({
    required this.state,
    required this.onCheckIn,
    required this.onIssue,
  });

  @override
  Widget build(BuildContext context) {
    final isChecked = state.status == CheckInStatus.checkedIn;
    final hasIssue = state.status == CheckInStatus.hasIssue;

    final borderColor = hasIssue
        ? Colors.red.shade200
        : isChecked
            ? const Color(0xFF1565C0).withOpacity(0.4)
            : Colors.grey.shade200;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onCheckIn,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isChecked ? const Color(0xFF1565C0) : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isChecked
                          ? const Color(0xFF1565C0)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isChecked
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.item.displayName,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF212121))),
                  const SizedBox(height: 2),
                  Text(state.item.displaySubtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(state.item.displayBadge,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey)),
                  ),
                  if (state.issueComment != null &&
                      state.issueComment!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 12, color: Colors.red.shade700),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              state.issueComment!,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red.shade700,
                                  fontStyle: FontStyle.italic),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onIssue,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hasIssue ? Colors.red.shade100 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: hasIssue ? Colors.red.shade400 : Colors.red.shade100,
                  ),
                ),
                child: Icon(Icons.close_rounded,
                    size: 16, color: Colors.red.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _SectionHeader
// ============================================================
class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SectionHeader(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: color)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Text('$count items',
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ),
      ],
    );
  }
}

// ============================================================
// _BottomBar
// ============================================================
class _BottomBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onCheckIn;

  const _BottomBar(
      {required this.isSubmitting,
      required this.onCancel,
      required this.onCheckIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting ? null : onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : onCheckIn,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.check_rounded, size: 18),
              label: Text(isSubmitting ? 'Submitting...' : 'Check In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// _IssueBottomSheet
// ============================================================
class _IssueBottomSheet extends StatelessWidget {
  final String itemName;
  final TextEditingController controller;
  final void Function(String) onSubmit;

  const _IssueBottomSheet(
      {required this.itemName,
      required this.controller,
      required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text('Report an Issue',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700)),
            const SizedBox(height: 4),
            Text(itemName,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Describe the quantity or condition problem...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF1565C0))),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please describe the issue.')));
                    return;
                  }
                  onSubmit(text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child:
                    const Text('Submit Report', style: TextStyle(fontSize: 14)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Center(
                  child: Text('Cancel', style: TextStyle(color: Colors.grey))),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _AlreadyCheckedInView
// ============================================================
class _AlreadyCheckedInView extends StatelessWidget {
  final VoidCallback onReset;
  const _AlreadyCheckedInView({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  color: Colors.green.shade50, shape: BoxShape.circle),
              child: Icon(Icons.check_circle_rounded,
                  size: 44, color: Colors.green.shade600),
            ),
            const SizedBox(height: 20),
            const Text('Already Checked In',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              "You've already completed today's store check-in.\nCome back tomorrow.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            // Remove this button before going to production
            TextButton(
              onPressed: onReset,
              child: const Text('[Dev] Reset for testing',
                  style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// _ErrorView
// ============================================================
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Failed to load store data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
