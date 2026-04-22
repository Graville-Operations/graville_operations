
import 'package:get/get.dart';
import 'package:graville_operations/core/remote/api/admin.dart';
import 'package:graville_operations/models/site/site_model.dart';
import 'package:graville_operations/screens/projects/dashboard/state.dart';

class ProjectDashboardController extends GetxController {
  var state = ProjectDashboardState();
  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }
  @override
  void dispose() {
    super.dispose();
    state.searchController.dispose();
  }
  
  
  Future<void> loadProjects() async {
    state.fetchingProjects.value = true;
    try{
      var results = await AdminApi.fetchProjects();
      print(results.reversed);
      state.projects.value = results;
      _updateCounts();
      state.fetchingProjects.value = false;
    }catch(e){
      state.fetchingProjectsError.value = "Error occurred while fetching projects";
      state.fetchingProjects.value = false;
    }
  }

  List<SiteModel> get filteredProjects {
    return state.projects.where((s) {
      final matchFilter =
          state.filter.value == 'All' ||
              s.projectStatus.toLowerCase() == state.filter.value.toLowerCase();
      final q = state.search.value.toLowerCase();
      final matchSearch = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.location.toLowerCase().contains(q) ||
          s.inquiringEntity!.toLowerCase().contains(q);
      return matchFilter && matchSearch;
    }).toList();
  }
  void setFilter(String filter) {
    state.filter.value = filter;
  }

  void _updateCounts() {
    state.totalProjects.value = state.projects.length;
    state.totalOngoingProjects.value =
        state.projects.where((p) => p.projectStatus.toLowerCase() == 'On-going').length;
    state.totalCompletedProjects.value =
        state.projects.where((p) => p.projectStatus.toLowerCase() == 'Completed').length;
    state.totalPausedProjects.value =
        state.projects.where((p) => p.projectStatus.toLowerCase() == 'Delayed').length;
  }

  void updateSerach(String value) {
    state.search.value = value;
  }

  void onFilterChange(String filter) {
    state.filter.value = filter;
  }

}