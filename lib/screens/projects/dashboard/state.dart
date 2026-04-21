
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graville_operations/models/site/site_model.dart';

class ProjectDashboardState{
  RxBool fetchingProjects = false.obs;
  RxString fetchingProjectsError = "".obs;
  RxInt totalProjects = 0.obs;
  RxInt totalOngoingProjects = 0.obs;
  RxInt totalCompletedProjects = 0.obs;
  RxInt totalPausedProjects = 0.obs;
  RxList<SiteModel> projects = <SiteModel>[].obs;
  RxString filter = "All".obs;
  RxString search = "".obs;
  final TextEditingController searchController = TextEditingController();
  RxList<String> filters = <String>['All', 'On-going', 'Completed', 'Paused'].obs;

}