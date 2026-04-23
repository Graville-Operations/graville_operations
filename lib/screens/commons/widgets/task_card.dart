import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';

class TaskCardWidget extends StatefulWidget {
  final TaskResponse task;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  bool _selected = false;

  Color get _progressColor {
    if (widget.task.completion >= 100) return const Color(0xff1db954);
    if (widget.task.completion >= 60) return Colors.orange;
    return const Color(0xff5b7cfa);
  }

  String get _statusLabel {
    if (widget.task.completion >= 100) return 'Completed';
    if (widget.task.completion > 0) return 'In Progress';
    return 'Pending';
  }

  Color get _statusColor {
    if (widget.task.completion >= 100) return const Color(0xff1db954);
    if (widget.task.completion > 0) return Colors.orange;
    return Colors.grey;
  }

  void _onLongPress() {
    HapticFeedback.mediumImpact();
    setState(() => _selected = true);
  }

  void _onTap() {
    if (_selected) {
      // tapping card body deselects
      setState(() => _selected = false);
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      onLongPress: _onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _selected ? const Color(0xfffef3f2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selected ? Colors.red.shade300 : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _selected
                  ? Colors.red.withOpacity(0.08)
                  : Colors.black.withOpacity(0.05),
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
              // Title + status badge + delete button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ── Show delete button when selected, badge otherwise
                  if (_selected)
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.delete_outline,
                                color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
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
              if (widget.task.description != null &&
                  widget.task.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.task.description!,
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
                        value: widget.task.completion / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade100,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_progressColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.task.completion}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _progressColor,
                    ),
                  ),
                ],
              ),

              // Footer
              const SizedBox(height: 10),
              Row(
                children: [
                  if (widget.task.assignedTo.isNotEmpty) ...[
                    const Icon(Icons.people_outline,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "${widget.task.assignedTo.length} assigned",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                  const Spacer(),
                  if (_selected)
                    const Text(
                      "Tap card to deselect",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else ...[
                    const Icon(Icons.calendar_today_outlined,
                        size: 11, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(
                      "${widget.task.createdAt.day}/${widget.task.createdAt.month}/${widget.task.createdAt.year}",
                      style:
                          const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right,
                        size: 16, color: Colors.grey),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}