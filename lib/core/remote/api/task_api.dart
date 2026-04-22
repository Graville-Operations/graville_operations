import 'package:graville_operations/core/remote/dto/requests/create_tasks.dart';
import 'package:graville_operations/core/remote/dto/response/create_task.dart' hide CreateTaskRequest;
import 'package:graville_operations/core/remote/routes/task_route.dart';
import 'package:graville_operations/core/remote/dto/response/base_response.dart';
import 'package:graville_operations/core/utils/http.dart';

class TaskApi {
//get all tasks
  static Future<List<TaskResponse>> getAllTasks() async {
    var response = await HttpUtil().get(TaskRoute.getAllTasks);
    return (response as List).map((e) => TaskResponse.fromJson(e)).toList();
  }

  //create task
  static Future<void> createTask(CreateTaskRequest request) async {
    await HttpUtil().post(
      TaskRoute.createTask,
      data: request.toJson(),
    );
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
Future<BaseResponse> deleteTask(int id) async {
  var response = await HttpUtil().delete(
    "${TaskRoute.deleteTask}/$id",
  );

  return BaseResponse.fromJson(response, null);
}
