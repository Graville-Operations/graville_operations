import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graville_operations/core/utils/enums/ProjectStatus.dart';

class CreateSiteState {
  TextEditingController nameController            = TextEditingController();
  TextEditingController locationController        = TextEditingController();
  TextEditingController tenderNameController      = TextEditingController();
  TextEditingController inquiringEntityController = TextEditingController();

  RxList<String>   selectedTags    = <String>[].obs;
  RxString         selectedCompany = ''.obs;
  RxBool           isSubmitting    = false.obs;
  Rx<ProjectStatus> projectStatus  = ProjectStatus.onGoing.obs;  
  Rx<DateTime?>    completionDate  = Rx<DateTime?>(null);        
}