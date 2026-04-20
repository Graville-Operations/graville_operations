import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final IconData? icon;
  final bool required;
  const FormSection({
    super.key,
    required this.child,
    this.icon,
    this.required = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.titleSmall!.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade800,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.blue),
                SizedBox(width: 8),
              ],
              if (title != null) Text(title!, style: labelStyle),
              if (required)
                Text(
                  " *",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
