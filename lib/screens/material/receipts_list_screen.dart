import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/receipt_record.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
import 'package:graville_operations/services/receive_material_service.dart';

class ReceiptsListScreen extends StatefulWidget {
  const ReceiptsListScreen({super.key});

  @override
  State<ReceiptsListScreen> createState() => _ReceiptsListScreenState();
}

class _ReceiptsListScreenState extends State<ReceiptsListScreen> {
  List<ReceiptRecord> _all      = [];
  List<ReceiptRecord> _filtered = [];
  bool    _loading = true;
  String  _search  = '';
  String? _sourceFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await ReceiveMaterialService.fetchReceipts();
    if (mounted) {
      setState(() {
        _all      = data;
        _filtered = data;
        _loading  = false;
      });
    }
  }

  void _applyFilters(String query, String? sourceFilter) {
    final q = query.toLowerCase();
    setState(() {
      _search       = query;
      _sourceFilter = sourceFilter;
      _filtered     = _all.where((r) {
        final matchSearch =
            (r.materialName ?? '').toLowerCase().contains(q) ||
            (r.supplierName ?? '').toLowerCase().contains(q) ||
            (r.fromSiteName ?? '').toLowerCase().contains(q) ||
            (r.category     ?? '').toLowerCase().contains(q);
        final matchSource =
            sourceFilter == null || r.sourceType == sourceFilter;
        return matchSearch && matchSource;
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
                Icon(Icons.inventory, color: Colors.blue, size: 22),
                SizedBox(width: 8),
                Text('Received Materials',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black54),
                onPressed: _load,
                tooltip: 'Refresh',
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(108),
              child: Column(
                children: [
                  // Search
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      onChanged: (q) => _applyFilters(q, _sourceFilter),
                      decoration: InputDecoration(
                        hintText: 'Search material, supplier, site...',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  // Filter chips
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Row(children: [
                      _FilterChip(
                        label: 'All',
                        selected: _sourceFilter == null,
                        color: Colors.blue,
                        onTap: () => _applyFilters(_search, null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Supplier',
                        selected: _sourceFilter == 'SUPPLIER',
                        color: Colors.blue,
                        onTap: () => _applyFilters(_search, 'SUPPLIER'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'From Site',
                        selected: _sourceFilter == 'SITE',
                        color: Colors.orange,
                        onTap: () => _applyFilters(_search, 'SITE'),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
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
                      _search.isEmpty && _sourceFilter == null
                          ? 'No receipts yet'
                          : 'No results found',
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
                  (context, index) => _ReceiptCard(
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
          final received = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
                builder: (_) => const ReceiveMaterialScreen()),
          );
          if (received == true) _load();
        },
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Receive Material',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showDetail(BuildContext context, ReceiptRecord r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReceiptDetailSheet(record: r),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final ReceiptRecord record;
  final VoidCallback onTap;
  const _ReceiptCard({required this.record, required this.onTap});

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context) {
    final isFromSite  = record.isFromSite;
    final sourceColor = isFromSite ? Colors.orange : Colors.blue;
    final sourceLabel = isFromSite
        ? (record.fromSiteName ?? 'Site')
        : (record.supplierName ?? 'Supplier');
    final sourceIcon  = isFromSite
        ? Icons.location_city_outlined
        : Icons.storefront_outlined;

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
        child: Column(children: [
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
                        record.materialName ?? 'Unknown Material',
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
                if (record.receivedAt != null)
                  Text(
                    _fmtDate(record.receivedAt!),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade400),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(children: [
              Icon(sourceIcon, size: 14, color: sourceColor),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: sourceColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isFromSite ? 'From Site' : 'Supplier',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: sourceColor),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(sourceLabel,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Row(children: [
              _Chip(
                icon: Icons.numbers,
                label: '${record.quantityReceived} ${record.unit ?? ''}',
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _Chip(
                icon: Icons.monetization_on_outlined,
                label: 'KES ${record.amountPaid.toStringAsFixed(0)}',
                color: Colors.orange,
              ),
            ]),
          ),
        ]),
      ),
    );
  }
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
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color)),
      ]),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.12)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.grey)),
      ),
    );
  }
}

class _ReceiptDetailSheet extends StatelessWidget {
  final ReceiptRecord record;
  const _ReceiptDetailSheet({required this.record});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize:     0.4,
      maxChildSize:     0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              const Icon(Icons.receipt_long_outlined,
                  color: Colors.blue, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.materialName ?? 'Receipt #${record.id}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              Text('#${record.id}',
                  style: TextStyle(
                      color: Colors.grey.shade400, fontSize: 13)),
            ]),
          ),
          const Divider(height: 24),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (record.photoUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      record.photoUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _Row('Material',     record.materialName ?? '—'),
                _Row('Category',     record.category     ?? '—'),
                _Row('Unit',         record.unit         ?? '—'),
                _Row('Qty Received', '${record.quantityReceived}'),
                _Row('Amount Paid',
                    'KES ${record.amountPaid.toStringAsFixed(2)}'),
                _Row('Source',
                    record.isFromSite ? 'Another Site' : 'Supplier'),
                if (record.isFromSite)
                  _Row('From Site', record.fromSiteName ?? '—')
                else
                  _Row('Supplier',  record.supplierName ?? '—'),
                _Row('Notes', record.notes ?? '—'),
                _Row('Date',
                    record.receivedAt != null
                        ? '${record.receivedAt!.day}/'
                          '${record.receivedAt!.month}/'
                          '${record.receivedAt!.year}'
                        : '—'),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ]),
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