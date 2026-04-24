import 'package:flutter/material.dart';
import '../utils/invoice_utils.dart';

class InvoiceStatusBadge extends StatelessWidget {
  final String status;

  const InvoiceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: invoiceStatusBg(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(invoiceStatusIcon(status), size: 12, color: invoiceStatusColor(status)),
          const SizedBox(width: 4),
          Text(
            invoiceStatusLabel(status),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: invoiceStatusColor(status),
            ),
          ),
        ],
      ),
    );
  }
}