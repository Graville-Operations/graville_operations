class CreateTaskRequest {
  final String title;
  final int assignedTo;
  final int fieldOperatorId;
  final bool completion;

  CreateTaskRequest({
    required this.title,
    required this.assignedTo,
    required this.fieldOperatorId,
    required this.completion, required String description, required String createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "assigned_to": assignedTo,
      "field_operator_id": fieldOperatorId,
      "completion": completion,
    };
  }
}