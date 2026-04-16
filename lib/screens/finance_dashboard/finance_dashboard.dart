import 'package:flutter/material.dart';
import 'package:graville_operations/models/dashboard/finance_dashboard.dart';

void main() {
  runApp(const FinanceDashboardApp());
}

//data for the sites

final List<SiteData> sampleSites = [
  SiteData(
    name: 'Huruma',
    location: 'Nairobi',
    categories: [
      ExpenseCategory(
        title: 'Transport',
        icon: Icons.local_shipping_rounded,
        color: const Color(0xFF3B82F6),
        items: [
          const ExpenseItem(name: 'Truck Hire', amount: 400),
          const ExpenseItem(name: 'Fuel', amount: 180),
          const ExpenseItem(name: 'Driver Allowance', amount: 100),
        ],
      ),
      ExpenseCategory(
        title: 'Materials',
        icon: Icons.inventory_2_rounded,
        color: const Color(0xFFF59E0B),
        items: [
          const ExpenseItem(name: 'Cement (50 bags)', amount: 300),
          const ExpenseItem(name: 'Steel Bars', amount: 700),
          const ExpenseItem(name: 'Timber', amount: 220),
          const ExpenseItem(name: 'Sand & Ballast', amount: 150),
        ],
      ),
      ExpenseCategory(
        title: 'Tools',
        icon: Icons.construction_rounded,
        color: const Color(0xFF8B5CF6),
        items: [
          const ExpenseItem(name: 'Scaffolding Rental', amount: 120),
          const ExpenseItem(name: 'Power Tools', amount: 120),
          const ExpenseItem(name: 'Hand Tools', amount: 120),
        ],
      ),
      ExpenseCategory(
        title: 'Labour',
        icon: Icons.people_rounded,
        color: const Color(0xFF10B981),
        items: [
          const ExpenseItem(name: 'Fundis (x6)', amount: 500),
          const ExpenseItem(name: 'Casuals (x12)', amount: 300),
          const ExpenseItem(name: 'Site Foreman', amount: 100),
          const ExpenseItem(name: 'Overtime', amount: 90),
        ],
      ),
      ExpenseCategory(
        title: 'Electricity',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFEF4444),
        items: [
          const ExpenseItem(name: 'KPLC Bill', amount: 70),
          const ExpenseItem(name: 'Generator Fuel', amount: 900),
          const ExpenseItem(name: 'Electrical Works', amount: 140),
        ],
      ),
      ExpenseCategory(
        title: 'Water',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF06B6D4),
        items: [
          const ExpenseItem(name: 'Water Bowser', amount: 400),
          const ExpenseItem(name: 'Nairobi Water Bill', amount: 200),
        ],
      ),
      ExpenseCategory(
        title: 'Subcontractor',
        icon: Icons.handshake_rounded,
        color: const Color(0xFFEC4899),
        items: [
          const ExpenseItem(name: 'Plumbing Works', amount: 300),
          const ExpenseItem(name: 'Tiling Contractor', amount: 50),
          const ExpenseItem(name: 'Painting Crew', amount: 200),
        ],
      ),
    ],
  ),

  //site 2
  SiteData(
    name: 'Mishi Mboko',
    location: 'Mombasa',
    categories: [
      ExpenseCategory(
        title: 'Transport',
        icon: Icons.local_shipping_rounded,
        color: const Color(0xFF3B82F6),
        items: [
          const ExpenseItem(name: 'Truck Hire', amount: 300),
          const ExpenseItem(name: 'Fuel', amount: 120),
        ],
      ),
      ExpenseCategory(
        title: 'Materials',
        icon: Icons.inventory_2_rounded,
        color: const Color(0xFFF59E0B),
        items: [
          const ExpenseItem(name: 'Cement (80 bags)', amount: 400),
          const ExpenseItem(name: 'Bricks', amount: 600),
          const ExpenseItem(name: 'Roofing Sheets', amount: 50),
        ],
      ),
      ExpenseCategory(
        title: 'Tools',
        icon: Icons.construction_rounded,
        color: const Color(0xFF8B5CF6),
        items: [
          const ExpenseItem(name: 'Concrete Mixer Rental', amount: 100),
          const ExpenseItem(name: 'Safety Equipment', amount: 600),
        ],
      ),
      ExpenseCategory(
        title: 'Labour',
        icon: Icons.people_rounded,
        color: const Color(0xFF10B981),
        items: [
          const ExpenseItem(name: 'Fundis (x8)', amount: 7000),
          const ExpenseItem(name: 'Casuals (x15)', amount: 4500),
          const ExpenseItem(name: 'Site Manager', amount: 2000),
        ],
      ),
      ExpenseCategory(
        title: 'Electricity',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFEF4444),
        items: [
          const ExpenseItem(name: 'KPLC Bill', amount: 5000),
          const ExpenseItem(name: 'Temporary Power Setup', amount: 1000),
        ],
      ),
      ExpenseCategory(
        title: 'Water',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF06B6D4),
        items: [
          const ExpenseItem(name: 'Water Bowser x3', amount: 1000),
          const ExpenseItem(name: 'Plumbing Materials', amount: 500),
        ],
      ),
      ExpenseCategory(
        title: 'Subcontractor',
        icon: Icons.handshake_rounded,
        color: const Color(0xFFEC4899),
        items: [
          const ExpenseItem(name: 'Electrical Sub', amount: 4000),
          const ExpenseItem(name: 'Roofing Crew', amount: 700),
        ],
      ),
    ],
  ),
  SiteData(
    name: 'Kibra',
    location: 'Nairobi',
    categories: [
      ExpenseCategory(
        title: 'Transport',
        icon: Icons.local_shipping_rounded,
        color: const Color(0xFF3B82F6),
        items: [
          const ExpenseItem(name: 'Delivery Trucks', amount: 200),
          const ExpenseItem(name: 'Site Vehicle Fuel', amount: 950),
        ],
      ),
      ExpenseCategory(
        title: 'Materials',
        icon: Icons.inventory_2_rounded,
        color: const Color(0xFFF59E0B),
        items: [
          const ExpenseItem(name: 'Concrete Blocks', amount: 4000),
          const ExpenseItem(name: 'Reinforcement Steel', amount: 1000),
          const ExpenseItem(name: 'Paint & Finishes', amount: 2000),
        ],
      ),
      ExpenseCategory(
        title: 'Tools',
        icon: Icons.construction_rounded,
        color: const Color(0xFF8B5CF6),
        items: [
          const ExpenseItem(name: 'Crane Rental', amount: 5000),
          const ExpenseItem(name: 'Vibrator Rental', amount: 4500),
        ],
      ),
      ExpenseCategory(
        title: 'Labour',
        icon: Icons.people_rounded,
        color: const Color(0xFF10B981),
        items: [
          const ExpenseItem(name: 'Skilled Workers (x10)', amount: 9000),
          const ExpenseItem(name: 'Unskilled (x20)', amount: 6000),
        ],
      ),
      ExpenseCategory(
        title: 'Electricity',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFEF4444),
        items: [
          const ExpenseItem(name: 'Monthly Bill', amount: 1000),
        ],
      ),
      ExpenseCategory(
        title: 'Water',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF06B6D4),
        items: [
          const ExpenseItem(name: 'County Water Bill', amount: 300),
          const ExpenseItem(name: 'Water Storage Tank', amount: 100),
        ],
      ),
      ExpenseCategory(
        title: 'Subcontractor',
        icon: Icons.handshake_rounded,
        color: const Color(0xFFEC4899),
        items: [
          const ExpenseItem(name: 'HVAC Installation', amount: 500),
          const ExpenseItem(name: 'Lift Installation', amount: 200),
        ],
      ),
    ],
  ),
];

//HELPERS

String formatKes(double amount) {
  if (amount >= 1000000) return 'KES ${(amount / 1000000).toStringAsFixed(2)}M';
  if (amount >= 1000) return 'KES ${(amount / 1000).toStringAsFixed(1)}K';
  return 'KES ${amount.toStringAsFixed(0)}';
}

//APP

class FinanceDashboardApp extends StatelessWidget {
  const FinanceDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Site Finance Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A56DB),
          brightness: Brightness.light,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

//DASHBOARD SCREEN

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  double get _grandTotal =>
      sampleSites.fold(0, (s, site) => s + site.totalExpenses);

  List<SiteData> get _filteredSites {
    if (_query.isEmpty) return sampleSites;
    final q = _query.toLowerCase();
    return sampleSites
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            s.location.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSites;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          //App Bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Site Expenses',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${sampleSites.length} active sites · April 2025',
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: _SummaryCard(grandTotal: _grandTotal),
            ),
          ),

          // ── Search Bar ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search sites by name or location…',
                    hintStyle: const TextStyle(
                      color: Color(0xFFB0B8C5),
                      fontSize: 13.5,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: Color(0xFF9CA3AF), size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // ── Section Label ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Text(
                    _query.isEmpty
                        ? 'All Sites'
                        : '${filtered.length} result${filtered.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Tap card to view details',
                    style: TextStyle(color: Color(0xFFB0B8C5), fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ),

          // ── Site Cards ────────────────────────────────────────────────────
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      'No sites found for "$_query"',
                      style: const TextStyle(
                          color: Color(0xFFB0B8C5), fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _SiteCard(site: filtered[i]),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

//SUMMARY CARD

class _SummaryCard extends StatelessWidget {
  final double grandTotal;
  const _SummaryCard({required this.grandTotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A56DB),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A56DB).withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL EXPENDITURE',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatKes(grandTotal),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Across ${sampleSites.length} sites this month',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'AVG / SITE',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatKes(grandTotal / sampleSites.length),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//screen details

class _SiteCard extends StatelessWidget {
  final SiteData site;
  const _SiteCard({required this.site});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SiteDetailScreen(site: site),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Column(
            children: [
              //Site name + location row
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.domain_rounded,
                        color: Color(0xFF1A56DB), size: 22),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.name,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 11, color: Color(0xFFB0B8C5)),
                            const SizedBox(width: 2),
                            Text(
                              site.location,
                              style: const TextStyle(
                                  color: Color(0xFFB0B8C5), fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon indicating navigation
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFFB0B8C5), size: 22),
                ],
              ),

              const SizedBox(height: 16),

              //Category summary rows
              ...List.generate(site.categories.length, (i) {
                final cat = site.categories[i];
                final isLast = i == site.categories.length - 1;
                return _CategorySummaryRow(category: cat, showDivider: !isLast);
              }),

              const SizedBox(height: 10),

              //Total row
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Site Total',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatKes(site.totalExpenses),
                      style: const TextStyle(
                        color: Color(0xFF1A56DB),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//CATEGORY SUMMARY ROW

class _CategorySummaryRow extends StatelessWidget {
  final ExpenseCategory category;
  final bool showDivider;

  const _CategorySummaryRow({
    required this.category,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: category.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Icon(category.icon, size: 15, color: category.color),
              const SizedBox(width: 8),
              Text(
                category.title,
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                formatKes(category.total),
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF3F4F6)),
      ],
    );
  }
}

//SITE DETAIL SCREEN

class SiteDetailScreen extends StatelessWidget {
  final SiteData site;
  const SiteDetailScreen({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          //App Bar
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF111827), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 54, bottom: 14),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.name,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 2),
                      Text(
                        site.location,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //Total banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A56DB),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A56DB).withOpacity(0.28),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TOTAL SITE EXPENDITURE',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatKes(site.totalExpenses),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${site.categories.length} expense categories',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.domain_rounded,
                          color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Section label
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'EXPENSE BREAKDOWN',
                style: TextStyle(
                  color: Color(0xFFB0B8C5),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
            ),
          ),

          //Category tiles
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CategoryExpandedTile(category: site.categories[i]),
                ),
                childCount: site.categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//CATEGORY EXPANDED TILE

class _CategoryExpandedTile extends StatefulWidget {
  final ExpenseCategory category;
  const _CategoryExpandedTile({required this.category});

  @override
  State<_CategoryExpandedTile> createState() => _CategoryExpandedTileState();
}

class _CategoryExpandedTileState extends State<_CategoryExpandedTile>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      _open ? _ctrl.forward() : _ctrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        decoration: BoxDecoration(
          color: _open ? widget.category.color.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _open
                ? widget.category.color.withOpacity(0.2)
                : const Color(0xFFEEEEEE),
            width: 1,
          ),
          boxShadow: [
            if (!_open)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Column(
          children: [
            //Row header
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: widget.category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(widget.category.icon,
                        color: widget.category.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.title,
                          style: TextStyle(
                            color: widget.category.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${widget.category.items.length} items',
                          style: const TextStyle(
                            color: Color(0xFFB0B8C5),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatKes(widget.category.total),
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  RotationTransition(
                    turns: Tween<double>(begin: 0, end: 0.5).animate(_anim),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.category.color.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            //Sub-items
            SizeTransition(
              sizeFactor: _anim,
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    color: widget.category.color.withOpacity(0.12),
                    indent: 14,
                    endIndent: 14,
                  ),
                  ...widget.category.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: widget.category.color.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            formatKes(item.amount),
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
