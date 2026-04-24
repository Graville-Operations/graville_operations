import 'package:flutter/material.dart';
import '../../../models/invoice/invoice_model.dart';
import '../utils/invoice_utils.dart';
import 'invoice_status_badge.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onTap;

  const InvoiceCard({super.key, required this.invoice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final paidPercent = invoice.totalAmount > 0
        ? (invoice.amountPaid / invoice.totalAmount).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice number + status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          invoice.invoiceNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      InvoiceStatusBadge(status: invoice.status),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Supplier
                  Row(
                    children: [
                      const Icon(Icons.business_rounded, size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          invoice.supplierName,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Site + date
                  Row(
                    children: [
                      if (invoice.site != null && invoice.site!.isNotEmpty) ...[
                        const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          invoice.site!,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        formatInvoiceDate(invoice.invoiceDate),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Submitted by
                  if (invoice.submittedBy != null && invoice.submittedBy!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.person_rounded, size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          invoice.submittedBy!,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),

                  // Amounts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AmountCol(label: 'Total', amount: invoice.totalAmount, color: const Color(0xFF111827)),
                      _AmountCol(
                        label: 'Balance',
                        amount: invoice.balance,
                        color: invoice.balance > 0 ? const Color(0xFFDC2626) : const Color(0xFF1B8A5A),
                        align: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment progress bar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              child: LinearProgressIndicator(
                value: paidPercent,
                backgroundColor: const Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(
                  invoiceStatusColor(invoice.status),
                ),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountCol extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final CrossAxisAlignment align;

  const _AmountCol({
    required this.label,
    required this.amount,
    required this.color,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        Text(
          formatInvoiceAmount(amount),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color),
        ),
      ],
    );
  }
}