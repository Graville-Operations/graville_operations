

import 'package:get/get.dart';
import 'package:graville_operations/screens/store/hired_tools/state.dart';

class AddHiredToolController extends GetxController{
  var state = AddHiredToolState();

  void updateRentalRange(DateTime start, DateTime end) {
    state.rentalStartDate.value = start;
    state.rentalEndDate.value = end;
  }

  bool validateForm() {
    return state.formKey.currentState?.validate() ?? false;
  }

  Future<void> addHiredTool()async{
  }
}