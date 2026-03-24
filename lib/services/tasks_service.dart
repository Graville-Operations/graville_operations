import 'dart:convert';
import 'package:graville_operations/models/tasks_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class TaskService {
  static const String baseUrl = "http://localhost:8000/api/v1/tasks";

  // 🔹 Create Task
  static Future<Task> createTask({
    required String title,
    required String description,
    required int siteId,
    required int fieldOperatorId,
    required List<int> assignedTo,
    required String createdAt,
  }) async {
    final url = Uri.parse("$baseUrl/task");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "site_id": siteId,
        "field_operator_id": fieldOperatorId,
        "assigned_to": assignedTo,
        "created_at": createdAt,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  // 🔹 Get All Tasks
  static Future<List<Task>> getTasks() async {
    final url = Uri.parse("$baseUrl/all"); // backend endpoint for list

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Failed to fetch tasks: ${response.body}');
    }
  }

  // 🔹 Update Task
  static Future<Task> updateTask({
    required int taskId,
    String? title,
    String? description,
    int? completion,
    List<int>? assignedTo,
  }) async {
    final url = Uri.parse("$baseUrl/$taskId"); // PATCH endpoint

    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (completion != null) body['completion'] = completion;
    if (assignedTo != null) body['assigned_to'] = assignedTo;

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  // 🔹 Delete Task (optional)
  static Future<void> deleteTask(int taskId) async {
    final url = Uri.parse("$baseUrl/$taskId");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }
}