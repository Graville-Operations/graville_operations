import 'package:flutter/material.dart';
import 'package:graville_operations/models/project_status.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/commons/widgets/progress_bar.dart';
import 'package:graville_operations/screens/inventory/add_material.dart';
import 'package:graville_operations/screens/inventory/update_inventory.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';
import 'package:graville_operations/screens/sites/create_sites.dart';
import 'package:graville_operations/screens/sites/sites_list.dart';
import 'package:graville_operations/screens/task_screen/task_screen.dart';
import 'package:graville_operations/screens/workers/add_worker_screen.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';
import 'package:graville_operations/screens/commons/widgets/section_card.dart';
import 'package:graville_operations/screens/commons/widgets/status_chip.dart';
import 'package:graville_operations/screens/commons/widgets/stat_card.dart';
import 'package:graville_operations/screens/invoice/invoice_screen.dart';
import 'package:graville_operations/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFabOpen = false;
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  void _loadRole() async {
    final role = await ApiService.getRole();
    setState(() => _role = role ?? '');
  }

  Widget miniFab(IconData icon, VoidCallback onPressed, {Color color = Colors.black}) {
    return SizedBox(
      width: 44,
      height: 44,
      child: FloatingActionButton(
        heroTag: icon.toString(),
        mini: true,
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: color,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // Mini FAB with label tooltip
  Widget _labeledMiniFab(String tooltip, IconData icon, VoidCallback onPressed, {Color color = Colors.black}) {
    return Tooltip(
      message: tooltip,
      child: miniFab(icon, onPressed, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFabOpen) ...[

            // ← Field engineer only: Submit Invoice
            if (_role == 'field_engineer') ...[
              _labeledMiniFab(
                "Submit Invoice",
                Icons.receipt_long,
                () {
                  setState(() => _isFabOpen = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const InvoiceScreen()),
                  );
                },
                color: const Color(0xFF33907C), // AppColor.primaryBackground
              ),
              const SizedBox(height: 12),
            ],

            _labeledMiniFab(
              "Add worker",
              Icons.person_add,
              () => context.push(const AddWorkerScreen()),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "New Site",
              Icons.apartment,
              () => context.push(const CreateSitesScreen()),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "View sites",
              Icons.map_outlined,
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SitesListScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "Hired equipment",
              Icons.build,
              () => context.push(const AddMaterialScreen()),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "Receive material",
              Icons.download,
              () => context.push(const ReceiveMaterialScreen()),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "Update inventory",
              Icons.store,
              () => context.push(const UpdateInventoryScreen(preSelectedItem: null)),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "Transfer material",
              Icons.local_shipping,
              () => context.push(const TransferMaterialScreen()),
            ),
            const SizedBox(height: 12),
            _labeledMiniFab(
              "Create task",
              Icons.add,
              () => context.push(const CreateTaskScreen()),
            ),
            const SizedBox(height: 12),
          ],

          // Main FAB
          FloatingActionButton(
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            onPressed: () => setState(() => _isFabOpen = !_isFabOpen),
            child: AnimatedRotation(
              turns: _isFabOpen ? 0.125 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            flexibleSpace: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(CommonImages.logo, height: 40),
                    const SizedBox(height: 4),
                    const Text(
                      "Graville Operations",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Current Project",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Sunrise Apartments",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.people,
                        title: "Total Workers",
                        value: "152",
                        subtitle: "Ever Assigned",
                        color: Color(0xff5b7cfa),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.person,
                        title: "Present Today",
                        value: "87",
                        subtitle: "Active on Site",
                        color: Color(0xff1db954),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.inventory, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    "Material Stock",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cement"),
                                  Text("250 bags",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Steel"),
                                  Text("1.5 tons",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SectionCard(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Project Completion",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 90,
                                width: 90,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: 0.68,
                                      strokeWidth: 8,
                                      color: Colors.orange,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    const Text(
                                      "68%",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.task, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Task Progress",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TaskProgress(
                          title: "Foundation", percent: 1.0, color: Colors.green),
                      TaskProgress(
                          title: "Framing", percent: 0.75, color: Colors.orange),
                      TaskProgress(
                          title: "Electrical", percent: 0.45, color: Colors.blue),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Reviews",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 700;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: isWide ? constraints.maxWidth : 700,
                        ),
                        child: DataTable(
                          columnSpacing: 40,
                          headingRowColor:
                              WidgetStatePropertyAll(Colors.grey.shade200),
                          columns: const [
                            DataColumn(label: Text("MESSAGE")),
                            DataColumn(label: Text("REVIEWER")),
                            DataColumn(label: Text("DATE")),
                          ],
                          rows: const [
                            DataRow(cells: [
                              DataCell(Text(
                                  "Great job on the installation at the new site.")),
                              DataCell(Text("James Paterson")),
                              DataCell(Text("Feb 10")),
                            ]),
                            DataRow(cells: [
                              DataCell(Text(
                                  "Work completed efficiently, update status next time.")),
                              DataCell(Text("Angela Martinez")),
                              DataCell(Text("Feb 8")),
                            ]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}