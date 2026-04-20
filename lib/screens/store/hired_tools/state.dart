

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graville_operations/models/store.dart';

class AddHiredToolState{
  final formKey = GlobalKey<FormState>();
  final Rx<Tool?> selectedTool = Rx<Tool?>(null);
  final RxList<Tool> tools = <Tool>[].obs;
  final Rx<DateTime?> rentalStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> rentalEndDate = Rx<DateTime?>(null);
  final RxString billingType = 'DAILY'.obs;

  final rateController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final supplierController = TextEditingController();
  final supplierPhoneController = TextEditingController();
  final notesController = TextEditingController();
}