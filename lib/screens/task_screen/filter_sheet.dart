import 'package:flutter/material.dart';
import 'package:graville_operations/screens/task_screen/task_widget.dart';
import 'package:graville_operations/screens/task_screen/worker.dart';


const List<String> kSortableFields = [
  'id',
  'first_name',
  'last_name',
  'joined_date',
  'amount',
  'skill_type',
];

const Map<String, String> kSortFieldLabels = {
  'id': 'ID',
  'first_name': 'First Name',
  'last_name': 'Last Name',
  'joined_date': 'Joined Date',
  'amount': 'Amount',
  'skill_type': 'Skill Type',
};

/// Shows the sort & filter bottom sheet and calls [onApply] with the result.
void showSortFilterSheet({
  required BuildContext context,
  required WorkerFilterParams currentParams,
  required void Function(WorkerFilterParams) onApply,
  required VoidCallback onReset,
}) {
  String tempSortBy = currentParams.sortBy;
  String tempOrder = currentParams.order;
  final skillFilterController =
      TextEditingController(text: currentParams.skill ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort & Filter Workers',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),

              // Skill filter
              const Text(
                'Filter by Skill Type',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: skillFilterController,
                decoration: InputDecoration(
                  hintText: 'e.g. electrician, plumber…',
                  prefixIcon: const Icon(Icons.construction, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12,
                  ),
                  suffixIcon: skillFilterController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            skillFilterController.clear();
                            setModalState(() {});
                          },
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              // Sort field chips
              const Text(
                'Sort By',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kSortableFields.map((field) {
                  final selected = tempSortBy == field;
                  return ChoiceChip(
                    label: Text(
                      kSortFieldLabels[field] ?? field,
                      style: TextStyle(
                        fontSize: 12,
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: selected,
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.grey[100],
                    onSelected: (_) =>
                        setModalState(() => tempSortBy = field),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Sort order
              const Text(
                'Order',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OrderChip(
                    label: 'Ascending',
                    icon: Icons.arrow_upward,
                    selected: tempOrder == 'asc',
                    onTap: () => setModalState(() => tempOrder = 'asc'),
                  ),
                  const SizedBox(width: 10),
                  OrderChip(
                    label: 'Descending',
                    icon: Icons.arrow_downward,
                    selected: tempOrder == 'desc',
                    onTap: () => setModalState(() => tempOrder = 'desc'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onReset();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        final skill = skillFilterController.text.trim();
                        final updated = currentParams.copyWith(
                          sortBy: tempSortBy,
                          order: tempOrder,
                          skill: skill.isNotEmpty ? skill : null,
                          clearSkill: skill.isEmpty,
                          offset: 0,
                        );
                        onApply(updated);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}