import 'package:flutter/material.dart';

/// Column header that shows a sort indicator and toggles sort on tap.
class SortableColumnLabel extends StatelessWidget {
  final String text;
  final String field;
  final String currentSortBy;
  final String currentOrder;
  final void Function(String field, String order) onSort;

  const SortableColumnLabel({
    super.key,
    required this.text,
    required this.field,
    required this.currentSortBy,
    required this.currentOrder,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentSortBy == field;
    final nextOrder = (isActive && currentOrder == 'asc') ? 'desc' : 'asc';

    return InkWell(
      onTap: () => onSort(field, nextOrder),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.blue : Colors.black87,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            isActive
                ? (currentOrder == 'asc' ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: 14,
            color: isActive ? Colors.blue : Colors.grey[400],
          ),
        ],
      ),
    );
  }
}

/// Chip showing an active filter with a remove button.
class FilterPill extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FilterPill({super.key, required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: Colors.blue[600]),
          ),
        ],
      ),
    );
  }
}

/// Toggle chip for sort order selection in the bottom sheet.
class OrderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const OrderChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}