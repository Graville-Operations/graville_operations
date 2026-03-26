class TaskRoute {
  static const String _prefix = "/tasks";

  static const String getAllTasks = "$_prefix/all_tasks";
  static const String createTask = "$_prefix/create_task";
  static const String updateTask = "$_prefix/update_task"; // + /{id}
  static const String deleteTask = "$_prefix/delete_task"; // + /{id}
}