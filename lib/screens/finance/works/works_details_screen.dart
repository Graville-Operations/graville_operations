import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/models/works/pick_record_model.dart';

class WorksDetailScreen extends StatelessWidget {
  final PickRecordModel pick;

  const WorksDetailScreen({super.key, required this.pick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: Text(pick.refId),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Hero card
            _buildHeroCard(),
            const SizedBox(height: 16),

            // ─── Pick details
            _buildSection(
              title: 'Pick Details',
              icon: Icons.upload_rounded,
              children: [
                _DetailRow(label: 'Company', value: pick.company),
                _DetailRow(label: 'Site', value: pick.siteName),
                _DetailRow(label: 'Work Type', value: pick.workType),
                _DetailRow(
                    label: 'Submitted By',
                    value: pick.submittedBy ?? '—'),
                _DetailRow(
                    label: 'Picked On',
                    value: _formatDateTime(pick.createdAt)),
                if (pick.notes != null && pick.notes!.isNotEmpty)
                  _DetailRow(label: 'Notes', value: pick.notes!),
              ],
            ),
            const SizedBox(height: 12),

            // ─── Materials
            _buildMaterialsSection(),
            const SizedBox(height: 12),

            // ─── Drop details (if delivered)
            if (pick.status.toUpperCase() == 'DELIVERED') ...[
              _buildSection(
                title: 'Drop Details',
                icon: Icons.download_rounded,
                children: [
                  _DetailRow(
                      label: 'Dropped By',
                      value: pick.droppedBy ?? '—'),
                  _DetailRow(
                      label: 'Dropped On',
                      value: _formatDateTime(pick.droppedAt)),
                ],
              ),
              const SizedBox(height: 12),

              // ─── Drop photo
              if (pick.dropPhotoUrl != null)
                _buildPhotoSection(
                  title: 'Drop Photo',
                  url: pick.dropPhotoUrl!,
                ),
              const SizedBox(height: 12),
            ],

            // ─── Vehicle photo
            if (pick.vehiclePhotoUrl != null) ...[
              _buildPhotoSection(
                title: 'Vehicle Photo',
                url: pick.vehiclePhotoUrl!,
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    final statusColor = switch (pick.status.toUpperCase()) {
      'PENDING' => const Color(0xFF7C3AED),
      'DELIVERED' => const Color(0xFF1B8A5A),
      'CANCELLED' => const Color(0xFF6B7280),
      _ => const Color(0xFF6B7280),
    };

    final typeColor = pick.isInternal
        ? const Color(0xFF2563EB)
        : const Color(0xFFD97706);

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
          // ─── Type + status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pick.workType,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: typeColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pick.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Company
          Text(
            pick.company,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 13, color: Colors.white60),
              const SizedBox(width: 4),
              Text(
                pick.siteName,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Ref + items count chips
          Row(
            children: [
              _HeroChip(
                icon: Icons.tag_rounded,
                label: pick.refId,
              ),
              const SizedBox(width: 10),
              _HeroChip(
                icon: Icons.inventory_2_outlined,
                label:
                    '${pick.items.length} item${pick.items.length == 1 ? '' : 's'}',
              ),
              if (pick.isExternal && pick.totalAmount != null) ...[
                const SizedBox(width: 10),
                _HeroChip(
                  icon: Icons.payments_outlined,
                  label:
                      'KES ${pick.totalAmount!.toStringAsFixed(0)}',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsSection() {
    return _buildSection(
      title: 'Materials (${pick.items.length})',
      icon: Icons.inventory_2_rounded,
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                  flex: 3,
                  child: Text('Material', style: _headerStyle)),
              const Expanded(
                  flex: 1,
                  child: Text('Qty',
                      textAlign: TextAlign.center,
                      style: _headerStyle)),
              if (pick.isExternal) ...[
                const Expanded(
                    flex: 2,
                    child: Text('Unit Price',
                        textAlign: TextAlign.center,
                        style: _headerStyle)),
                const Expanded(
                    flex: 2,
                    child: Text('Total',
                        textAlign: TextAlign.right,
                        style: _headerStyle)),
              ],
            ],
          ),
          const Divider(height: 12),

          // Rows
          ...pick.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(item.materialName,
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
                    if (pick.isExternal) ...[
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.unitPrice != null
                              ? 'KES ${item.unitPrice!.toStringAsFixed(0)}'
                              : '—',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.totalPrice != null
                              ? 'KES ${item.totalPrice!.toStringAsFixed(0)}'
                              : '—',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBackground,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )),

          // Total row for external
          if (pick.isExternal && pick.totalAmount != null) ...[
            const Divider(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827))),
                Text(
                  'KES ${pick.totalAmount!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryBackground,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoSection(
      {required String title, required String url}) {
    return _buildSection(
      title: title,
      icon: Icons.camera_alt_rounded,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 200,
            color: const Color(0xFFF5F6F8),
            child: const Center(
              child: Icon(Icons.broken_image_outlined,
                  size: 40, color: Color(0xFF9CA3AF)),
            ),
          ),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              height: 200,
              color: const Color(0xFFF5F6F8),
              child: const Center(
                child: CircularProgressIndicator(
                    color: AppColor.primaryBackground),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    List<Widget>? children,
    Widget? child,
  }) {
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
                Icon(icon,
                    size: 16, color: AppColor.primaryBackground),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827))),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: child ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children ?? [],
                ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: Color(0xFF6B7280),
  );
}


class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}