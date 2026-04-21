import 'package:flutter/material.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskResponse task;
  final VoidCallback onTap;

  const TaskCardWidget({super.key, required this.task, required this.onTap});

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + status badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel,
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Description preview
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  task.description!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Progress bar + percentage
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: task.completion / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade100,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_progressColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${task.completion}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _progressColor,
                    ),
                  ),
                ],
              ),

              // Footer: assigned count + created date
              const SizedBox(height: 10),
              Row(
                children: [
                  if (task.assignedTo.isNotEmpty) ...[
                    const Icon(Icons.people_outline,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${task.assignedTo.length} assigned",
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                  const Spacer(),
                  const Icon(Icons.calendar_today_outlined,
                      size: 11, color: Colors.grey),
                  const SizedBox(width: 3),
                  Text(
                    "${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right,
                      size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}