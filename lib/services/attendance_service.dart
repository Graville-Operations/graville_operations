
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/core/utils/http.dart';

class AttendanceServiceException implements Exception {
  final String message;
  AttendanceServiceException(this.message);
}

class DayAttendance {
  final DateTime date;
  final int presentCount;
  final List<AttendanceWorkerSummary> workers;

  const DayAttendance({
    required this.date,
    required this.presentCount,
    required this.workers,
  });

  factory DayAttendance.fromJson(Map<String, dynamic> json) => DayAttendance(
        date:         DateTime.parse(json['date'] as String),
        presentCount: json['present_count'] as int,
        workers: (json['workers'] as List)
            .map((w) => AttendanceWorkerSummary.fromJson(w as Map<String, dynamic>))
            .toList(),
      );
}

class AttendanceWorkerSummary {
  final int workerId;
  final String name;
  final String skillType;

  const AttendanceWorkerSummary({
    required this.workerId,
    required this.name,
    required this.skillType,
  });

  factory AttendanceWorkerSummary.fromJson(Map<String, dynamic> json) =>
      AttendanceWorkerSummary(
        workerId:  json['worker_id'] as int,
        name:      json['name'] as String,
        skillType: json['skill_type'] as String,
      );
}

class WeekAttendance {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalWorkers;
  final List<DayAttendance> days;

  const WeekAttendance({
    required this.weekStart,
    required this.weekEnd,
    required this.totalWorkers,
    required this.days,
  });

  factory WeekAttendance.fromJson(Map<String, dynamic> json) => WeekAttendance(
        weekStart:    DateTime.parse(json['week_start'] as String),
        weekEnd:      DateTime.parse(json['week_end'] as String),
        totalWorkers: json['total_workers'] as int,
        days: (json['days'] as List)
            .map((d) => DayAttendance.fromJson(d as Map<String, dynamic>))
            .toList(),
      );
}

class AttendanceService {
  static final HttpUtil _http = HttpUtil();

  static Future<void> checkInWorker({
    required int workerId,
    required File photo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'worker_id': workerId,
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: 'checkin_${workerId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });
      await _http.postForm(AppRoutes.checkIn, data: formData);
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? 'Check-in failed. Please try again.');
    }
  }

  static Future<List<int>> fetchTodayPresentIds() async {
    try {
      final data = await _http.get(AppRoutes.todayAttendance);
      return (data as List).map<int>((r) => r['worker_id'] as int).toList();
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? "Failed to fetch today's attendance.");
    }
  }

  static Future<void> checkInWorkerBulk({required int workerId}) async {
    try {
      final formData = FormData.fromMap({'worker_id': workerId});
      await _http.postForm(AppRoutes.checkInBulk, data: formData);
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? 'Bulk check-in failed for worker $workerId.');
    }
  }

  static Future<void> verifyWorker({
    required int workerId,
    required File photo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'worker_id': workerId,
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: 'verify_${workerId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });
      await _http.patch(AppRoutes.verifyAttendance, data: formData);
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? 'Verification failed for worker $workerId.');
    }
  }
  static Future<WeekAttendance> fetchWeekAttendance({DateTime? weekStart}) async {
    try {
      final data = await _http.get(
        AppRoutes.weekAttendance,  
        queryParameters: weekStart != null
            ? {'week_start': weekStart.toIso8601String().split('T').first}
            : null,
      );
      return WeekAttendance.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? 'Failed to fetch weekly attendance.');
    }
  }
}