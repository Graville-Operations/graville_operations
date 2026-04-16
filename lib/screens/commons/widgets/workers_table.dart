import 'package:flutter/material.dart';
import 'package:graville_operations/models/worker_model.dart';
import 'package:graville_operations/screens/commons/widgets/skill_badge.dart';
import 'package:graville_operations/screens/commons/widgets/status_badge.dart';

class WorkersTable extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<Worker> workers;
  final Map<int, bool> checkedIn;
  final bool sessionActive;
  final VoidCallback onRetry;
  final Future<void> Function(Worker) onVerify;
  final void Function(Worker) onRowTap;

  const WorkersTable({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.workers,
    required this.checkedIn,
    required this.sessionActive,
    required this.onRetry,
    required this.onVerify,
    required this.onRowTap, required String emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _ShimmerTable();

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
            const SizedBox(height: 12),
            Text(errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600)),
            const SizedBox(height: 16),
            TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again')),
          ]),
        ),
      );
    }

    if (workers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Text('No workers found.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final cols = sessionActive
        ? ['NAME', 'ID', 'TYPE', 'PHONE NO', 'SITE', 'JOINED', 'STATUS', 'VERIFY']
        : ['NAME', 'ID', 'TYPE', 'PHONE NO', 'SITE', 'JOINED', 'STATUS', 'CHECK IN'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
          columnSpacing: 20,
          headingRowHeight: 44,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 56,
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade200),
            bottom: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          columns: cols
              .map((t) => DataColumn(
                    label: Text(t,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.5)),
                  ))
              .toList(),
          rows: workers.map((worker) => _buildRow(worker)).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(Worker worker) {
    final id = worker.id;
    final isChecked = id != null && checkedIn[id] == true;
    final isUploading = id != null && checkedIn.containsKey(id) && !isChecked;

    return DataRow(
      color: isChecked ? WidgetStatePropertyAll(Colors.green.shade50) : null,
      onSelectChanged: (_) => onRowTap(worker),
      cells: [
        DataCell(Text(worker.fullName,
            style: const TextStyle(fontWeight: FontWeight.w500))),
        DataCell(Text(worker.nationalId.toString())),
        DataCell(SkillBadge(skillType: worker.skillType)),
        DataCell(Text(worker.phoneNumber)),
        DataCell(Text(worker.siteId?.toString() ?? '—')),
        DataCell(Text(worker.createdAt != null
            ? '${worker.createdAt!.day}/${worker.createdAt!.month}/${worker.createdAt!.year}'
            : '—')),
        DataCell(isUploading
            ? const SizedBox(width: 18, height: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
            : StatusBadge(isPresent: isChecked)),
        DataCell(_ActionCell(
          isChecked: isChecked,
          isUploading: isUploading,
          sessionActive: sessionActive,
          onTap: id != null ? () => onVerify(worker) : null,
        )),
      ],
    );
  }
}


class _ActionCell extends StatelessWidget {
  final bool isChecked;
  final bool isUploading;
  final bool sessionActive;
  final VoidCallback? onTap;

  const _ActionCell({
    required this.isChecked,
    required this.isUploading,
    required this.sessionActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isUploading) return const SizedBox.shrink();

    if (isChecked) {
      return Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 24),
        if (sessionActive) ...[
          const SizedBox(width: 6),
          _iconBox(Colors.orange, Icons.verified_user_outlined),
        ],
      ]);
    }

    final color = sessionActive ? Colors.orange : Colors.blue;
    final icon = sessionActive ? Icons.verified_user_outlined : Icons.camera_alt_outlined;
    return GestureDetector(
      onTap: onTap,
      child: _iconBox(color, icon),
    );
  }

  Widget _iconBox(Color color, IconData icon) => Container(
    width: 28, height: 28,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400, width: 2),
      borderRadius: BorderRadius.circular(6),
      color: Colors.grey.shade50,
    ),
    child: Icon(icon, size: 16, color: Colors.grey.shade700),
  );
}


class _ShimmerTable extends StatelessWidget {
  const _ShimmerTable();

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Container(height: 44, color: Colors.grey.shade100),
      const Divider(height: 1),
      ...List.generate(5, (_) => Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            for (final f in [3, 2, 2, 2, 1, 2, 2, 1]) ...[
              Expanded(flex: f, child: Container(
                height: f == 1 ? 28 : 12,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(f == 1 ? 6 : 4)),
              )),
              const SizedBox(width: 12),
            ],
          ]),
        ),
        const Divider(height: 1),
      ])),
    ]),
  );
}