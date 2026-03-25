class GroupResponse {
  final int id;
  final String description;
  final String createdAt;
  final String title;
  final String refId;
  final String modifiedBy;
  final String updatedAt;

  GroupResponse({
    required this.id,
    required this.description,
    required this.createdAt,
    required this.title,
    required this.refId,
    required this.modifiedBy,
    required this.updatedAt,
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      id: json["id"],
      description: json["description"],
      createdAt: json["created_at"],
      title: json["title"],
      refId: json["ref_id"],
      modifiedBy: json["modified_by"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "created_at": createdAt,
    "title": title,
    "ref_id": refId,
    "modified_by": modifiedBy,
    "updated_at": updatedAt,
  };
}