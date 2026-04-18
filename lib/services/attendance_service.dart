import 'dart:io';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/core/utils/http.dart';

class AttendanceServiceException implements Exception {
  final String message;
  AttendanceServiceException(this.message);
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
}