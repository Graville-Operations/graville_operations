import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/remote/api/admin.dart';
import 'package:graville_operations/core/remote/dto/requests/site_request.dart';
import 'package:graville_operations/core/utils/enums/ProjectStatus.dart';
import 'package:graville_operations/screens/sites/create/state.dart';

class CreateSiteController extends GetxController {
  var state = CreateSiteState();
  
  void  companyChange(String? companyName) {
    state.selectedCompany?.value = companyName!;
  }
  Future<String> createProject() async{
    String resp = "";
    EasyLoading.show(status: "Creating project");
    if(state.selectedCompany == null){
      throw "Tenderer Name cannot be Empty";
    }
    state.isSubmitting.value = true;
    try{
      CreateProjectRequest request = CreateProjectRequest(
          name: state.nameController.text,
          projectStatus: state.projectStatus?.value ?? "On-going",
          location: state.locationController.text,
          // fieldOperatorId: state.selectedFieldOperator?.value.id,
          fieldOperatorId: 1,
          completionDate: state.completionDate?.value.toString(),
          description: state.tenderNameController.text,
          // tags: state.selectedTags,
          tendererName: state.selectedCompany!.value,
          procuringEntity: state.inquiringEntityController.text);
       ProjectResponse response = await AdminApi.createProject(request);
      EasyLoading.showSuccess("Project created Successfully",duration: Duration(milliseconds: 100));
      state.isSubmitting.value= false;
      resp = "Success";
      return resp;
       
    }catch(e){
      resp = "Error Creating Project";
      state.isSubmitting.value= false;
      log("$resp $e");
      return resp;
    }
  }

  void changeProjectStatus(ProjectStatus s) {
    state.projectStatus?.value = s.name;
  }

  void addTag(String tag) {
    state.selectedTags.add(tag);
  }

  void removeTag(String tag) {
    state.selectedTags.remove(tag);
  }

 
}
