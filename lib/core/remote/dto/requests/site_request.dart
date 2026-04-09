

class CreateProjectRequest {
  final String name;
  final String projectStatus;
  final String? siteStatus;
  final String? completionDate;
  final String location;
  final double? longitude;
  final double? latitude;
  final int fieldOperatorId;
  final String? description;
  final List<String>? tags;
  final String? tenderName;
  final String? inquiringEntity;

  CreateProjectRequest({
    required this.name,
    required this.projectStatus,
    this.siteStatus = "Active",
    this.completionDate,
    required this.location,
    this.longitude,
    this.latitude,
    required this.fieldOperatorId,
    this.description,
    this.tags,
    this.tenderName,
    this.inquiringEntity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'project_status': projectStatus,
      'site_status': siteStatus,
      'completion_date': completionDate,
      'location': location,
      'longitude': longitude,
      'latitude': latitude,
      'field_operator_id': fieldOperatorId,
      'description': description,
      'tags': tags,
      'tender_name': tenderName,
      'inquiring_entity': inquiringEntity,
    };
  }
}

class ProjectResponse {
  final int id;
  final String name;
  final String location;
  final String projectStatus;
  final String siteStatus;
  final String createdAt;
  final String? completionDate;
  final String? updatedAt;
  final int? updatedBy;
  final List<String> tags;
  final String? description;
  final String? tenderName;
  final String? inquiringEntity;
  final int fieldOperatorId;
  final double? latitude;
  final double? longitude;

  ProjectResponse({
    required this.id,
    required this.name,
    required this.location,
    required this.projectStatus,
    required this.siteStatus,
    required this.createdAt,
    this.completionDate,
    this.updatedAt,
    this.updatedBy,
    this.tags = const [],
    this.description,
    this.tenderName,
    this.inquiringEntity,
    required this.fieldOperatorId,
    this.latitude,
    this.longitude,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      projectStatus: json['project_status'] ?? '',
      siteStatus: json['site_status'] ?? 'Active',
      createdAt: json['created_at'] ?? '',
      completionDate: json['completion_date'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'],
      tags: List<String>.from(json['tags'] ?? []),
      description: json['description'],
      tenderName: json['tender_name'],
      inquiringEntity: json['inquiring_entity'],
      fieldOperatorId: json['field_operator_id'] ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}