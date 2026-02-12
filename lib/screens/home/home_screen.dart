import 'package:flutter/material.dart';
import 'package:graville_operations/models/project_status.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';
import 'package:graville_operations/screens/commons/widgets/section_card.dart';
import 'package:graville_operations/screens/commons/widgets/status_chip.dart';
import 'package:graville_operations/screens/commons/widgets/stat_card.dart';
import 'package:graville_operations/screens/commons/widgets/progress_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.add),
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
            title: Row(
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
                Row(
                  children: [
                    const Expanded(
                      child: StatCard(
                        icon: Icons.inventory,
                        title: "Material Stock",
                        value: "Cement    250 bags\nSteel    1.5 tons",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SectionCard(
                        child: Column(
                          children: [
                            const Text(
                              "Project Completion",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            CircularProgressIndicator(
                              value: 0.68,
                              strokeWidth: 8,
                              color: Colors.orange,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 6),
                            const Text("68%"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Task progress card
                const SizedBox(height: 15),
                const SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task Progress",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                const SizedBox(height: 15),
                const SectionCard(child: Row()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
