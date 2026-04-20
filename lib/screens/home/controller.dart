import 'package:get/get.dart';
import 'package:graville_operations/core/local/store/user_store.dart';
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
}
