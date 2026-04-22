import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/models/invoice/invoice_model.dart';
import 'package:graville_operations/services/api_service.dart';
import 'utils/invoice_utils.dart';
import 'widgets/invoice_status_badge.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final InvoiceModel invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late InvoiceModel _invoice;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
  }

  // Update Status 
  Future<void> _updateStatus(String newStatus) async {
    setState(() => _updating = true);
    final result = await ApiService.updateInvoiceStatus(_invoice.id, newStatus);
    setState(() => _updating = false);

    if (!mounted) return;

    if (result['success']) {
      setState(() {
        _invoice = InvoiceModel(
          id: _invoice.id,
          invoiceNumber: _invoice.invoiceNumber,
          lpoNumber: _invoice.lpoNumber,
          deliveryNumber: _invoice.deliveryNumber,
          supplierName: _invoice.supplierName,
          invoiceDate: _invoice.invoiceDate,
          totalAmount: _invoice.totalAmount,
          amountPaid: _invoice.amountPaid,
          balance: _invoice.balance,
          status: newStatus,
          site: _invoice.site,
          submittedBy: _invoice.submittedBy,
          submittedById: _invoice.submittedById,
          notes: _invoice.notes,
          createdAt: _invoice.createdAt,
          items: _invoice.items,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus'),
          backgroundColor: const Color(0xFF1B8A5A),
        ),
      );
      Navigator.pop(context, true); // signal list to refresh
    } else {
      _showError(result['message'] ?? 'Failed to update status');
    }
  }

  // Record Payment
  Future<void> _recordPayment() async {
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          'Record Payment',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance: ${formatInvoiceAmount(_invoice.balance)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Amount Paid',
                prefixText: 'KES ',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColor.primaryBackground, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final amount = double.tryParse(controller.text.trim());
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }
    if (amount > _invoice.balance) {
      _showError(
          'Amount exceeds balance of ${formatInvoiceAmount(_invoice.balance)}');
      return;
    }

    setState(() => _updating = true);
    final result =
        await ApiService.recordInvoicePayment(_invoice.id, amount);
    setState(() => _updating = false);

    if (!mounted) return;

    if (result['success']) {
      final updated = InvoiceModel.fromJson(result['data']);
      setState(() => _invoice = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Payment of ${formatInvoiceAmount(amount)} recorded successfully'),
          backgroundColor: const Color(0xFF1B8A5A),
        ),
      );
    } else {
      _showError(result['message'] ?? 'Failed to record payment');
    }
  }

  // Status Picker Bottom Sheet
  void _showStatusPicker() {
    const options = [
      'APPROVED',
      'PARTIALLY_PAID',
      'PAID',
      'REJECTED',
      'CANCELLED',
    ];

    const optionColors = {
      'APPROVED': Color(0xFF2563EB),
      'PARTIALLY_PAID': Color(0xFFD97706),
      'PAID': Color(0xFF1B8A5A),
      'REJECTED': Color(0xFFDC2626),
      'CANCELLED': Color(0xFF6B7280),
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Current: ${_invoice.status}',
              style:
                  const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            ...options.map((s) {
              final isCurrentStatus =
                  s == _invoice.status.toUpperCase();
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: optionColors[s],
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  s,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCurrentStatus
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isCurrentStatus
                        ? AppColor.primaryBackground
                        : const Color(0xFF111827),
                  ),
                ),
                trailing: isCurrentStatus
                    ? const Icon(Icons.check_rounded,
                        color: AppColor.primaryBackground, size: 18)
                    : null,
                onTap: isCurrentStatus
                    ? null
                    : () {
                        Navigator.pop(context);
                        _updateStatus(s);
                      },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    final paidPercent = _invoice.totalAmount > 0
        ? (_invoice.amountPaid / _invoice.totalAmount).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: Text(_invoice.invoiceNumber),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: _updating
          ? const LinearProgressIndicator(
              minHeight: 3,
              color: AppColor.primaryBackground,
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showStatusPicker,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Update Status'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.primaryBackground,
                          side: const BorderSide(
                              color: AppColor.primaryBackground),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _invoice.balance > 0 ? _recordPayment : null,
                        icon: const Icon(Icons.payments_outlined, size: 18),
                        label: const Text('Record Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBackground,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(paidPercent),
            const SizedBox(height: 16),

            _InvoiceSection(
              title: 'Invoice Details',
              icon: Icons.receipt_long_rounded,
              children: [
                _DetailRow(
                    label: 'Invoice No.', value: _invoice.invoiceNumber),
                _DetailRow(label: 'LPO No.', value: _invoice.lpoNumber),
                _DetailRow(
                    label: 'Delivery No.',
                    value: _invoice.deliveryNumber),
                _DetailRow(
                    label: 'Invoice Date',
                    value: formatInvoiceDate(_invoice.invoiceDate)),
                _DetailRow(
                    label: 'Received',
                    value: formatInvoiceDateTime(_invoice.createdAt)),
              ],
            ),
            const SizedBox(height: 12),

            _InvoiceSection(
              title: 'Supplier & Submission',
              icon: Icons.business_rounded,
              children: [
                _DetailRow(
                    label: 'Supplier', value: _invoice.supplierName),
                _DetailRow(
                    label: 'Submitted By',
                    value: _invoice.submittedBy ?? '—'),
                _DetailRow(label: 'Site', value: _invoice.site ?? '—'),
                if (_invoice.notes != null && _invoice.notes!.isNotEmpty)
                  _DetailRow(label: 'Notes', value: _invoice.notes!),
              ],
            ),
            const SizedBox(height: 12),

            if (_invoice.items.isNotEmpty) ...[
              _buildItemsSection(),
              const SizedBox(height: 12),
            ],

            _InvoiceSection(
              title: 'Payment Summary',
              icon: Icons.payments_rounded,
              children: [
                _DetailRow(
                  label: 'Total Amount',
                  value: formatInvoiceAmount(_invoice.totalAmount),
                  valueStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                _DetailRow(
                  label: 'Amount Paid',
                  value: formatInvoiceAmount(_invoice.amountPaid),
                  valueStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B8A5A),
                  ),
                ),
                _DetailRow(
                  label: 'Balance',
                  value: formatInvoiceAmount(_invoice.balance),
                  valueStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _invoice.balance > 0
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF1B8A5A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(double paidPercent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.primaryBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InvoiceStatusBadge(status: _invoice.status),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 12, color: Colors.white60),
                  const SizedBox(width: 4),
                  Text(
                    formatInvoiceDate(_invoice.invoiceDate),
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formatInvoiceAmount(_invoice.totalAmount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Total Invoice Amount',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: paidPercent,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(paidPercent * 100).toStringAsFixed(0)}% paid',
                style:
                    const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Text(
                '${((1 - paidPercent) * 100).toStringAsFixed(0)}% remaining',
                style:
                    const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PaymentChip(
                  label: 'Paid',
                  value: formatInvoiceAmount(_invoice.amountPaid),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PaymentChip(
                  label: 'Balance',
                  value: formatInvoiceAmount(_invoice.balance),
                  icon: Icons.account_balance_wallet_outlined,
                  dimmed: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return _InvoiceSection(
      title: 'Invoice Items (${_invoice.items.length})',
      icon: Icons.list_alt_rounded,
      children: [
        const Row(
          children: [
            Expanded(
                flex: 3,
                child:
                    Text('Particular', style: _headerStyle)),
            Expanded(
                flex: 1,
                child: Text('Qty',
                    textAlign: TextAlign.center,
                    style: _headerStyle)),
            Expanded(
                flex: 2,
                child: Text('Unit Price',
                    textAlign: TextAlign.center,
                    style: _headerStyle)),
            Expanded(
                flex: 2,
                child: Text('Total',
                    textAlign: TextAlign.right,
                    style: _headerStyle)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        ..._invoice.items.map((item) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(item.particular,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF111827))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          item.quantity % 1 == 0
                              ? item.quantity.toInt().toString()
                              : item.quantity.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'KES ${item.unitPrice.toStringAsFixed(0)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'KES ${item.totalPrice.toStringAsFixed(0)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                    height: 1, color: Color(0xFFF3F4F6)),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text(
                formatInvoiceAmount(_invoice.totalAmount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColor.primaryBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color(0xFF6B7280),
  );
}

//  Payment Chip

class _PaymentChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool dimmed;

  const _PaymentChip({
    required this.label,
    required this.value,
    required this.icon,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: dimmed ? Colors.white12 : Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: dimmed ? Colors.white54 : Colors.white70),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: dimmed ? Colors.white38 : Colors.white60,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dimmed ? Colors.white60 : Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Section Card

class _InvoiceSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InvoiceSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColor.primaryBackground),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// Detail Row

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow(
      {required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}