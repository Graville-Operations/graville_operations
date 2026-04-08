class TaskResponse {
  final int id;
  final String title;
  final String? description;
  final List<int> assignedTo; 
  final int? fieldOperatorId;
  final DateTime createdAt;
  final int completion;

  TaskResponse({
    required this.id,
    required this.title,
    this.description,
    required this.assignedTo,
    this.fieldOperatorId,
    required this.createdAt,
    required this.completion,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assigned_to'] != null 
          ? List<int>.from(json['assigned_to']) 
          : [],
      fieldOperatorId: json['field_operator_id'],
      createdAt: DateTime.parse(json['created_at']),
      completion: json['completion'] ?? 0,
    );
  }
}