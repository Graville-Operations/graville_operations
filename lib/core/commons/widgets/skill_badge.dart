import 'package:flutter/material.dart';

class SkillBadge extends StatelessWidget {
  final String skillType;
  const SkillBadge({super.key, required this.skillType});

  @override
  Widget build(BuildContext context) {
    final isSkilled = skillType.toLowerCase() == 'skilled';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSkilled ? Colors.blue.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        skillType,
        style: TextStyle(
          color: isSkilled ? Colors.blue.shade800 : Colors.grey.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}