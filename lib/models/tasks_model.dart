class Task {
  final int id;
  final String title;
  final String description;
  final int completion;
  final String createdAt; // or DateTime
  final int fieldOperatorId;
  final int siteId;
  final List<int> assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completion,
    required this.createdAt,
    required this.fieldOperatorId,
    required this.siteId,
    required this.assignedTo,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completion: json['completion'],
      createdAt: json['created_at'],
      fieldOperatorId: json['field_operator_id'],
      siteId: json['site_id'],
      assignedTo: List<int>.from(json['assigned_to'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completion': completion,
      'created_at': createdAt,
      'field_operator_id': fieldOperatorId,
      'site_id': siteId,
      'assigned_to': assignedTo,
    };
  }
}