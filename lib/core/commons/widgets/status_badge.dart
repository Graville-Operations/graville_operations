import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isPresent;
  const StatusBadge({super.key, required this.isPresent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPresent ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isPresent ? "Present" : "Absent",
        style: TextStyle(
          color: isPresent ? Colors.green.shade800 : Colors.orange.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}