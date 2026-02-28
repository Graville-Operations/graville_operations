import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T item) displayMapper;
  final dynamic Function(T item)? valueMapper;
  final void Function(T? newValue)? onChanged;
  final String? hint;
  final String? label;
  final bool isExpanded;
  final bool isDense;
  final Widget? prefixIcon;
  final InputBorder? border;
  final Color? fillColor;
  final double? elevation;
  final BorderRadius? borderRadius;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.displayMapper,
    this.value,
    this.valueMapper,
    this.onChanged,
    this.hint,
    this.label,
    this.isExpanded = true,
    this.isDense = true,
    this.prefixIcon,
    this.border,
    this.fillColor,
    this.elevation = 4,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // final effectiveValue = valueMapper != null && value != null
    //     ? valueMapper!(value as T)
    //     : value;

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: isExpanded,
      isDense: isDense,
      elevation: elevation!.toInt(),
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      hint: hint != null
          ? Text(hint!, style: TextStyle(color: Colors.grey.shade600))
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        filled: fillColor != null,
        fillColor: fillColor,
        border:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
        enabledBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
        focusedBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      items: items.map((T item) {
        final displayText = displayMapper(item);
       // final itemValue = valueMapper != null ? valueMapper!(item) : item;

        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayText,
            style: const TextStyle(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return items.map((T item) {
          final displayText = displayMapper(item);
          return Text(
            displayText,
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
    );
  }
}
