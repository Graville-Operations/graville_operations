import 'package:flutter/material.dart';
import 'package:graville_operations/application/custom_navigator.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:shimmer/shimmer.dart';
import 'package:graville_operations/models/worker_model.dart';
import 'package:graville_operations/screens/workers/add_worker_screen.dart';
import 'package:graville_operations/screens/workers/worker_profile_screen.dart';
import 'package:graville_operations/services/worker_service.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  String? selectedSite;
  final TextEditingController searchController = TextEditingController();

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<Worker> _workers = [];
  List<Worker> _filteredWorkers = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> sites = [
    'Mabatini', 'Mishi Mboko', 'Huruma', 'DCC Kibra', 'Ngei', 'Iremele',
  ];

  @override
  void initState() {
    super.initState();
    _loadWorkers();
  }

  Future<void> _loadWorkers() async {
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final workers = await WorkerService.fetchWorkers();
      setState(() { _workers = workers; _filteredWorkers = workers; _isLoading = false; });
    } on WorkerServiceException catch (e) {
      setState(() { _errorMessage = e.message; _isLoading = false; });
    } catch (_) {
      setState(() { _errorMessage = 'Failed to load workers. Please try again.'; _isLoading = false; });
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final query = searchController.text.toLowerCase();
        final results = _workers.where((w) => w.fullName.toLowerCase().contains(query)).toList();
        return Positioned(
          width: 240,
          child: CompositedTransformFollower(
            link: _layerLink, offset: const Offset(0, 50), showWhenUnlinked: false,
            child: Material(
              elevation: 4, borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: results.isEmpty
                    ? const Padding(padding: EdgeInsets.all(12), child: Text("No result"))
                    : ListView.builder(
                        padding: EdgeInsets.zero, shrinkWrap: true, itemCount: results.length,
                        itemBuilder: (context, index) {
                          final worker = results[index];
                          return ListTile(
                            title: Text(worker.fullName),
                            onTap: () {
                              _removeOverlay();
                              searchController.clear();
                              context.push(WorkerProfileScreen(worker: worker));
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() { _overlayEntry?.remove(); _overlayEntry = null; }

  @override
  void dispose() { _removeOverlay(); searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0, backgroundColor: const Color(0xFFF5F6F8),
        title: const Row(children: [
          Icon(Icons.home_work_rounded, color: Colors.blue), SizedBox(width: 10),
          Text("Workers", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: _loadWorkers, tooltip: "Refresh"),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Site dropdown
          const Text("Construction Site",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200)),
            child: CustomDropdown<String>(
              value: selectedSite, items: sites, displayMapper: (s) => s,
              onChanged: (v) => setState(() => selectedSite = v),
              hint: 'Select Site', isExpanded: true, isDense: true,
              border: InputBorder.none, fillColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 16),

          // Stat cards — shimmer when loading
          _isLoading
              ? _ShimmerStatRow()
              : Row(children: [
                  Expanded(child: _statCard(
                    title: '${_workers.length}', subtitle: "Total Workers Assigned",
                    color: Colors.blue.shade100, textColor: Colors.blue, onTap: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard(
                    title: '${_workers.length}', subtitle: "Workers Present Today",
                    color: Colors.orange.shade100, textColor: Colors.orange, onTap: () {})),
                ]),

          const SizedBox(height: 16),

          // Actions row
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await context.push(const AddWorkerScreen());
                  if (result != null) _loadWorkers();
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.person_add, color: Colors.blue, size: 18),
                    SizedBox(width: 8),
                    Text("Add Worker", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: searchController,
                  onChanged: (v) => v.isEmpty ? _removeOverlay() : _showOverlay(),
                  decoration: InputDecoration(
                    isDense: true, filled: true, fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search), hintText: "Search",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 20),
          const Text("Workers List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          // Table / loading / error / empty
          if (_isLoading)
            _ShimmerTable()
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                  const SizedBox(height: 12),
                  Text(_errorMessage!, textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade600)),
                  const SizedBox(height: 16),
                  TextButton.icon(onPressed: _loadWorkers,
                      icon: const Icon(Icons.refresh), label: const Text("Try Again")),
                ]),
              ),
            )
          else if (_workers.isEmpty)
            const Center(
              child: Padding(padding: EdgeInsets.symmetric(vertical: 60),
                  child: Text("No workers found.", style: TextStyle(color: Colors.grey))),
            )
          else
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
                    blurRadius: 8, offset: const Offset(0, 2))]),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
                  columnSpacing: 24, headingRowHeight: 44,
                  dataRowMinHeight: 52, dataRowMaxHeight: 52,
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade200),
                    bottom: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  columns: _buildHeaderColumns(),
                  rows: _buildWorkerRows(),
                ),
              ),
            ),

          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  List<DataColumn> _buildHeaderColumns() {
    return ["NAME", "ID", "TYPE", "PHONE NO", "SITE", "JOINED"]
        .map((t) => DataColumn(label: Text(t,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                color: Colors.black, letterSpacing: 0.5))))
        .toList();
  }

  List<DataRow> _buildWorkerRows() {
    return _workers.map((worker) => DataRow(
      onSelectChanged: (s) { if (s == true) context.push(WorkerProfileScreen(worker: worker)); },
      cells: [
        DataCell(Text(worker.fullName, style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(worker.nationalId.toString())),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: worker.skillType.toLowerCase() == 'skilled'
                ? Colors.blue.shade100 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(worker.skillType,
              style: TextStyle(
                color: worker.skillType.toLowerCase() == 'skilled'
                    ? Colors.blue.shade800 : Colors.grey.shade800,
                fontWeight: FontWeight.bold, fontSize: 12)),
        )),
        DataCell(Text(worker.phoneNumber)),
        DataCell(Text(worker.siteId?.toString() ?? '—')),
        DataCell(Text(worker.createdAt != null
            ? '${worker.createdAt!.day}/${worker.createdAt!.month}/${worker.createdAt!.year}'
            : '—')),
      ],
    )).toList();
  }
}

class _ShimmerStatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Row(children: [
        Expanded(child: Container(height: 90,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 90,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
      ]),
    );
  }
}

class _ShimmerTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          // Header placeholder
          Container(height: 44, color: Colors.grey.shade100),
          const Divider(height: 1),
          // Row placeholders
          ...List.generate(5, (_) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                Expanded(flex: 3, child: _SBox(width: double.infinity, height: 12)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 12)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 22, radius: 12)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 12)),
                const SizedBox(width: 12),
                Expanded(flex: 1, child: _SBox(width: double.infinity, height: 12)),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _SBox(width: double.infinity, height: 12)),
              ]),
            ),
            const Divider(height: 1),
          ])),
        ]),
      ),
    );
  }
}

class _SBox extends StatelessWidget {
  final double width, height;
  final double radius;
  const _SBox({required this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) => Container(
      width: width, height: height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)));
}

Widget _statCard({
  required String title, required String subtitle,
  required Color color, required Color textColor, required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
      ]),
    ),
  );
}