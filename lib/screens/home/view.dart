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
import 'package:graville_operations/screens/material/receipts_list_screen.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';
import 'package:graville_operations/screens/material/transfers_list_screen.dart';
import 'package:graville_operations/screens/sites/site_list/sites_list.dart';
import 'package:graville_operations/screens/store/add_material.dart';
import 'package:graville_operations/screens/store/update_inventory.dart';
import 'package:graville_operations/screens/task_screen/alltasks.dart';
import 'package:graville_operations/screens/task_screen/task_details.dart';
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
                const SizedBox(height: 12),
                Tooltip(
                  message: "View sites",
                  child: CustomCircleButton(
                    icon: Icons.map_outlined,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SitesListScreen()),
                    ),
                  ),
                ),
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
                  message: "Receive material list",
                  child: CustomCircleButton(
                    icon: Icons.list,
                    onPressed: () =>
                        context.push(const ReceiptsListScreen()),
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
                  message: "Transfer material",
                  child: CustomCircleButton(
                    icon: Icons.transfer_within_a_station,
                    onPressed: () =>
                        context.push(const TransfersListScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                Tooltip(
                  message: "Create task",
                  child: CustomCircleButton(
                    icon: Icons.add_task,
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
                                        Builder(builder: (_) {
                                          final avg = controller.state.tasksLoading.value || controller.state.recentTasks.isEmpty
                                              ? 0.0
                                              : controller.state.recentTasks.fold<int>(0, (sum, t) => sum + t.completion) /
                                                controller.state.recentTasks.length;
                                          final display = avg.round();
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: avg / 100,
                                                strokeWidth: 8,
                                                color: avg >= 100
                                                    ? const Color(0xff1db954)
                                                    : avg >= 60
                                                        ? Colors.orange
                                                        : const Color(0xff5b7cfa),
                                                backgroundColor: Colors.grey.shade300,
                                              ),
                                             controller.state.tasksLoading.value
                                                ? const SizedBox(
                                                    width: 16, height: 16,
                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                  )
                                                : Text(
                                                    "$display%",
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                            ],
                                          );
                                        }),
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
                          Row(
                            children: [
                              const Icon(Icons.task, size: 18),
                              const SizedBox(width: 8),
                              const Text("Task Progress",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              if (!controller.state.tasksLoading.value && controller.state.recentTasks.length > 5)
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AllTasksScreen()),
                                  ),
                                  child: const Text("View All",
                                      style: TextStyle(
                                        color: Color(0xff5b7cfa),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          if (controller.state.tasksLoading.value)
                            ...List.generate(3, (_) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ))

                          else if (controller.state.taskFetchError.value.isNotEmpty)
                            Row(
                              children: [
                                const Text("Failed to load",
                                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                                TextButton(
                                  onPressed: controller.loadStats,
                                  child: const Text("Retry",
                                      style: TextStyle(
                                          color: Color(0xff5b7cfa), fontSize: 12)),
                                ),
                              ],
                            )

                          else if (controller.state.recentTasks.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text("No tasks yet",
                                      style: TextStyle(color: Colors.grey)),
                                ),
                              )

                            else ...[
                                Row(
                                  children: [
                                    const Text("Overall",
                                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    const Spacer(),
                                    Text(
                                    "${(controller.state.overallCompletion.value * 100).round()}%",
                                      style: const TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: controller.state.overallCompletion.value,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor:
                                    const AlwaysStoppedAnimation<Color>(Color(0xff5b7cfa)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                ...controller.state.homeTasks.map((task) {
                                  final color = task.completion >= 100
                                      ? const Color(0xff1db954)
                                      : task.completion >= 60
                                      ? Colors.orange
                                      : const Color(0xff5b7cfa);
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => TaskDetailScreen(task: task),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  task.title,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "${task.completion}%",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: color,
                                                ),
                                              ),
                                              const Icon(Icons.chevron_right,
                                                  size: 14, color: Colors.grey),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: task.completion / 100,
                                              minHeight: 5,
                                              backgroundColor: Colors.grey.shade100,
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(color),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                if (controller.state.recentTasks.length > 5)
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => const AllTasksScreen()),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "View all ${controller.state.recentTasks.length} tasks →",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xff5b7cfa),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
