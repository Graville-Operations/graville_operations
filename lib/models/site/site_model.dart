class SiteModel {
  final int? id;
  final String name;
  final String location;
  final String projectStatus;
  final String? siteStatus;
  final String? completionDate;
  final String? description;
  final String? tenderName;
  final String? inquiringEntity;
  final List<String> tags;
  final double? latitude;
  final double? longitude;
  final int? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final int? updatedBy;
  final int? fieldOperatorId;

  const SiteModel({
    this.id,
    required this.name,
    required this.location,
    required this.projectStatus,
    this.siteStatus,
    this.completionDate,
    this.description,
    this.tenderName,
    this.inquiringEntity,
    this.tags = const [],
    this.latitude,
    this.longitude,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.fieldOperatorId,
  });

  factory SiteModel.fromJson(Map<String, dynamic> j) => SiteModel(
        id               : j['id'],
        name             : j['name'],
        location         : j['location'] ?? '',
        projectStatus    : j['project_status'],
        siteStatus       : j['site_status'],
        completionDate   : j['completion_date'],
        description      : j['description'],
        tenderName       : j['tender_name'],
        inquiringEntity  : j['inquiring_entity'],
        tags             : List<String>.from(j['tags'] ?? []),
        latitude         : (j['latitude'] as num?)?.toDouble(),
        longitude        : (j['longitude'] as num?)?.toDouble(),
        createdBy        : j['created_by'],
        createdAt        : j['created_at'],
        updatedAt        : j['updated_at'],
        updatedBy        : j['updated_by'],
        fieldOperatorId  : j['field_operator_id'],
      );

  Map<String, dynamic> toJson() => {
        'name'             : name,
        'location'         : location,
        'project_status'   : projectStatus,
        'site_status'      : siteStatus,
        'completion_date'  : completionDate,
        'description'      : description,
        'tender_name'      : tenderName,
        'inquiring_entity' : inquiringEntity,
        'tags'             : tags,
        'latitude'         : latitude,
        'longitude'        : longitude,
        'created_by'       : createdBy,
      };

  /// For PATCH — only sends fields that are non-null
  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    if (name.isNotEmpty)          map['name']              = name;
    if (location.isNotEmpty)      map['location']          = location;
    if (projectStatus.isNotEmpty) map['project_status']    = projectStatus;
    if (siteStatus != null)       map['site_status']       = siteStatus;
    if (completionDate != null)   map['completion_date']   = completionDate;
    if (description != null)      map['description']       = description;
    if (tenderName != null)       map['tender_name']       = tenderName;
    if (inquiringEntity != null)  map['inquiring_entity']  = inquiringEntity;
    if (tags.isNotEmpty)          map['tags']              = tags;
    if (latitude != null)         map['latitude']          = latitude;
    if (longitude != null)        map['longitude']         = longitude;
    return map;
  }
}