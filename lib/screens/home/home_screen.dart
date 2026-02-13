import 'package:flutter/material.dart';
import 'package:graville_operations/models/project_status.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';
import 'package:graville_operations/screens/commons/widgets/section_card.dart';
import 'package:graville_operations/screens/commons/widgets/status_chip.dart';
import 'package:graville_operations/screens/commons/widgets/stat_card.dart';
import 'package:graville_operations/screens/commons/widgets/progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFabOpen = false;
  Widget _buildFab({required IconData icon, required VoidCallback onPressed}) {
    return FloatingActionButton(
      heroTag: icon.toString(),
      backgroundColor: Colors.black,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: _isFabOpen
                    ? Column(
                        key: const ValueKey("expanded"),
                        children: [
                          _buildFab(icon: Icons.person_add, onPressed: () {}),
                          const SizedBox(height: 12),

                          _buildFab(icon: Icons.inventory_2, onPressed: () {}),
                          const SizedBox(height: 12),

                          _buildFab(icon: Icons.rate_review, onPressed: () {}),
                          const SizedBox(height: 12),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _isFabOpen = !_isFabOpen;
                  });
                },
                child: AnimatedRotation(
                  turns: _isFabOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(_isFabOpen ? Icons.close : Icons.add),
                ),
              ),
            ],
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
            pinned: false,
            automaticallyImplyLeading: false,
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(CommonImages.logo, height: 28),
                  const SizedBox(width: 10),
                  const Text(
                    "  Graville Operations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                //Project card
                const SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                //Workers row card
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
                        //color: Colors.green,
                      ),
                    ),
                  ],
                ),
                //Material and completion cards
                const SizedBox(height: 15),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const Expanded(
                        child: SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.inventory, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    "Material Stock",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
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
                                  Text(
                                    "Cement",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "250 bags",
                                    style: TextStyle(
                                      fontSize: 14,
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
                                  Text("Steel", style: TextStyle(fontSize: 14)),
                                  Text(
                                    "1.5 tons",
                                    style: TextStyle(
                                      fontSize: 14,
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
                              Text(
                                "Project Completion",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              //const SizedBox(height: 16),
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
                                    Text(
                                      "68%",
                                      style: TextStyle(
                                        fontSize: 14,
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
                //Task progress card
                const SizedBox(height: 15),
                const SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.task, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Task Progress",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                SizedBox(height: 15),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reviews",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 40,
                          headingRowColor: MaterialStatePropertyAll(
                            Colors.grey.shade200,
                          ),
                          columns: const [
                            DataColumn(label: Text("MESSAGE")),
                            DataColumn(label: Text("REVIEWER")),
                            DataColumn(label: Text("DATE")),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      "Great job on the installation at the new site. All safety protocols followed.",
                                    ),
                                  ),
                                ),
                                const DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "James Paterson\nOperations Manager",
                                    ),
                                  ),
                                ),
                                const DataCell(Text("Feb 10")),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      "Work completed efficiently, but remember to update job status in real-time next time.",
                                    ),
                                  ),
                                ),
                                const DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "Angela Martinez\nField Supervisor",
                                    ),
                                  ),
                                ),
                                const DataCell(Text("Feb 8")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
