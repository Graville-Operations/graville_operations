import 'package:flutter/material.dart';

class TaskProgress extends StatelessWidget {
  final String title;
  final double percent;
  final Color color;
  const TaskProgress({
    super.key,
    required this.title,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(title),
            const Spacer(),
            Text("${(percent * 100).toInt()}%"),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation(color),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
