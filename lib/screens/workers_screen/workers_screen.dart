import 'package:flutter/material.dart';

class WorkersScreen extends StatelessWidget {
  const WorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F6F8),
        title: const Row(
          children: [
            Icon(Icons.home_work_rounded, color: Colors.blue),
            SizedBox(width: 10),
            Text(
              "Workers",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SELECT SITE CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Site",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Choose site...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// STATS CARDS
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: "10",
                    subtitle: "Total Workers Assigned",
                    color: Colors.blue.shade100,
                    textColor: Colors.blue,
                    onTap: () {
                      print("Total Workers Clicked");
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: "8",
                    subtitle: "Workers Present Today",
                    color: Colors.orange.shade100,
                    textColor: Colors.orange,
                    onTap: () {
                      print("Present Workers Clicked");
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ADD WORKER BUTTON + SEARCH
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Add Worker Clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Add Worker"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// WORKER LIST CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Worker List",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// HORIZONTAL SCROLL TABLE
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 30,
                        columns: const [
                          DataColumn(label: Text("NAME")),
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("TYPE")),
                          DataColumn(label: Text("PHONE NO.")),
                          DataColumn(label: Text("TASK")),
                          DataColumn(label: Text("AMOUNT")),
                        ],
                        rows: _buildRows(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30), // ensures bottom visibility
          ],
        ),
      ),
    );
  }

  /// STAT CARD WIDGET
  Widget _statCard({
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  /// TABLE ROWS
  List<DataRow> _buildRows() {
    final workers = [
      ["John Mitchell", "W001", "Skilled", "+1 555-0123", "Brickwork", "\$250"],
      ["Robert Chen", "W002", "Skilled", "+1 555-0124", "Carpentry", "\$280"],
      ["Maria Garcia", "W003", "Skilled", "+1 555-0125", "Electrical", "\$300"],
      ["David Thompson", "W004", "Skilled", "+1 555-0126", "Plumbing", "\$275"],
      ["Sarah Williams", "W005", "Unskilled", "+1 555-0127", "Labor", "\$150"],
      ["James Anderson", "W006", "Skilled", "+1 555-0128", "Woodwork", "\$260"],
      ["Lisa Brown", "W007", "Skilled", "+1 555-0129", "Supervision", "\$350"],
      ["Michael Davis", "W008", "Skilled", "+1 555-0130", "Welding", "\$290"],
    ];

    return workers
        .map(
          (worker) => DataRow(
            cells: worker.map((cell) => DataCell(Text(cell))).toList(),
            onSelectChanged: (value) {
              print("Clicked: ${worker[0]}");
            },
          ),
        )
        .toList();
  }
}
