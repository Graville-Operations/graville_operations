import 'package:flutter/material.dart';
import 'package:graville_operations/core/remote/api/task_api.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';
import 'package:graville_operations/screens/commons/widgets/task_card.dart';
import 'package:graville_operations/screens/task_screen/task_details.dart';

class AllTasksScreen extends StatefulWidget {
 
  final int? siteId;
  final String? siteTitle;

  const AllTasksScreen({super.key, this.siteId, this.siteTitle});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  List<TaskResponse> _tasks = [];
  List<TaskResponse> _filtered = [];
  bool _loading = true;
  String? _error;

  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
     
      final tasks = await TaskApi.getAllTasks();

     
      final relevant = widget.siteId != null
          ? tasks // filter by siteId once TaskResponse exposes it
          : tasks;
      relevant.sort((a, b) => _statusOrder(a).compareTo(_statusOrder(b)));

      if (!mounted) return;
      setState(() {
        _tasks = relevant;
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  int _statusOrder(TaskResponse t) {
    if (t.completion > 0 && t.completion < 100) return 0; // in progress
    if (t.completion == 0) return 1; // pending
    return 2; // completed
  }

  void _applyFilter() {
    setState(() {
      _filtered = switch (_filter) {
        'pending' => _tasks.where((t) => t.completion == 0).toList(),
        'in_progress' =>
          _tasks.where((t) => t.completion > 0 && t.completion < 100).toList(),
        'completed' => _tasks.where((t) => t.completion >= 100).toList(),
        _ => List.of(_tasks),
      };
    });
  }

  double get _overallCompletion {
    if (_tasks.isEmpty) return 0;
    return _tasks.fold<int>(0, (sum, t) => sum + t.completion) /
        _tasks.length /
        100;
  }

  int get _completedCount =>
      _tasks.where((t) => t.completion >= 100).length;

  int get _inProgressCount =>
      _tasks.where((t) => t.completion > 0 && t.completion < 100).length;
      Future<void> _deleteTask(TaskResponse task) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.delete_outline, color: Colors.red),
          SizedBox(width: 8),
          Text("Delete Task",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            const TextSpan(text: "Are you sure you want to delete "),
            TextSpan(
              text: '"${task.title}"',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: "? This action cannot be undone."),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text("Cancel",
              style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Delete",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    await deleteTask(task.id);
    if (!mounted) return;
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
      _applyFilter();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('"${task.title}" deleted successfully'),
      backgroundColor: const Color(0xff1db954),
    ));
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to delete: ${e.toString()}'),
      backgroundColor: Colors.red,
    ));
  }
}

  @override
  Widget build(BuildContext context) {
    final title =
        widget.siteTitle != null ? "${widget.siteTitle} — Tasks" : "All Tasks";

    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: Column(
        children: [
          if (!_loading && _error == null && _tasks.isNotEmpty)
            _SummaryBar(
              total: _tasks.length,
              completed: _completedCount,
              inProgress: _inProgressCount,
              overallCompletion: _overallCompletion,
            ),

          if (!_loading && _error == null)
            _FilterBar(
              current: _filter,
              onChanged: (f) {
                _filter = f;
                _applyFilter();
              },
            ),

          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black))
                : _error != null
                    ? _ErrorState(error: _error!, onRetry: _load)
                    : _filtered.isEmpty
                        ? const _EmptyState()
                        : RefreshIndicator(
                            onRefresh: _load,
                            color: Colors.black,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 12, 16, 80),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                             itemBuilder: (context, i) {
                                final task = _filtered[i];
                                return TaskCardWidget(
                                  task: task,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => TaskDetailScreen(task: task),
                                    ),
                                  ),
                                  onDelete: () => _deleteTask(task), // ← pass delete callback
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }


class _SummaryBar extends StatelessWidget {
  final int total;
  final int completed;
  final int inProgress;
  final double overallCompletion;

  const _SummaryBar({
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.overallCompletion,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (overallCompletion * 100).round();
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Chip(label: "Total", value: "$total", color: Colors.white70),
              const SizedBox(width: 16),
              _Chip(
                  label: "Done",
                  value: "$completed",
                  color: const Color(0xff1db954)),
              const SizedBox(width: 16),
              _Chip(
                  label: "Active",
                  value: "$inProgress",
                  color: Colors.orange),
              const Spacer(),
              Text(
                "$percent%",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallCompletion,
              minHeight: 5,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xff1db954)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Chip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        Text(value,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
  }
}


class _FilterBar extends StatelessWidget {
  final String current;
  final ValueChanged<String> onChanged;

  const _FilterBar({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const filters = [
      ('all', 'All'),
      ('pending', 'Pending'),
      ('in_progress', 'In Progress'),
      ('completed', 'Completed'),
    ];
    return Container(
      height: 48,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: filters
            .map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f.$2),
                    selected: current == f.$1,
                    onSelected: (_) => onChanged(f.$1),
                    selectedColor: Colors.black,
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: current == f.$1
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide.none,
                  ),
                ))
            .toList(),
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.task_alt, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text("No tasks found",
              style: TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text("Failed to load tasks",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(error,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("Retry",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}