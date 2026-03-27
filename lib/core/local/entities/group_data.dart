
class GroupData{
  int? id;
  String? description;
  String? createdAt;
  String? title;
  String? refId;
  String? modifiedBy;
  String? updatedAt;

  GroupData({
    this.id,
    this.description,
    this.createdAt,
    this.title,
    this.refId,
    this.modifiedBy,
    this.updatedAt
});


  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
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