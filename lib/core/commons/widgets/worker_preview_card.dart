import 'package:flutter/material.dart';
import 'package:graville_operations/application/custom_navigator.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';
import 'package:graville_operations/services/attendance_service.dart';

class WorkerPreviewCard extends StatelessWidget {
  final int index;
  final AttendanceWorkerSummary worker;

  const WorkerPreviewCard({
    super.key,
    required this.index,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(const WorkersScreen()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text('${index + 1}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF7A7E8E))),
            ),
            Expanded(
              child: Text(worker.name,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F1117))),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                worker.skillType,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A5CFF)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}