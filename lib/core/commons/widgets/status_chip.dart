import 'package:flutter/material.dart';
import 'package:graville_operations/models/project_status.dart';
//import '../../../models/project_status.dart';

class ProjectStatusChip extends StatelessWidget {
  final ProjectStatus status;
  const ProjectStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late String text;
    late Color bgColor;
    late Color textColor;
    late IconData icon;

    switch (status) {
      case ProjectStatus.onSchedule:
        text = "On Schedule";
        bgColor = const Color(0xffe8f7ee);
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;

      case ProjectStatus.ahead:
        text = "Ahead";
        bgColor = const Color(0xffe3f2fd);
        textColor = Colors.blue;
        icon = Icons.trending_up;
        break;

      case ProjectStatus.behind:
        text = "Behind";
        bgColor = const Color(0xffffebee);
        textColor = Colors.red;
        icon = Icons.warning;
        break;

      case ProjectStatus.completed:
        text = "Completed";
        bgColor = const Color(0xffede7f6);
        textColor = Colors.purple;
        icon = Icons.flag;
        break;

      case ProjectStatus.delayed:
        text = "Delayed";
        bgColor = const Color(0xfffff3e0);
        textColor = Colors.orange;
        icon = Icons.schedule;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
