import 'package:graville_operations/core/routes/names.dart';
import 'package:graville_operations/core/utils/http.dart';
import 'package:graville_operations/models/worker_model.dart';

class WorkerService {
  static final HttpUtil _http = HttpUtil();



  static Future<Worker> createWorker(Worker worker) async {
    final data = await _http.post(
      AppRoutes.createWorker,
      data: worker.toCreateJson(),
    );
    return Worker.fromJson(data);
  }



  static Future<List<Worker>> fetchWorkers() async {
    final data = await _http.get(AppRoutes.fetchWorkers);
    return (data as List).map((json) => Worker.fromJson(json)).toList();
  }


  Future<Worker> getWorkerById(int workerId) async {
    final data = await _http.get(AppRoutes.workerById(workerId));
    return Worker.fromJson(data);
  }


  static Future<List<Worker>> fetchWorkersFiltered({
    String? skill,
    required String sortBy,
    required String order,
    required int limit,
    required int offset,
  }) async {
    final data = await _http.get(
      AppRoutes.fetchWorkers,
      queryParameters: {
        if (skill != null) 'skill': skill,
        'sortBy': sortBy,
        'order': order,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );
    return (data as List).map((json) => Worker.fromJson(json)).toList();
  }
}

class WorkerServiceException implements Exception {
  final String message;
  WorkerServiceException(this.message);

  @override
  String toString() => message;
}