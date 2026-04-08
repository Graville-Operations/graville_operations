import 'package:flutter/material.dart';

class FinanceDashboardScreen extends StatefulWidget {
  const FinanceDashboardScreen({super.key});

  @override
  State<FinanceDashboardScreen> createState() =>
      _FinanceDashboardScreenState();
}

class _FinanceDashboardScreenState extends State<FinanceDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Placeholder data
  final double totalBudget = 5000000;
  final double totalSpent = 3200000;

  final List<Map<String, dynamic>> workerPayments = [
    {'name': 'Mabatini Workers', 'amount': 450000, 'date': 'Apr 1, 2026', 'count': 12},
    {'name': 'Mishi Mboko Workers', 'amount': 380000, 'date': 'Apr 1, 2026', 'count': 10},
    {'name': 'Huruma Workers', 'amount': 370000, 'date': 'Apr 1, 2026', 'count': 9},
  ];

  final List<Map<String, dynamic>> materialCosts = [
    {'item': 'Cement', 'quantity': '500 bags', 'amount': 150000, 'site': 'Mabatini'},
    {'item': 'Steel Rods', 'quantity': '2 tons', 'amount': 280000, 'site': 'Mishi Mboko'},
    {'item': 'Sand', 'quantity': '20 trucks', 'amount': 80000, 'site': 'Huruma'},
    {'item': 'Timber', 'quantity': '100 pieces', 'amount': 95000, 'site': 'Iremele'},
  ];

  final List<Map<String, dynamic>> siteExpenses = [
    {'site': 'Sunrise Apartments', 'budget': 2000000, 'spent': 1400000},
    {'site': 'Mabatini', 'budget': 1500000, 'spent': 1100000},
    {'site': 'Huruma', 'budget': 1500000, 'spent': 700000},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return 'KES ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'KES ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return 'KES ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = totalBudget - totalSpent;
    final percentUsed = (totalSpent / totalBudget * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.blue.shade900,
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: LayoutBuilder(
                builder: (context, constraints) {
                  final padH = 24.0;
                  final topInset =
                      MediaQuery.paddingOf(context).top + 12;
                  return Container(
                    color: Colors.blue.shade900,
                    padding: EdgeInsets.fromLTRB(
                      padH,
                      topInset,
                      padH,
                      12,
                    ),
                    alignment: Alignment.topLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              (constraints.maxWidth - padH * 2)
                                  .clamp(0, double.infinity),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Finance Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _TopCard(
                                  label: 'Total Budget',
                                  value:
                                      _formatAmount(totalBudget),
                                  icon: Icons.account_balance,
                                  color: Colors.blue.shade200,
                                ),
                                const SizedBox(width: 12),
                                _TopCard(
                                  label:
                                      'Spent ($percentUsed%)',
                                  value:
                                      _formatAmount(totalSpent),
                                  icon: Icons.trending_up,
                                  color: Colors.orange.shade200,
                                ),
                                const SizedBox(width: 12),
                                _TopCard(
                                  label: 'Remaining',
                                  value:
                                      _formatAmount(remaining),
                                  icon: Icons.savings,
                                  color: Colors.green.shade200,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.blue.shade200,
              tabs: const [
                Tab(text: 'Workers'),
                Tab(text: 'Materials'),
                Tab(text: 'Sites'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Workers Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workerPayments.length,
              itemBuilder: (context, index) {
                final payment = workerPayments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.people,
                            color: Colors.orange.shade700),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${payment['count']} workers · ${payment['date']}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatAmount(
                            (payment['amount'] as int).toDouble()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Materials Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: materialCosts.length,
              itemBuilder: (context, index) {
                final material = materialCosts[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.inventory,
                            color: Colors.purple.shade700),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              material['item'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${material['quantity']} · ${material['site']}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatAmount(
                            (material['amount'] as int).toDouble()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Sites Tab
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: siteExpenses.length,
              itemBuilder: (context, index) {
                final site = siteExpenses[index];
                final budget = (site['budget'] as int).toDouble();
                final spent = (site['spent'] as int).toDouble();
                final percent = (spent / budget).clamp(0.0, 1.0);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            site['site'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${(percent * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: percent > 0.8
                                  ? Colors.red
                                  : Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percent > 0.8 ? Colors.red : Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Spent: ${_formatAmount(spent)}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Budget: ${_formatAmount(budget)}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TopCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.blue.shade200,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}