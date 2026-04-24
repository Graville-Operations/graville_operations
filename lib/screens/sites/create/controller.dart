import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/remote/api/admin.dart';
import 'package:graville_operations/core/remote/dto/requests/site_request.dart';
import 'package:graville_operations/core/utils/enums/ProjectStatus.dart';
import 'package:graville_operations/screens/sites/create/state.dart';
import 'package:graville_operations/screens/sites/create/view.dart';

class CreateSiteController extends GetxController {
  final state = CreateSiteState();

  void companyChange(String? companyName) {
    if (companyName != null) state.selectedCompany.value = companyName;
  }

  void changeProjectStatus(ProjectStatus s) {
    state.projectStatus.value = s;          
  }

  void setCompletionDate(DateTime date) {
    state.completionDate.value = date;       
  }

  void addTag(String tag) {
    if (!state.selectedTags.contains(tag)) state.selectedTags.add(tag);
  }

  void removeTag(String tag) {
    state.selectedTags.remove(tag);
  }

  Future<String> createProject() async {
    if (state.selectedCompany.value.trim().isEmpty) {
      EasyLoading.showError('Please select a Tenderer Name');
      return 'Error';
    }

    state.isSubmitting.value = true;
    EasyLoading.show(status: 'Creating project...');

    try {
      final request = CreateProjectRequest(
        name:            state.nameController.text.trim(),
        projectStatus:   state.projectStatus.value.apiValue,
        location:        state.locationController.text.trim(),
        fieldOperatorId: 1,
        completionDate:  state.completionDate.value?.toIso8601String(),
        description:     state.tenderNameController.text.trim(),
        tendererName:    state.selectedCompany.value,
        procuringEntity: state.inquiringEntityController.text.trim(),
      );

      final response = await AdminApi.createProject(request);
      EasyLoading.showSuccess('Project created successfully!');
      state.isSubmitting.value = false;
      return 'Success';
    } catch (e) {
      state.isSubmitting.value = false;
      EasyLoading.showError('Failed to create project');
      log('createProject error: $e');
      return 'Error';
    }
  }
}