import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
import 'package:graville_operations/core/remote/api/task_api.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart';
import 'package:graville_operations/screens/home/state.dart';
import 'package:graville_operations/services/attendance_service.dart';
import 'package:graville_operations/services/worker_service.dart';

class HomeScreenController extends GetxController {
  var state = HomeState();
  static const _bottomNavNames = {'home', 'workers', 'inventory', 'account'};

  @override
  void onInit() {
    super.onInit();
    loadDrawerDetails();
    loadStats();
    loadTasks();
  }

  void fabStateChange() {
    state.isFabOpen.value = !state.isFabOpen.value;
  }

  void loadDrawerDetails() {
    final saved = UserStore.to.getMenus();
    state.drawerMenus.assignAll(
      saved.where((m) => !_bottomNavNames.contains(m.name)).toList(),
    );
  }

  Future<void> loadStats() async {
    state.workersLoading.value = true;
    state.attendeesLoading.value = true;
    try {
      var workers = await WorkerService.fetchWorkers();
      var attendees = await AttendanceService.fetchTodayPresentIds();
      state.totalWorkers.value = (workers as List).length;
      state.presentToday.value = (attendees as List).length;
      state.workersLoading.value = false;
      state.attendeesLoading.value = false;
    } catch (_) {
      state.workersLoading.value = false;
      state.attendeesLoading.value = false;
    }
  }
  Future<void> loadTasks() async {
    state.tasksLoading.value = true;
    try {
      List<TaskResponse> tasks  = await TaskApi.getAllTasks();
      tasks.sort((a, b) {
        int order(TaskResponse t) {
          if (t.completion > 0 && t.completion < 100) return 0;
          if (t.completion == 0) return 1;
          return 2;
        }
        return order(a).compareTo(order(b));
      });
      state.recentTasks.assignAll(tasks);
      state.homeTasks.assignAll(tasks.take(5).toList());
      if (tasks.isEmpty) {
        state.overallCompletion.value = 0.0;
      } else {
        final total = tasks.fold<int>(0, (sum, t) => sum + t.completion);
        state.overallCompletion.value = total / (tasks.length * 100);
      }
      state.tasksLoading.value = false;
    } catch (e) {
      print('❌ Task error: $e');
      state.taskFetchError.value = "Failed to load Tasks, Try again";
      state.tasksLoading.value = false;
    }
  }
}

