import 'package:flutter/material.dart';
import 'package:graville_operations/models/project_status.dart';
import 'package:graville_operations/navigation/custom_navigator.dart';
import 'package:graville_operations/screens/add_transport_screen/add_transport_screen.dart';
import 'package:graville_operations/screens/commons/widgets/progress_bar.dart';
import 'package:graville_operations/screens/inventory/add_material.dart';
import 'package:graville_operations/screens/inventory/update_inventory.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';
import 'package:graville_operations/screens/workers/add_worker_screen.dart';
import 'package:graville_operations/screens/add_worker_screen/add_worker_screen.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';
import 'package:graville_operations/screens/commons/widgets/section_card.dart';
import 'package:graville_operations/screens/commons/widgets/status_chip.dart';
import 'package:graville_operations/screens/commons/widgets/stat_card.dart';
import 'package:graville_operations/screens/commons/widgets/progress_bar.dart';
import 'package:graville_operations/screens/home/home_screen.dart';
import 'package:graville_operations/screens/material/receive_material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFabOpen = false;
  Widget miniFab(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 44,
      height: 44,
      child: FloatingActionButton(
        heroTag: icon.toString(),
        mini: true,
        onPressed: onPressed,
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
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
            Tooltip(
              message: "Add worker",
              child: miniFab(
                Icons.person_add,
                () => context.push(const AddWorkerScreen()),
              ),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: "Hired equipment",
              child: miniFab(
                Icons.build,
                () => context.push(const AddMaterialScreen()),
              ),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: "Receive material",
              child: miniFab(
                Icons.download,
                () => context.push(const ReceiveMaterialScreen()),
              ),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: "Update inventory",
              child: miniFab(
                Icons.store,
                () => context.push(const UpdateInventoryScreen()),
              ),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: "Transfer material",
              child: miniFab(
                Icons.local_shipping,
                () => context.push(const TransferMaterialScreen()),
              ),
            ),
            const SizedBox(height: 12),
          ],
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(CommonImages.logo, height: 28),
                const SizedBox(width: 10),
                const Text(
                  "Graville Operations",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sunrise Apartments",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ProjectStatusChip(status: ProjectStatus.onSchedule),
                        ],
                      ),
                    ],
                  ),
                ),

                //Workers
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

                //Material stock and project completionconst SizedBox(height: 15),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cement"),
                                  Text(
                                    "250 bags",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Steel"),
                                  Text(
                                    "1.5 tons",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                //Task progress section
                const SizedBox(height: 15),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.task, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Task Progress",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      TaskProgress(
                        title: "Foundation",
                        percent: 1.0,
                        color: Colors.green,
                      ),
                      TaskProgress(
                        title: "Framing",
                        percent: 0.75,
                        color: Colors.orange,
                      ),
                      TaskProgress(
                        title: "Electrical",
                        percent: 0.45,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),

                //Reviews
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
                          headingRowColor: WidgetStatePropertyAll(
                            Colors.grey.shade200,
                          ),
                          columns: const [
                            DataColumn(label: Text("MESSAGE")),
                            DataColumn(label: Text("REVIEWER")),
                            DataColumn(label: Text("DATE")),
                          ],
                          rows: const [
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    "Great job on the installation at the new site.",
                                  ),
                                ),
                                DataCell(Text("James Paterson")),
                                DataCell(Text("Feb 10")),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    "Work completed efficiently, update status next time.",
                                  ),
                                ),
                                DataCell(Text("Angela Martinez")),
                                DataCell(Text("Feb 8")),
                              ],
                            ),
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
