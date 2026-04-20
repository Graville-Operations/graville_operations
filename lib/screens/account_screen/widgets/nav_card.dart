import 'package:flutter/material.dart';

class NavigationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDanger;
  final bool showChevron;
  final bool isLast;

  const NavigationCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
    this.showChevron = true,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? const Color(0xFFE53E3E) : const Color(0xFF1A1A1A);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                )
              : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(
              children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
                if (showChevron)
                  const Icon(Icons.chevron_right,
                      size: 22, color: Color(0xFFBDBDBD)),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1, indent: 54, endIndent: 0, color: Color(0xFFE0E0E0)),
      ],
    );
  }
}
