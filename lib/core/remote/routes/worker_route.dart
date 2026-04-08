class TaskRoute {
  static const String _prefix = "/workers";

  static const String getAllTasks = "$_prefix/";
  static const String createTask = "$_prefix/list";
  static const String updateTask = "$_prefix/search"; 
  static const String deleteTask = "$_prefix/{id}"; 
}