
import 'package:get/get.dart';
import 'package:graville_operations/screens/projects/dashboard/controller.dart';

class ProjectDashboardBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectDashboardController>(() => ProjectDashboardController());
  }
}