import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/skill_badge.dart';
import 'package:graville_operations/models/worker_model.dart';
class BulkCheckInSheet extends StatefulWidget {
  final List<Worker> workers;

  const BulkCheckInSheet({super.key, required this.workers});

  @override
  State<BulkCheckInSheet> createState() => _BulkCheckInSheetState();
}

class _BulkCheckInSheetState extends State<BulkCheckInSheet> {
  final Set<int> _selected = {};
  final TextEditingController _search = TextEditingController();

  List<Worker> get _filtered {
    final q = _search.text.toLowerCase().trim();
    if (q.isEmpty) return widget.workers;
    return widget.workers
        .where((w) =>
            w.fullName.toLowerCase().contains(q) ||
            w.nationalId.toString().contains(q))
        .toList();
  }

  bool get _allSelected {
    final f = _filtered;
    return f.isNotEmpty && f.every((w) => w.id != null && _selected.contains(w.id));
  }

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        for (final w in _filtered) { if (w.id != null) _selected.remove(w.id); }
      } else {
        for (final w in _filtered) { if (w.id != null) _selected.add(w.id!); }
      }
    });
  }

  void _toggle(int id) => setState(() {
    _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
  });

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          _SheetHeader(
            selectedCount: _selected.length,
            searchController: _search,
            onSearchChanged: () => setState(() {}),
          ),
          _ColumnHeaders(allSelected: _allSelected, onToggleAll: _toggleAll),
          const Divider(height: 1),
          Expanded(child: _WorkerList(
            workers: _filtered,
            selected: _selected,
            scrollController: scrollController,
            onToggle: _toggle,
          )),
          _Footer(
            selectedCount: _selected.length,
            onCancel: () => Navigator.of(context).pop(null),
            onConfirm: () => Navigator.of(context).pop(Set<int>.from(_selected)),
          ),
        ]),
      ),
    );
  }
}


class _SheetHeader extends StatelessWidget {
  final int selectedCount;
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;

  const _SheetHeader({
    required this.selectedCount,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Column(children: [
      // Drag handle
      Container(width: 40, height: 4,
          decoration: BoxDecoration(
              color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
      const SizedBox(height: 14),
      Row(children: [
        const Icon(Icons.how_to_reg_rounded, color: Colors.blue, size: 22),
        const SizedBox(width: 8),
        const Expanded(
          child: Text('Select Workers to Check In',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        if (selectedCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.blue.shade100, borderRadius: BorderRadius.circular(20)),
            child: Text('$selectedCount selected',
                style: TextStyle(color: Colors.blue.shade800,
                    fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ]),
      const SizedBox(height: 12),
      TextField(
        controller: searchController,
        onChanged: (_) => onSearchChanged(),
        decoration: InputDecoration(
          isDense: true, filled: true, fillColor: Colors.grey.shade50,
          prefixIcon: const Icon(Icons.search, size: 20),
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
    ]),
  );
}

class _ColumnHeaders extends StatelessWidget {
  final bool allSelected;
  final VoidCallback onToggleAll;

  const _ColumnHeaders({required this.allSelected, required this.onToggleAll});

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.grey.shade100,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(children: [
      SizedBox(
        width: 36,
        child: Checkbox(
          value: allSelected,
          tristate: true,
          onChanged: (_) => onToggleAll(),
          activeColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      ...[('NAME', 3), ('ID', 2), ('TYPE', 2), ('PHONE', 2), ('JOINED', 2)]
          .map((e) => Expanded(
            flex: e.$2,
            child: Text(e.$1,
                style: const TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 12, letterSpacing: 0.5)),
          )),
    ]),
  );
}

class _WorkerList extends StatelessWidget {
  final List<Worker> workers;
  final Set<int> selected;
  final ScrollController scrollController;
  final void Function(int) onToggle;

  const _WorkerList({
    required this.workers,
    required this.selected,
    required this.scrollController,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (workers.isEmpty) {
      return const Center(
          child: Text('No workers found.', style: TextStyle(color: Colors.grey)));
    }
    return ListView.separated(
      controller: scrollController,
      itemCount: workers.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (_, i) {
        final w = workers[i];
        final isSelected = w.id != null && selected.contains(w.id);
        return InkWell(
          onTap: w.id != null ? () => onToggle(w.id!) : null,
          child: Container(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              SizedBox(
                width: 36,
                child: Checkbox(
                  value: isSelected,
                  onChanged: w.id != null ? (_) => onToggle(w.id!) : null,
                  activeColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              Expanded(flex: 3, child: Text(w.fullName,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  overflow: TextOverflow.ellipsis)),
              Expanded(flex: 2, child: Text(w.nationalId.toString(),
                  style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
              Expanded(flex: 2, child: SkillBadge(skillType: w.skillType)),
              Expanded(flex: 2, child: Text(w.phoneNumber,
                  style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
              Expanded(flex: 2, child: Text(
                  w.createdAt != null
                      ? '${w.createdAt!.day}/${w.createdAt!.month}/${w.createdAt!.year}'
                      : '—',
                  style: const TextStyle(fontSize: 13))),
            ]),
          ),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _Footer({
    required this.selectedCount,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06), blurRadius: 12,
          offset: const Offset(0, -4))],
    ),
    child: Row(children: [
      Expanded(
        child: OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text('Cancel'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        flex: 2,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: Text(
            selectedCount == 0
                ? 'Check In Selected'
                : 'Check In $selectedCount Worker${selectedCount == 1 ? '' : 's'}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCount == 0 ? Colors.grey.shade400 : Colors.blue.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: selectedCount == 0 ? 0 : 2,
          ),
          onPressed: selectedCount == 0 ? null : onConfirm,
        ),
      ),
    ]),
  );
}