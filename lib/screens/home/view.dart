import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/application/custom_navigator.dart';
import 'package:graville_operations/core/commons/assets/images.dart';
import 'package:graville_operations/core/commons/widgets/custom_circle_button.dart';
import 'package:graville_operations/core/commons/widgets/progress_bar.dart';
import 'package:graville_operations/core/commons/widgets/section_card.dart';
import 'package:graville_operations/core/commons/widgets/stat_card.dart';
import 'package:graville_operations/screens/home/controller.dart';
import 'package:graville_operations/screens/home/widgets/app_drawer.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';
import 'package:graville_operations/screens/store/add_material.dart';
import 'package:graville_operations/screens/store/update_inventory.dart';
import 'package:graville_operations/screens/task_screen/task_screen.dart';
import 'package:graville_operations/screens/workers/add_worker_screen.dart';
import 'package:graville_operations/screens/workers/all_workers_screen.dart';
import 'package:graville_operations/screens/workers/present_workers_screen.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.state.scaffoldKey,
      drawer: controller.state.drawerMenus.isNotEmpty
          ? AppDrawer(drawerMenus: controller.state.drawerMenus)
          : null,
      drawerEnableOpenDragGesture: true,
      floatingActionButton: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (controller.state.isFabOpen.value) ...[
                Tooltip(
                  message: "Add worker",
                  child: CustomCircleButton(
                    icon: Icons.person_add,
                    onPressed: () => context.push(const AddWorkerScreen()),
                  ),
                ),
                // const SizedBox(height: 12),
                // Tooltip(
                //   message: "View sites",
                //   child: CustomCircleButton(
                //     icon: Icons.map_outlined,
                //     onPressed: () => Navigator.of(context).push(
                //       MaterialPageRoute(
                //           builder: (_) => const SitesListScreen()),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 12),
                Tooltip(
                  message: "Hired equipment",
                  child: CustomCircleButton(
                    icon: Icons.build,
                    onPressed: () => context.push(const AddMaterialScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                Tooltip(
                  message: "Receive material",
                  child: CustomCircleButton(
                    icon: Icons.download,
                    onPressed: () =>
                        context.push(const ReceiveMaterialScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                Tooltip(
                  message: "Update inventory",
                  child: CustomCircleButton(
                    icon: Icons.store,
                    onPressed: () => context.push(
                        const UpdateInventoryScreen(preSelectedItem: null)),
                  ),
                ),
                const SizedBox(height: 12),
                Tooltip(
                  message: "Transfer material",
                  child: CustomCircleButton(
                    icon: Icons.local_shipping,
                    onPressed: () =>
                        context.push(const TransferMaterialScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                Tooltip(
                  message: "Create task",
                  child: CustomCircleButton(
                    icon: Icons.add,
                    onPressed: () => context.push(const CreateTaskScreen()),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              FloatingActionButton(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                onPressed: controller.fabStateChange,
                child: AnimatedRotation(
                  turns: controller.state.isFabOpen.value ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          )),
      body: Obx(() => CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                floating: true,
                snap: true,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => controller.state.scaffoldKey.currentState?.openDrawer(),
                  child: Icon(Icons.menu,color: context.theme.iconTheme.color,),
                ),
                automaticallyImplyLeading: false,
                toolbarHeight: 80,
                flexibleSpace: SafeArea(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(CommonImages.logo, height: 40),
                        const SizedBox(width: 4),
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
                        children: [
                          const Text(
                            "Current Project",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Sunrise Apartments",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Workers — tappable stat cards with live data
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: controller.state.workersLoading.value
                              ? _StatShimmer()
                              : GestureDetector(
                                  onTap: () =>
                                      context.push(const AllWorkersScreen()),
                                  child: StatCard(
                                    icon: Icons.people,
                                    title: "Total Workers",
                                    value: "${controller.state.totalWorkers}",
                                    subtitle: "Ever Assigned",
                                    color: const Color(0xff5b7cfa),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: controller.state.attendeesLoading.value
                              ? _StatShimmer()
                              : GestureDetector(
                                  onTap: () => context
                                      .push(const PresentWorkersScreen()),
                                  child: StatCard(
                                    icon: Icons.person,
                                    title: "Present Today",
                                    value: "${controller.state.presentToday}",
                                    subtitle: "Active on Site",
                                    color: const Color(0xff1db954),
                                  ),
                                ),
                        ),
                      ],
                    ),

                    // Material stock and project completion
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Cement"),
                                      Text("250 bags",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Steel"),
                                      Text("1.5 tons",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                              fontWeight: FontWeight.bold),
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

                    // Task progress section
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

                    // Reviews
                    const SizedBox(height: 20),
                    const Text(
                      "Reviews",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                    DataCell(Text(
                                        "Great job on the installation at the new site.")),
                                    DataCell(Text("James Paterson")),
                                    DataCell(Text("Feb 10")),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    DataCell(Text(
                                        "Work completed efficiently, update status next time.")),
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
          )),
    );
  }
}

class _StatShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
