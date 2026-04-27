import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/transfer_record.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';
import 'package:graville_operations/services/transfer_material_service.dart';

class TransfersListScreen extends StatefulWidget {
  const TransfersListScreen({super.key});

  @override
  State<TransfersListScreen> createState() => _TransfersListScreenState();
}

class _TransfersListScreenState extends State<TransfersListScreen> {
  List<TransferRecord> _all     = [];
  List<TransferRecord> _filtered = [];
  bool   _loading = true;
  String _search  = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await TransferMaterialService.fetchTransfers();
    if (mounted) {
      setState(() {
        _all      = data;
        _filtered = data;
        _loading  = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _search = query.toLowerCase();
      _filtered = _all.where((t) {
        return (t.material      ?? '').toLowerCase().contains(_search) ||
               (t.toSite        ?? '').toLowerCase().contains(_search) ||
               (t.fromSite      ?? '').toLowerCase().contains(_search) ||
               (t.transportMode ?? '').toLowerCase().contains(_search) ||
               (t.driverDetails ?? '').toLowerCase().contains(_search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            title: Row(
              children: const [
                Icon(Icons.swap_horiz_rounded, color: Colors.blue, size: 22),
                SizedBox(width: 8),
                Text(
                  'Material Transfers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.refresh, color: Colors.black54),
            //     onPressed: _load,
            //     tooltip: 'Refresh',
            //   ),
            // ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: 'Search material, site, driver...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (!_loading)
            SliverToBoxAdapter(
              child: _SummaryStrip(transfers: _filtered),
            ),

          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      _search.isEmpty
                          ? 'No transfers yet'
                          : 'No results for "$_search"',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 15),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _TransferCard(
                    record: _filtered[index],
                    onTap: () => _showDetail(context, _filtered[index]),
                  ),
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const TransferMaterialScreen(),
            ),
          );
          if (created == true) _load();
        },
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Transfer',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showDetail(BuildContext context, TransferRecord r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TransferDetailSheet(record: r),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  final List<TransferRecord> transfers;
  const _SummaryStrip({required this.transfers});

  @override
  Widget build(BuildContext context) {
    final totalValue = transfers.fold<double>(0, (s, t) => s + t.totalValue);
    final totalQty   = transfers.fold<double>(0, (s, t) => s + t.quantity);

    return Container(
      //color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      margin: const EdgeInsets.only(bottom: 4),
    );
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000)    return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _Stat(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: color)),
                  Text(label,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransferCard extends StatelessWidget {
  final TransferRecord record;
  final VoidCallback onTap;
  const _TransferCard({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.inventory_2_outlined,
                        color: Colors.blue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.material ?? 'Unknown Material',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        if (record.category != null) ...[
                          const SizedBox(height: 2),
                          Text(record.category!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500)),
                        ],
                      ],
                    ),
                  ),
                  // Date
                  if (record.transferDate != null)
                    Text(
                      _fmtDate(record.transferDate!),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.green.shade400),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      record.fromSite ?? '—',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward,
                        size: 14, color: Colors.grey),
                  ),
                  Icon(Icons.location_on, size: 14, color: Colors.red.shade300),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      record.toSite ?? '—',
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              child: Row(
                children: [
                  _Chip(
                    icon: Icons.shopping_cart,
                    label:
                        '${record.quantity} ${record.materialUnit ?? ''}',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 60),
                  _Chip(
                    icon: Icons.money,
                    label: 'KSH ${record.totalValue.toStringAsFixed(0)}',
                    color: Colors.blue,
                  ),
                  if (record.transportMode != null) ...[
                    const SizedBox(width:60),
                    _Chip(
                      icon: Icons.local_shipping_outlined,
                      label: record.transportMode!,
                      color: Colors.blue,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}

class _TransferDetailSheet extends StatelessWidget {
  final TransferRecord record;
  const _TransferDetailSheet({required this.record});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz_rounded,
                      color: Colors.blue, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.material ?? 'Transfer #${record.id}',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            // Scrollable detail rows
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (record.image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        base64Decode(record.image!),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _Row('Material',      record.material      ?? '—'),
                  _Row('Category',      record.category      ?? '—'),
                  _Row('From Site',     record.fromSite      ?? '—'),
                  _Row('To Site',       record.toSite        ?? '—'),
                  _Row('Quantity',
                      '${record.quantity} ${record.materialUnit ?? ''}'),
                  _Row('Price / Unit',
                      'KES ${record.pricePerUnit.toStringAsFixed(2)}'),
                  _Row('Total Value',
                      'KES ${record.totalValue.toStringAsFixed(2)}'),
                  _Row('Transport',     record.transportMode ?? '—'),
                  _Row('Driver',        record.driverDetails ?? '—'),
                  _Row('Notes',         record.notes         ?? '—'),
                  _Row('Date',
                      record.transferDate != null
                          ? '${record.transferDate!.day}/'
                            '${record.transferDate!.month}/'
                            '${record.transferDate!.year}'
                          : '—'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}