import 'package:flutter/material.dart';
import 'package:graville_operations/application/custom_navigator.dart';
import 'package:graville_operations/core/commons/assets/images.dart';
import 'package:graville_operations/core/commons/widgets/progress_bar.dart';
import 'package:graville_operations/core/commons/widgets/section_card.dart';
import 'package:graville_operations/core/commons/widgets/stat_card.dart';
import 'package:graville_operations/core/remote/api/task_api.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';
import 'package:graville_operations/screens/material/receive_material.dart';
import 'package:graville_operations/screens/material/transfer_material.dart';
import 'package:graville_operations/screens/sites/site_list/sites_list.dart';
import 'package:graville_operations/screens/store/add_material.dart';
import 'package:graville_operations/screens/store/update_inventory.dart';
import 'package:graville_operations/screens/task_screen/alltasks.dart';
import 'package:graville_operations/screens/task_screen/task_details.dart';
import 'package:graville_operations/screens/task_screen/task_screen.dart';
import 'package:graville_operations/screens/workers/add_worker_screen.dart';
import 'package:graville_operations/screens/workers/all_workers_screen.dart';
import 'package:graville_operations/screens/workers/present_workers_screen.dart';
import 'package:graville_operations/services/attendance_service.dart';
import 'package:graville_operations/services/worker_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFabOpen = false;

List<TaskResponse> _recentTasks = [];
bool _tasksLoading = true;
String? _tasksError;

 
  int _totalWorkers = 0;
  int _presentToday = 0;
  bool _statsLoading = true;
  
  
 List<TaskResponse> get _homeTasks => _recentTasks.take(5).toList();

double get _overallCompletion {
  if (_recentTasks.isEmpty) return 0.0;
  final total = _recentTasks.fold<int>(0, (sum, t) => sum + t.completion);
  return total / (_recentTasks.length * 100);
}

  

  @override
void initState() {
  super.initState();
  _loadStats();
  _loadTasks(); // ← add this
}

  Future<void> _loadStats() async {
    setState(() => _statsLoading = true);
    try {
      final results = await Future.wait([
        WorkerService.fetchWorkers(),
        AttendanceService.fetchTodayPresentIds(),
      ]);
      if (!mounted) return;
      setState(() {
        _totalWorkers  = (results[0] as List).length;
        _presentToday  = (results[1] as List).length;
        _statsLoading  = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _statsLoading = false);
    }
  }

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
              message: "View sites",
              child: miniFab(
                Icons.map_outlined,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SitesListScreen()),
                ),
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
                () => context.push(const UpdateInventoryScreen(preSelectedItem: null)),
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
            Tooltip(
              message: "Create task",
              child: miniFab(
                Icons.add,
                () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
                ).then((_) => _loadTasks()),
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
                      child: _statsLoading
                          ? _StatShimmer()
                          : GestureDetector(
                              onTap: () => context.push(const AllWorkersScreen()),
                              child: StatCard(
                                icon: Icons.people,
                                title: "Total Workers",
                                value: "$_totalWorkers",
                                subtitle: "Ever Assigned",
                                color: const Color(0xff5b7cfa),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statsLoading
                          ? _StatShimmer()
                          : GestureDetector(
                              onTap: () => context.push(const PresentWorkersScreen()),
                              child: StatCard(
                                icon: Icons.person,
                                title: "Present Today",
                                value: "$_presentToday",
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
                                    Builder(builder: (_) {
                             final avg = _tasksLoading || _recentTasks.isEmpty  ? 0.0
                                  : _recentTasks.fold<int>(0, (sum, t) => sum + t.completion) /
                                     _recentTasks.length;
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
                                    _tasksLoading
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

                // Task progress section
                const SizedBox(height: 15),
               SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.task, size: 18),
                        const SizedBox(width: 8),
                        const Text("Task Progress",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        if (!_tasksLoading && _recentTasks.length > 5)
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AllTasksScreen()),
                              ).then((_) => _loadTasks()),
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
              
                    // Loading state
                    if (_tasksLoading)
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
              
                    // Error state
                    else if (_tasksError != null)
                      Row(
                        children: [
                          const Text("Failed to load",
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                          TextButton(
                            onPressed: _loadTasks,
                            child: const Text("Retry",
                                style: TextStyle(
                                    color: Color(0xff5b7cfa), fontSize: 12)),
                          ),
                        ],
                      )
              
                    // Empty state
                    else if (_recentTasks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text("No tasks yet",
                              style: TextStyle(color: Colors.grey)),
                        ),
                      )
              
                    // Tasks list (max 5 shown inline, tappable rows)
                    else ...[
                      // Overall completion bar
                      Row(
                        children: [
                          const Text("Overall",
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const Spacer(),
                          Text(
                            "${(_overallCompletion * 100).round()}%",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _overallCompletion,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Color(0xff5b7cfa)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
              
                      // Individual task rows (compact, tappable)
                      ..._homeTasks.map((task) {
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
              
                      // "View all" footer
                      if (_recentTasks.length > 5)
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
                              "View all ${_recentTasks.length} tasks →",
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
      ),
    );
  }
  
 Future<void> _loadTasks() async {
  setState(() { _tasksLoading = true; _tasksError = null; });
  try {
    final tasks = await TaskApi.getAllTasks();
    print('✅ Loaded ${tasks.length} tasks');
    tasks.sort((a, b) {
      int order(TaskResponse t) {
        if (t.completion > 0 && t.completion < 100) return 0;
        if (t.completion == 0) return 1;
        return 2;
      }
      return order(a).compareTo(order(b));
    });
    if (!mounted) return;
    setState(() { _recentTasks = tasks; _tasksLoading = false; });
  } catch (e) {
    print('❌ Load error: $e');
    if (!mounted) return;
    setState(() { _tasksError = e.toString(); _tasksLoading = false; });
  }
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