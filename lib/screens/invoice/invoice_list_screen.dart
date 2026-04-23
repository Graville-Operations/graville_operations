import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/models/invoice/invoice_model.dart';
import 'package:graville_operations/services/api_service.dart';
import 'widgets/invoice_card.dart';
import 'invoice_detail_screen.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<InvoiceModel> _all = [];
  List<InvoiceModel> _filtered = [];
  bool _loading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _selectedStatus = 'ALL';
  Timer? _debounce;

  static const _statuses = [
    'ALL', 'PENDING', 'APPROVED', 'PARTIALLY_PAID', 'PAID', 'REJECTED', 'CANCELLED'
  ];

  static const _statusLabels = {
    'ALL': 'All',
    'PENDING': 'Pending',
    'APPROVED': 'Approved',
    'PARTIALLY_PAID': 'Partial',
    'PAID': 'Paid',
    'REJECTED': 'Rejected',
    'CANCELLED': 'Cancelled',
  };

  static const _statusColors = {
    'ALL': AppColor.primary,
    'PENDING': Color(0xFF7C3AED),
    'APPROVED': Color(0xFF2563EB),
    'PARTIALLY_PAID': Color(0xFFD97706),
    'PAID': Color(0xFF1B8A5A),
    'REJECTED': Color(0xFFDC2626),
    'CANCELLED': Color(0xFF6B7280),
  };

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await ApiService.getAllInvoices();
      if (result['success']) {
        final data = result['data'] as List<dynamic>;
        final invoices = data.map((e) => InvoiceModel.fromJson(e)).toList();
        setState(() {
          _all = invoices;
          _applyFiltersInternal(invoices);
          _loading = false;
        });
      } else {
        setState(() {
          _error = result['message'] ?? 'Failed to load invoices';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _applyFilters);
  }

  void _applyFiltersInternal(List<InvoiceModel> source) {
    final query = _searchController.text.toLowerCase().trim();
    _filtered = source.where((inv) {
      final matchesStatus =
          _selectedStatus == 'ALL' || inv.status.toUpperCase() == _selectedStatus;
      if (!matchesStatus) return false;
      if (query.isEmpty) return true;
      return inv.invoiceNumber.toLowerCase().contains(query) ||
          inv.supplierName.toLowerCase().contains(query) ||
          (inv.submittedBy?.toLowerCase().contains(query) ?? false) ||
          (inv.site?.toLowerCase().contains(query) ?? false) ||
          inv.status.toLowerCase().contains(query) ||
          inv.invoiceDate.contains(query);
    }).toList();
  }

  void _applyFilters() {
    setState(() => _applyFiltersInternal(_all));
  }

  void _onStatusChanged(String status) {
    setState(() => _selectedStatus = status);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Invoices'),
        // backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadInvoices,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStatusChips(),
          _buildCountRow(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search supplier, invoice no., site, sender...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
            prefixIcon: const Icon(
              Icons.search_rounded,
              // color: AppColor.primaryBackground,
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF9CA3AF)),
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _statuses.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final s = _statuses[i];
            final selected = _selectedStatus == s;
            // final color = _statusColors[s] ?? AppColor.primaryBackground;
            return GestureDetector(
              onTap: () => _onStatusChanged(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  // color: selected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color: selected ? color : const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  _statusLabels[s] ?? s,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          Text(
            '${_filtered.length} invoice${_filtered.length == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_error != null) return _buildError();
    if (_filtered.isEmpty) return _buildEmpty();
    return _buildList();
  }

  Widget _buildList() {
    return RefreshIndicator(
      // color: AppColor.primar/yBackground,
      onRefresh: _loadInvoices,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filtered.length,
        itemBuilder: (_, i) => InvoiceCard(
          invoice: _filtered[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InvoiceDetailScreen(invoice: _filtered[i]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isNotEmpty || _selectedStatus != 'ALL'
                ? 'No invoices match your filters'
                : 'No invoices yet',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
          if (_searchController.text.isNotEmpty || _selectedStatus != 'ALL') ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _searchController.clear();
                _onStatusChanged('ALL');
              },
              child: const Text('Clear filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadInvoices,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: AppColor.primaryBackground,
              //   foregroundColor: Colors.white,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}