import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graville_operations/application/custom_navigator.dart';
import 'package:graville_operations/models/worker_model.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/commons/widgets/stat_card.dart';
import 'package:graville_operations/screens/commons/widgets/workers_table.dart';
import 'package:graville_operations/screens/workers/add_worker_screen.dart';
import 'package:graville_operations/screens/commons/widgets/bulk_checkin_sheet.dart';
import 'package:graville_operations/screens/workers/worker_profile_screen.dart';
import 'package:graville_operations/services/attendance_service.dart';
import 'package:graville_operations/services/worker_service.dart';
import 'package:image_picker/image_picker.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  String? _selectedSite;
  bool _isLoading = true;
  String? _errorMessage;

  List<Worker> _allWorkers = [];
  List<Worker> _checkedInWorkers = [];

  final Map<int, bool> _checkedIn = {};

  final TextEditingController _attendanceSearch = TextEditingController();

  List<Worker> get _filteredAttendance {
    final q = _attendanceSearch.text.toLowerCase().trim();
    if (q.isEmpty) return _checkedInWorkers;
    return _checkedInWorkers.where((w) =>
        w.fullName.toLowerCase().contains(q) ||
        w.nationalId.toString().contains(q)).toList();
  }

  final List<String> _sites = [
    'Mabatini', 'Mishi Mboko', 'Huruma', 'DCC Kibra', 'Ngei', 'Iremele',
  ];

  int get _presentCount => _checkedIn.values.where((v) => v).length;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _attendanceSearch.dispose();
    super.dispose();
  }


  Future<void> _loadData() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final results = await Future.wait([
        WorkerService.fetchWorkers(),
        AttendanceService.fetchTodayPresentIds(),
      ]);

      final all      = results[0] as List<Worker>;
      final todayIds = results[1] as List<int>;
      final idSet    = todayIds.toSet();

      setState(() {
        _allWorkers       = all;
        _checkedIn.clear();
        for (final id in todayIds) { _checkedIn[id] = true; }
        _checkedInWorkers = all.where((w) => w.id != null && idSet.contains(w.id)).toList();
        _isLoading        = false;
      });
    } on WorkerServiceException catch (e) {
      setState(() { _errorMessage = e.message; _isLoading = false; });
    } catch (_) {
      setState(() { _errorMessage = 'Failed to load data. Please try again.'; _isLoading = false; });
    }
  }


  Future<void> _openBulkCheckIn() async {
    final eligible = _allWorkers
        .where((w) => w.id != null && _checkedIn[w.id] != true)
        .toList();

    if (eligible.isEmpty) {
      _snack('All workers are already checked in today.', Colors.orange.shade700);
      return;
    }

    final selected = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BulkCheckInSheet(workers: eligible),
    );

    if (selected == null || selected.isEmpty || !mounted) return;

    setState(() { for (final id in selected) _checkedIn[id] = false; });

    int successCount = 0;
    final newlyPresent = <Worker>[];

    for (final worker in eligible.where((w) => selected.contains(w.id))) {
      try {
        await AttendanceService.checkInWorkerBulk(workerId: worker.id!);
        if (!mounted) break;
        setState(() => _checkedIn[worker.id!] = true);
        newlyPresent.add(worker);
        successCount++;
      } catch (_) {
        if (mounted) setState(() => _checkedIn.remove(worker.id));
      }
    }

    if (!mounted) return;

    setState(() {
      _checkedInWorkers = [..._checkedInWorkers, ...newlyPresent];
    });

    if (successCount > 0) {
      _snack('$successCount worker${successCount == 1 ? '' : 's'} checked in ✓', Colors.green.shade600);
    }
  }


  Future<void> _handleVerify(Worker worker) async {
    final workerId = worker.id;
    if (workerId == null) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked == null || !mounted) return;

    setState(() => _checkedIn[workerId] = false);
    try {
      await AttendanceService.verifyWorker(workerId: workerId, photo: File(picked.path));
      if (!mounted) return;
      setState(() => _checkedIn[workerId] = true);
      _snack('${worker.fullName} verified ✓', Colors.green.shade600);
    } on AttendanceServiceException catch (e) {
      if (!mounted) return;
      setState(() => _checkedIn.remove(workerId));
      _snack(e.message, Colors.red.shade600);
    }
  }

  void _snack(String msg, Color bg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: bg,
        behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F6F8),
        title: const Row(children: [
          Icon(Icons.home_work_rounded, color: Colors.blue),
          SizedBox(width: 10),
          Text('Workers', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        ]),
      //   actions: [
      //     IconButton(icon: const Icon(Icons.refresh, color: Colors.blue),
      //         onPressed: _loadData, tooltip: 'Refresh'),
      //   ],
       ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SiteSelector(sites: _sites, value: _selectedSite,
                  onChanged: (v) => setState(() => _selectedSite = v)),
              const SizedBox(height: 16),
              _StatsRow(isLoading: _isLoading, total: _allWorkers.length, present: _presentCount),
              const SizedBox(height: 16),
              _AddWorkerButton(onTap: () async {
                final result = await context.push(const AddWorkerScreen());
                if (result != null) _loadData();
              }),
              const SizedBox(height: 12),
              if (!_isLoading && _errorMessage == null)
                _BulkCheckInButton(onPressed: _openBulkCheckIn),
              const SizedBox(height: 20),

              _AttendanceHeader(
                presentCount: _checkedInWorkers.length,
                isLoading: _isLoading,
                searchController: _attendanceSearch,
                onSearchChanged: () => setState(() {}),
              ),
              const SizedBox(height: 10),

              WorkersTable(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                workers: _filteredAttendance,   // ← filtered list
                checkedIn: _checkedIn,
                sessionActive: true,
                onRetry: _loadData,
                onVerify: _handleVerify,
                onRowTap: (w) => context.push(WorkerProfileScreen(worker: w)),
                emptyMessage: _attendanceSearch.text.trim().isNotEmpty
                    ? 'No matching workers found.'
                    : 'No workers checked in yet.\nTap "Check In Workers" above.',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _SiteSelector extends StatelessWidget {
  final List<String> sites;
  final String? value;
  final ValueChanged<String?> onChanged;
  const _SiteSelector({required this.sites, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Construction Site',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: CustomDropdown<String>(
          value: value, items: sites, displayMapper: (s) => s,
          onChanged: onChanged, hint: 'Select Site', isExpanded: true,
          isDense: true, border: InputBorder.none,
          fillColor: Colors.transparent, borderRadius: BorderRadius.circular(10),
        ),
      ),
    ],
  );
}

class _StatsRow extends StatelessWidget {
  final bool isLoading;
  final int total;
  final int present;
  const _StatsRow({required this.isLoading, required this.total, required this.present});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Row(children: [
        Expanded(child: _shimmer()), const SizedBox(width: 12), Expanded(child: _shimmer()),
      ]);
    }
    return Row(children: [
      Expanded(child: StatCard(icon: Icons.people_rounded, title: 'Total Assigned',
          value: '$total', color: Colors.blue)),
      const SizedBox(width: 12),
      Expanded(child: StatCard(icon: Icons.how_to_reg_rounded, title: 'Present Today',
          value: '$present', color: Colors.green)),
    ]);
  }

  Widget _shimmer() => Container(height: 90,
      decoration: BoxDecoration(color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18)));
}

class _AddWorkerButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddWorkerButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 48,
      decoration: BoxDecoration(
          color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.person_add, color: Colors.blue, size: 18),
        SizedBox(width: 8),
        Text('Add Worker', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

class _BulkCheckInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BulkCheckInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: 50,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.how_to_reg_rounded),
      label: const Text('Check In Workers',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
      onPressed: onPressed,
    ),
  );
}

class _AttendanceHeader extends StatelessWidget {
  final int presentCount;
  final bool isLoading;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  const _AttendanceHeader({
    required this.presentCount,
    required this.isLoading,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Today's Attendance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            if (!isLoading && presentCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text('$presentCount present',
                    style: TextStyle(fontSize: 11, color: Colors.green.shade700,
                        fontWeight: FontWeight.w600)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Search bar
        TextField(
          controller: searchController,
          onChanged: (_) => onSearchChanged(),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged();
                    },
                  )
                : null,
            hintText: 'Search by name or ID…',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }
}