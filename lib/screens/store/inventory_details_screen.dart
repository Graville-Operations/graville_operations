import 'package:flutter/material.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/store/update_inventory.dart';
class InventoryDetailScreen extends StatelessWidget {
  final InventoryModel item;

  const InventoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              final updated = await context.push(
                UpdateInventoryScreen(preSelectedItem: item),
              );
              if (updated == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.remove_circle_outline,
                color: Colors.red, size: 18),
            label: const Text(
              'Subtract',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getMaterialIcon(item.name),
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No image available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: item.quantity > 10
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: item.quantity > 10
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item.quantity > 10
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_outlined,
                    color: item.quantity > 10
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.quantity > 10
                        ? 'In Stock — ${item.quantity} ${item.unit} available'
                        : 'Low Stock — only ${item.quantity} ${item.unit} remaining',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: item.quantity > 10
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'MATERIAL DETAILS',
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Material Name',
                    value: item.name,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    icon: Icons.category_outlined,
                    label: 'Category',
                    value: item.category.isNotEmpty
                        ? item.category
                        : '—',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    icon: Icons.straighten_outlined,
                    label: 'Unit Type',
                    value: item.unit.isNotEmpty ? item.unit : '—',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'STOCK INFORMATION',
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.numbers_outlined,
                    label: 'Current Quantity',
                    value: '${item.quantity} ${item.unit}',
                    valueColor: item.quantity > 10
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    icon: Icons.attach_money_outlined,
                    label: 'Unit Price',
                    value: item.unitPrice > 0
                        ? 'KES ${item.unitPrice.toStringAsFixed(2)}'
                        : '—',
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    icon: Icons.calculate_outlined,
                    label: 'Total Value',
                    value: item.unitPrice > 0
                        ? 'KES ${(item.quantity * item.unitPrice).toStringAsFixed(2)}'
                        : '—',
                    valueColor: Colors.blue.shade700,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'DESCRIPTION',
              child: _buildDetailRow(
                icon: Icons.notes_outlined,
                label: 'Notes',
                value: item.description.isNotEmpty
                    ? item.description
                    : 'No description provided.',
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getMaterialIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('cement')) return Icons.view_in_ar;
    if (lower.contains('steel') || lower.contains('rod')) return Icons.adjust;
    if (lower.contains('sand')) return Icons.grid_on;
    if (lower.contains('brick')) return Icons.layers;
    if (lower.contains('paint')) return Icons.format_paint;
    if (lower.contains('pipe')) return Icons.plumbing;
    if (lower.contains('wire') || lower.contains('cable')) return Icons.cable;
    if (lower.contains('wood') || lower.contains('timber')) return Icons.forest;
    return Icons.inventory_2_outlined;
  }
}