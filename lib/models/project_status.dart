import 'package:flutter/material.dart';

enum ProjectStatus { onSchedule, ahead, behind, completed, delayed }

ProjectStatus calculateStatus(double expected, double actual, bool finished) {
  if (finished) return ProjectStatus.completed;
  if (actual >= expected + 0.1) return ProjectStatus.ahead;
  if (actual <= expected - 0.1) return ProjectStatus.behind;
  return ProjectStatus.onSchedule;
}
