import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayChip extends StatelessWidget {
  final DateTime date;
  final bool isActive;
  final VoidCallback onTap;

  const DayChip({
    super.key,
    required this.date,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1A5CFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF1A5CFF) : Colors.black.withOpacity(0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF0F1117),
              ),
            ),
            Text(
              DateFormat('d').format(date),
              style: TextStyle(
                fontSize: 10,
                color: isActive ? Colors.white60 : const Color(0xFF7A7E8E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}