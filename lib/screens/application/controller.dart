
import 'package:get/get.dart';
import 'package:graville_operations/screens/application/state.dart';

class ApplicationController extends GetxController{
  var state = ApplicationState();
  void changeIndex(int index) {
    state.currentIndex.value = index;
  }
}