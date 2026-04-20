import 'package:flutter/material.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskResponse task;

  const TaskDetailScreen({super.key, required this.task});

  Color get _progressColor {
    if (task.completion >= 100) return const Color(0xff1db954);
    if (task.completion >= 60) return Colors.orange;
    return const Color(0xff5b7cfa);
  }

  String get _statusLabel {
    if (task.completion >= 100) return 'Completed';
    if (task.completion > 0) return 'In Progress';
    return 'Pending';
  }

  Color get _statusColor {
    if (task.completion >= 100) return const Color(0xff1db954);
    if (task.completion > 0) return Colors.orange;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      body: CustomScrollView(
        slivers: [
          // ── App bar ───────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            expandedHeight: 170,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Text(
                task.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff1a1a2e), Color(0xff16213e)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: _Badge(
                      label: _statusLabel,
                      color: _statusColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Completion card
                _DetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Completion",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${task.completion}%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: _progressColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: task.completion / 100,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _progressColor),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                if (task.description != null &&
                    task.description!.isNotEmpty) ...[
                  _DetailCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          task.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Details
                _DetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.tag,
                        label: "Task ID",
                        value: "#${task.id}",
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        icon: Icons.people_outline,
                        label: "Assigned To",
                        value: task.assignedTo.isEmpty
                            ? "—"
                            : "${task.assignedTo.length} worker${task.assignedTo.length == 1 ? '' : 's'}",
                      ),
                      if (task.fieldOperatorId != null) ...[
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.engineering_outlined,
                          label: "Field Operator",
                          value: "ID ${task.fieldOperatorId}",
                        ),
                      ],
                      const Divider(height: 20),
                      _InfoRow(
                        icon: Icons.access_time_outlined,
                        label: "Created",
                        value:
                            "${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ───────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Widget child;
  const _DetailCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}