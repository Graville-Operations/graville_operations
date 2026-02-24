
import 'dart:ffi';

import 'package:graville_operations/models/inventory/Inventory.dart';
import 'package:graville_operations/models/worker.dart';

class Site{
  final String name;
  final Inventory inventory;
  final Int totalWorkers;
  final Int todayWorker;
  final List<Worker> workers;

  const Site(this.name, this.inventory, this.totalWorkers, this.todayWorker, this.workers);
}