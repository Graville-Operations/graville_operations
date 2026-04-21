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
                    child: _Badge(label: _statusLabel, color: _statusColor),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Completion card ──────────────────────────────
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
                              fontSize: 16,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            "${task.completion}%",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_progressColor),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Description ──────────────────────────────────
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
                            fontSize: 16,
                            letterSpacing: 0.3,
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

                // ── Details card ─────────────────────────────────
                _DetailCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _InfoRow(
                        icon: Icons.confirmation_number_outlined,
                        label: "Task ID",
                        value: "${task.id}",
                        boldValue: true,
                      ),
                      const Divider(height: 20),

                      // Created date
                      _InfoRow(
                        icon: Icons.access_time_outlined,
                        label: "Created",
                        value:
                            "${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}",
                        boldValue: true,
                      ),

                      // Field Operator
                      if (task.fieldOperator != null) ...[
                        const Divider(height: 20),
                        _InfoRow(
                          icon: Icons.engineering_outlined,
                          label: "Field Operator",
                          value: task.fieldOperator!.fullName,
                          boldValue: true,
                        ),
                      ],

                      // Assigned Workers
                      const Divider(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.people_outline,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 10),
                          const Text(
                            "Assigned To",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${task.assignedTo.length} worker${task.assignedTo.length == 1 ? '' : 's'}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xff5b7cfa),
                            ),
                          ),
                        ],
                      ),

                      if (task.assignedTo.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ...task.assignedTo.map(
                          (w) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xff5b7cfa)
                                      .withOpacity(0.12),
                                  child: Text(
                                    w.firstName.isNotEmpty
                                        ? w.firstName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff5b7cfa),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        w.fullName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold, // ← name bolded
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        w.skillType,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: w.skillType.toLowerCase() == 'skilled'
                                        ? const Color(0xff1db954).withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    w.skillType,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600, // ← skill badge bolded
                                      color: w.skillType.toLowerCase() == 'skilled'
                                          ? const Color(0xff1db954)
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

// ── Shared sub-widgets ──────────────────────────────────────────────────────

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
  final bool boldValue;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.boldValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: boldValue ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}