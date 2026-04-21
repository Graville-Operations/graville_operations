class CreateTaskRequest {
  final String title;
  final List<int> assignedTo;
  final int fieldOperatorId;
  final int completion;
  final int siteId;
  final String description;
  final DateTime createdAt;

  CreateTaskRequest({
    required this.title,
    required this.assignedTo,
    required this.fieldOperatorId,
    required this.completion,
    required this.siteId,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description?? "",
      "assigned_to": assignedTo,
      "field_operator_id": fieldOperatorId,
      "completion": completion,
      "site_id": siteId?? 0,
    };
  }
}