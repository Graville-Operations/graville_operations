import 'package:flutter/material.dart';

Color invoiceStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'PAID':
      return const Color(0xFF1B8A5A);
    case 'PARTIALLY_PAID':
      return const Color(0xFFD97706);
    case 'APPROVED':
      return const Color(0xFF2563EB);
    case 'REJECTED':
      return const Color(0xFFDC2626);
    case 'CANCELLED':
      return const Color(0xFF6B7280);
    case 'PENDING':
    default:
      return const Color(0xFF7C3AED);
  }
}

Color invoiceStatusBg(String status) =>
    invoiceStatusColor(status).withOpacity(0.10);

String invoiceStatusLabel(String status) {
  switch (status.toUpperCase()) {
    case 'PAID':
      return 'Paid';
    case 'PARTIALLY_PAID':
      return 'Partially Paid';
    case 'APPROVED':
      return 'Approved';
    case 'REJECTED':
      return 'Rejected';
    case 'CANCELLED':
      return 'Cancelled';
    case 'PENDING':
    default:
      return 'Pending';
  }
}

IconData invoiceStatusIcon(String status) {
  switch (status.toUpperCase()) {
    case 'PAID':
      return Icons.check_circle_rounded;
    case 'PARTIALLY_PAID':
      return Icons.timelapse_rounded;
    case 'APPROVED':
      return Icons.verified_rounded;
    case 'REJECTED':
      return Icons.cancel_rounded;
    case 'CANCELLED':
      return Icons.remove_circle_rounded;
    case 'PENDING':
    default:
      return Icons.hourglass_top_rounded;
  }
}

String formatInvoiceDate(String? raw) {
  if (raw == null || raw.isEmpty) return '—';
  try {
    final dt = DateTime.parse(raw);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  } catch (_) {
    return raw;
  }
}

String formatInvoiceDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return '—';
  try {
    final dt = DateTime.parse(raw).toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  } catch (_) {
    return raw;
  }
}

String formatInvoiceAmount(double amount) {
  final parts = amount.toStringAsFixed(2).split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  return 'KES $intPart.${parts[1]}';
}