class AssignedWorker {
  final int id;
  final String firstName;
  final String lastName;
  final String skillType;

  AssignedWorker({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.skillType,
  });

  String get fullName => '$firstName $lastName';

  factory AssignedWorker.fromJson(Map<String, dynamic> json) {
    return AssignedWorker(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      skillType: json['skill_type'] ?? '',
    );
  }
}

class FieldOperator {
  final int id;
  final String firstName;
  final String lastName;

  FieldOperator({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  factory FieldOperator.fromJson(Map<String, dynamic> json) {
    return FieldOperator(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}

class TaskResponse {
  final int id;
  final String title;
  final String? description;
  final List<AssignedWorker> assignedTo;
  final FieldOperator? fieldOperator;
  final DateTime createdAt;
  final int completion;

  TaskResponse({
    required this.id,
    required this.title,
    this.description,
    required this.assignedTo,
    this.fieldOperator,
    required this.createdAt,
    required this.completion,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assigned_to'] != null
          ? (json['assigned_to'] as List)
              .map((w) => AssignedWorker.fromJson(w as Map<String, dynamic>))
              .toList()
          : [],
      fieldOperator: json['field_operator'] != null
          ? FieldOperator.fromJson(json['field_operator'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      completion: json['completion'] ?? 0,
    );
  }
}

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
      "description": description,
      "assigned_to": assignedTo,
      "field_operator_id": fieldOperatorId,
      "completion": completion,
      "site_id": siteId,
    };
  }
}