import 'package:dio/dio.dart';
import 'package:graville_operations/core/remote/dto/requests/create_tasks.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart' hide CreateTaskRequest;
import 'package:graville_operations/core/remote/routes/task_route.dart';
import 'package:graville_operations/core/remote/dto/response/base_response.dart';
import 'package:graville_operations/core/utils/http.dart';

class TaskApi {
  static Future<List<TaskResponse>> getAllTasks() async {
    var response = await HttpUtil().get(TaskRoute.getAllTasks);
    return (response as List).map((e) => TaskResponse.fromJson(e)).toList();
  }

  //create task
 static Future<void> createTask(CreateTaskRequest request) async {
  try {
    await HttpUtil().post(
      TaskRoute.createTask,
      data: request.toJson(),
    );
  } on DioException catch (e) {
    if (e.response?.statusCode == 400) {
      final detail = e.response?.data['detail'] ?? 'Task already exists.';
      throw DuplicateTaskException(detail);
    }
    rethrow;
  }
}
}

//update task
Future<BaseResponse> updateTask(
  int id,
  CreateTaskRequest request,
) async {
  var response = await HttpUtil().put(
    "${TaskRoute.updateTask}/$id",
    data: request.toJson(),
  );

  return BaseResponse.fromJson(response, null);
}

//delete task
Future<void> deleteTask(int id) async {
  await HttpUtil().delete(
    "${TaskRoute.deleteTask}/$id",
  );
}
class DuplicateTaskException implements Exception {
  final String message;
  const DuplicateTaskException(this.message);
}