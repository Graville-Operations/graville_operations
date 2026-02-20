import 'package:flutter/material.dart';

class Worker {
  final String name;
  final String id;
  final String skillLevel;
  final String phone;
  final String specialty;
  final String rate;

  Worker({
    required this.name,
    required this.id,
    required this.skillLevel,
    required this.phone,
    required this.specialty,
    required this.rate,
  });
}

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  String? selectedSite;

  final TextEditingController searchController = TextEditingController();

  final List<String> sites = [
    'Mabatini',
    'Mishi Mboko',
    'Huruma',
    'DCC Kibra',
    'Ngei',
    'Iremele',
  ];

  final List<Worker> workers = [
    Worker(
      name: "John Mitchell",
      id: "W001",
      skillLevel: "Skilled",
      phone: "+1 555-0123",
      specialty: "Brickwork",
      rate: "\$250",
    ),
    Worker(
      name: "Robert Chen",
      id: "W002",
      skillLevel: "Skilled",
      phone: "+1 555-0124",
      specialty: "Carpentry",
      rate: "\$280",
    ),
    Worker(
      name: "Maria Garcia",
      id: "W003",
      skillLevel: "Skilled",
      phone: "+1 555-0125",
      specialty: "Electrical",
      rate: "\$300",
    ),
    Worker(
      name: "David Thompson",
      id: "W004",
      skillLevel: "Skilled",
      phone: "+1 555-0126",
      specialty: "Plumbing",
      rate: "\$275",
    ),
    Worker(
      name: "Sarah Williams",
      id: "W005",
      skillLevel: "Unskilled",
      phone: "+1 555-0127",
      specialty: "Labor",
      rate: "\$150",
    ),
    Worker(
      name: "James Anderson",
      id: "W006",
      skillLevel: "Skilled",
      phone: "+1 555-0128",
      specialty: "Woodwork",
      rate: "\$260",
    ),
    Worker(
      name: "Lisa Brown",
      id: "W007",
      skillLevel: "Skilled",
      phone: "+1 555-0129",
      specialty: "Supervision",
      rate: "\$350",
    ),
    Worker(
      name: "Michael Davis",
      id: "W008",
      skillLevel: "Skilled",
      phone: "+1 555-0130",
      specialty: "Welding",
      rate: "\$290",
    ),
  ];

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
            // LABEL OUTSIDE CARD
            const Text(
              "Construction Site",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),

            // REDUCED SIZE CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: selectedSite,
                  hint: const Text("Select Site"),
                  isDense: true,
                  items: sites
                      .map(
                        (site) =>
                            DropdownMenuItem(value: site, child: Text(site)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedSite = value);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: "10",
                    subtitle: "Total Workers Assigned",
                    color: Colors.blue.shade100,
                    textColor: Colors.blue,
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    title: "8",
                    subtitle: "Workers Present Today",
                    color: Colors.orange.shade100,
                    textColor: Colors.orange,
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF3366FF,
                    ), // new button color
                    foregroundColor: Colors.white, // text color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Add Worker",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Worker List",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    headingRowColor: WidgetStateProperty.all(
                      Colors.grey.shade200,
                    ),
                    columnSpacing: 30,
                    columns: _buildHeaderColumns(),
                    rows: _buildWorkerRows(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildHeaderColumns() {
    final headers = ["NAME", "ID", "TYPE", "PHONE NO", "TASK", "AMOUNT"];
    return headers
        .map(
          (title) => DataColumn(
            label: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
        .toList();
  }

  List<DataRow> _buildWorkerRows() {
    return workers.map((worker) {
      return DataRow(
        onSelectChanged: (selected) {},
        cells: [
          DataCell(Text(worker.name)),
          DataCell(Text(worker.id)),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: worker.skillLevel.toLowerCase() == 'skilled'
                    ? Colors.blue.shade100
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                worker.skillLevel,
                style: TextStyle(
                  color: worker.skillLevel.toLowerCase() == 'skilled'
                      ? Colors.blue.shade800
                      : Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          DataCell(Text(worker.phone)),
          DataCell(Text(worker.specialty)),
          DataCell(Text(worker.rate)),
        ],
      );
    }).toList();
  }
}

Widget _statCard({
  required String title,
  required String subtitle,
  required Color color,
  required Color textColor,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
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
