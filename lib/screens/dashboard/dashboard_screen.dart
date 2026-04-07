import 'package:flutter/material.dart';
import 'package:graville_operations/screens/dashboard/dashboard_details_screen.dart';
import 'package:graville_operations/models/dashboard/dashboard_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _filter = 'All';
  String _search = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['All', 'Ongoing', 'Completed', 'Paused'];

  List<DashboardModel> get _filtered {
    return sampleDashboards.where((s) {
      final matchFilter =
          _filter == 'All' || s.status.toLowerCase() == _filter.toLowerCase();
      final q = _search.toLowerCase();
      final matchSearch = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.location.toLowerCase().contains(q) ||
          s.procuringEntity.toLowerCase().contains(q);
      return matchFilter && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sites = _filtered;
    final total = sampleDashboards.length;
    final ongoing = sampleDashboards.where((s) => s.status == 'Ongoing').length;
    final completed =
        sampleDashboards.where((s) => s.status == 'Completed').length;
    final paused = sampleDashboards.where((s) => s.status == 'Paused').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F3EF),
        elevation: 0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Site Dashboard',
                style: TextStyle(
                  color: Color(0xFF0F1117),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Construction Sites',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F1117),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Overview of all active and completed projects',
                    style: TextStyle(fontSize: 13, color: Color(0xFF7A7E8E)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 82,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _MetricCard(
                            label: 'Total Sites',
                            value: '$total',
                            color: const Color(0xFF0F1117)),
                        const SizedBox(width: 10),
                        _MetricCard(
                            label: 'Ongoing',
                            value: '$ongoing',
                            color: const Color(0xFFD97706)),
                        const SizedBox(width: 10),
                        _MetricCard(
                            label: 'Completed',
                            value: '$completed',
                            color: const Color(0xFF1A9E5C)),
                        const SizedBox(width: 10),
                        _MetricCard(
                            label: 'Paused',
                            value: '$paused',
                            color: const Color(0xFFDC2626)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            size: 18, color: Color(0xFF7A7E8E)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _search = v),
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF0F1117)),
                            decoration: const InputDecoration(
                              hintText: 'Search sites or entities…',
                              hintStyle: TextStyle(
                                  fontSize: 13, color: Color(0xFF7A7E8E)),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final f = _filters[i];
                        final active = _filter == f;
                        return GestureDetector(
                          onTap: () => setState(() => _filter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF0F1117)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: active
                                    ? const Color(0xFF0F1117)
                                    : Colors.black.withOpacity(0.12),
                              ),
                            ),
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : const Color(0xFF7A7E8E),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          sites.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No sites match your search.',
                      style: TextStyle(color: Color(0xFF7A7E8E), fontSize: 14),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _SiteCard(
                        site: sites[i],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DashboardDetailsScreen(site: sites[i]),
                            ),
                          );
                        },
                      ),
                      childCount: sites.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisExtent: 270,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF7A7E8E),
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  final DashboardModel site;
  final VoidCallback onTap;

  const _SiteCard({required this.site, required this.onTap});

  Color get _statusColor {
    switch (site.status) {
      case 'Completed':
        return const Color(0xFF1A9E5C);
      case 'Paused':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFD97706);
    }
  }

  Color get _statusBg {
    switch (site.status) {
      case 'Completed':
        return const Color(0xFFE3F7ED);
      case 'Paused':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFFEF3C7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    site.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1117),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    site.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Meta rows
            _MetaRow(icon: Icons.location_on_outlined, text: site.location),
            const SizedBox(height: 5),
            _MetaRow(icon: Icons.apartment_outlined, text: site.type),
            const SizedBox(height: 5),
            _MetaRow(
                icon: Icons.calendar_today_outlined,
                text: 'Deadline: ${site.deadline}'),
            const SizedBox(height: 5),
            _MetaRow(
                icon: Icons.business_outlined,
                text: site.procuringEntity,
                isEntity: true),

            const Spacer(),
            const Divider(height: 1, color: Color(0x11000000)),
            const SizedBox(height: 6),

            // Progress
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress — ${site.progress}%',
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF7A7E8E)),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: site.progress / 100,
                          minHeight: 5,
                          backgroundColor: Colors.black.withOpacity(0.07),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_statusColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isEntity;

  const _MetaRow(
      {required this.icon, required this.text, this.isEntity = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF7A7E8E)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color:
                  isEntity ? const Color(0xFF3A3D4A) : const Color(0xFF3A3D4A),
              fontWeight: isEntity ? FontWeight.w500 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
