import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime start, DateTime end) onRangeSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  // final String? hintText;

  const CustomDatePicker({
    super.key,
    required this.label,
    this.startDate,
    this.endDate,
    required this.onRangeSelected,
    this.firstDate,
    this.lastDate,
    // this.hintText = "Select rental period",
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime effectiveFirstDate;
  late DateTime effectiveLastDate;

  @override
  void initState() {
    super.initState();
    effectiveFirstDate = widget.firstDate ?? DateTime(2025);
    effectiveLastDate = widget.lastDate ?? DateTime(2035);
  }

  String _formatRange() {
    // if (widget.startDate == null || widget.endDate == null) {
    //   return widget.hintText!;
    // }
    final formatter = DateFormat('yyyy-MM-dd');
    return "${formatter.format(widget.startDate!)} → ${formatter.format(widget.endDate!)}";
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = widget.startDate != null && widget.endDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),

        // Using CustomButton with Outlined style (similar to your example)
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            label: hasValue ? _formatRange(): "Select rental period",
            onPressed: () async {
              final DateTimeRange? pickedRange = await showDateRangePicker(
                context: context,
                firstDate: effectiveFirstDate,
                lastDate: effectiveLastDate,
                initialDateRange: hasValue
                    ? DateTimeRange(start: widget.startDate!, end: widget.endDate!)
                    : null,
              );

              if (pickedRange != null) {
                widget.onRangeSelected(pickedRange.start, pickedRange.end);
              }
            },
            buttonStyle: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              backgroundColor: Colors.white,
              foregroundColor: hasValue ? Colors.black87 : Colors.grey.shade600,
            ),
            // Optional: You can pass an icon if your CustomButton supports it
            icon: const Icon(Icons.date_range, size: 22),
          ),
        ),
      ],
    );
  }
}