class TaskResponse {
  final int id;
  final String title;
  final int assignedTo;
  final int fieldOperatorId;
  final bool completion;

  TaskResponse({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.fieldOperatorId,
    required this.completion,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'],
      title: json['title'],
      assignedTo: json['assigned_to'],
      fieldOperatorId: json['field_operator_id'],
      completion: json['completion'],
    );
  }
}