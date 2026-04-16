import 'dart:io';
import 'package:dio/dio.dart';
import 'package:graville_operations/core/utils/constants.dart';

class AttendanceServiceException implements Exception {
  final String message;
  AttendanceServiceException(this.message);
}

class AttendanceService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: appBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

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
      await _dio.post('/workers/attendance/check-in', data: formData);
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? 'Check-in failed. Please try again.');
    }
  }

  /// Returns worker IDs checked in today.
  static Future<List<int>> fetchTodayPresentIds() async {
    try {
      final response = await _dio.get('/workers/attendance/today');
      return (response.data as List)
          .map<int>((r) => r['worker_id'] as int)
          .toList();
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? "Failed to fetch today's attendance.");
    }
  }

  static Future<void> checkInWorkerBulk({required int workerId}) async {
    try {
      final formData = FormData.fromMap({'worker_id': workerId});
      await _dio.post('/workers/attendance/check-in/bulk', data: formData);
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
      await _dio.patch('/workers/attendance/verify', data: formData);
    } on DioException catch (e) {
      throw AttendanceServiceException(
          e.response?.data?['detail'] ?? 'Verification failed for worker $workerId.');
    }
  }
}