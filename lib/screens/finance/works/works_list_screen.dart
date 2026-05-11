import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';
import 'package:graville_operations/models/works/pick_record_model.dart';
import 'package:graville_operations/screens/finance/works/works_details_screen.dart';
import 'package:graville_operations/services/api_service.dart';

class WorksListScreen extends StatefulWidget {
  const WorksListScreen({super.key});

  @override
  State<WorksListScreen> createState() => _WorksListScreenState();
}

class _WorksListScreenState extends State<WorksListScreen> {
  List<PickRecordModel> _all = [];
  List<PickRecordModel> _filtered = [];
  bool _loading = true;
  String? _error;
  String _selectedStatus = 'ALL';
  String _selectedType = 'ALL';
  final _searchController = TextEditingController();
  Timer? _debounce;

  static const _statuses = ['ALL', 'PENDING', 'DELIVERED', 'CANCELLED'];
  static const _types = ['ALL', 'INTERNAL', 'EXTERNAL'];

  static const _statusColors = {
    'ALL': AppColor.primaryBackground,
    'PENDING': Color(0xFF7C3AED),
    'DELIVERED': Color(0xFF1B8A5A),
    'CANCELLED': Color(0xFF6B7280),
  };

  static const _statusLabels = {
    'ALL': 'All',
    'PENDING': 'Pending',
    'DELIVERED': 'Delivered',
    'CANCELLED': 'Cancelled',
  };

  static const _typeColors = {
    'ALL': AppColor.primaryBackground,
    'INTERNAL': Color(0xFF2563EB),
    'EXTERNAL': Color(0xFFD97706),
  };

  @override
  void initState() {
    super.initState();
    _loadPicks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadPicks() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ApiService.getAllPicks();
      if (result['success']) {
        final data = result['data'] as List<dynamic>;
        final picks =
            data.map((e) => PickRecordModel.fromJson(e)).toList();
        setState(() {
          _all = picks;
          _applyFiltersInternal(picks);
          _loading = false;
        });
      } else {
        setState(() {
          _error = result['message'] ?? 'Failed to load records';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce =
        Timer(const Duration(milliseconds: 300), _applyFilters);
  }

  void _applyFiltersInternal(List<PickRecordModel> source) {
    final query = _searchController.text.toLowerCase().trim();
    _filtered = source.where((p) {
      final matchesStatus = _selectedStatus == 'ALL' ||
          p.status.toUpperCase() == _selectedStatus;
      final matchesType = _selectedType == 'ALL' ||
          p.workType.toUpperCase() == _selectedType;
      if (!matchesStatus || !matchesType) return false;
      if (query.isEmpty) return true;
      return p.company.toLowerCase().contains(query) ||
          p.siteName.toLowerCase().contains(query) ||
          p.refId.toLowerCase().contains(query) ||
          (p.submittedBy?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void _applyFilters() {
    setState(() => _applyFiltersInternal(_all));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text('Works Records'),
        backgroundColor: AppColor.primaryBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadPicks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Search + filters
          _buildSearchBar(),
          _buildTypeChips(),
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
            hintText: 'Search company, site, ref ID...',
            hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF), fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColor.primaryBackground, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: Color(0xFF9CA3AF)),
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SizedBox(
        height: 32,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _types.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final t = _types[i];
            final selected = _selectedType == t;
            final color =
                _typeColors[t] ?? AppColor.primaryBackground;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedType = t);
                _applyFilters();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: selected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selected
                          ? color
                          : const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  t == 'ALL' ? 'All Types' : t,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SizedBox(
        height: 32,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _statuses.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final s = _statuses[i];
            final selected = _selectedStatus == s;
            final color =
                _statusColors[s] ?? AppColor.primaryBackground;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedStatus = s);
                _applyFilters();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: selected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: selected
                          ? color
                          : const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  _statusLabels[s] ?? s,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF6B7280),
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
            '${_filtered.length} record${_filtered.length == 1 ? '' : 's'}',
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
            color: AppColor.primaryBackground),
      );
    }
    if (_error != null) return _buildError();
    if (_filtered.isEmpty) return _buildEmpty();
    return _buildList();
  }

  Widget _buildList() {
    return RefreshIndicator(
      color: AppColor.primaryBackground,
      onRefresh: _loadPicks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filtered.length,
        itemBuilder: (_, i) => _PickCard(
          pick: _filtered[i],
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WorksDetailScreen(pick: _filtered[i]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isNotEmpty ||
                    _selectedStatus != 'ALL' ||
                    _selectedType != 'ALL'
                ? 'No records match your filters'
                : 'No works records yet',
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 15),
          ),
          if (_searchController.text.isNotEmpty ||
              _selectedStatus != 'ALL' ||
              _selectedType != 'ALL') ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedStatus = 'ALL';
                  _selectedType = 'ALL';
                });
                _applyFilters();
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
            Icon(Icons.error_outline_rounded,
                size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadPicks,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBackground,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickCard extends StatelessWidget {
  final PickRecordModel pick;
  final VoidCallback onTap;

  const _PickCard({required this.pick, required this.onTap});

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
            // ─── Top colored bar by work type
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: pick.isInternal
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFD97706),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Header row
                  Row(
                    children: [
                      // Work type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: pick.isInternal
                              ? const Color(0xFF2563EB)
                                  .withOpacity(0.1)
                              : const Color(0xFFD97706)
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          pick.workType,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: pick.isInternal
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status badge
                      _StatusBadge(status: pick.status),
                      const Spacer(),
                      // Date
                      Text(
                        _formatDate(pick.createdAt),
                        style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    pick.company,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ─── Site + items count
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pick.siteName,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.inventory_2_outlined,
                          size: 13, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        '${pick.items.length} item${pick.items.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // ─── Ref ID + submitted by
                  Row(
                    children: [
                      Text(
                        'Ref: ${pick.refId}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF)),
                      ),
                      if (pick.submittedBy != null) ...[
                        const Text(' · ',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF))),
                        Text(
                          pick.submittedBy!,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF)),
                        ),
                      ],
                      if (pick.isExternal &&
                          pick.totalAmount != null) ...[
                        const Spacer(),
                        Text(
                          'KES ${pick.totalAmount!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryBackground,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ─── Dropped by (if delivered)
                  if (pick.status.toUpperCase() == 'DELIVERED' &&
                      pick.droppedBy != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            size: 13, color: Color(0xFF1B8A5A)),
                        const SizedBox(width: 4),
                        Text(
                          'Dropped by ${pick.droppedBy}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF1B8A5A)),
                        ),
                      ],
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '—';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final upper = status.toUpperCase();
    final color = switch (upper) {
      'PENDING' => const Color(0xFF7C3AED),
      'DELIVERED' => const Color(0xFF1B8A5A),
      'CANCELLED' => const Color(0xFF6B7280),
      _ => const Color(0xFF6B7280),
    };

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        upper,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}