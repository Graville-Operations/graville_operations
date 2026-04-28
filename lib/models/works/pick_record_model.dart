class PickMaterialItemModel {
  final int id;
  final String materialName;
  final double quantity;
  final double? unitPrice;
  final double? totalPrice;

  PickMaterialItemModel({
    required this.id,
    required this.materialName,
    required this.quantity,
    this.unitPrice,
    this.totalPrice,
  });

  factory PickMaterialItemModel.fromJson(Map<String, dynamic> json) {
    return PickMaterialItemModel(
      id: json['id'] ?? 0,
      materialName: json['material_name'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unitPrice: json['unit_price'] != null
          ? (json['unit_price'] as num).toDouble()
          : null,
      totalPrice: json['total_price'] != null
          ? (json['total_price'] as num).toDouble()
          : null,
    );
  }
}

class PickRecordModel {
  final int id;
  final String refId;
  final String workType; // 'INTERNAL' or 'EXTERNAL'
  final String company;
  final String siteName;
  final String status; // 'PENDING', 'DELIVERED', 'CANCELLED'
  final String? notes;
  final String? vehiclePhotoUrl;
  final String? attachmentUrl;
  final String? dropPhotoUrl;
  final String? droppedAt;
  final double? totalAmount;
  final String? submittedBy;
  final int submittedById;
  final String? droppedBy;
  final String? createdAt;
  final List<PickMaterialItemModel> items;

  PickRecordModel({
    required this.id,
    required this.refId,
    required this.workType,
    required this.company,
    required this.siteName,
    required this.status,
    this.notes,
    this.vehiclePhotoUrl,
    this.attachmentUrl,
    this.dropPhotoUrl,
    this.droppedAt,
    this.totalAmount,
    this.submittedBy,
    required this.submittedById,
    this.droppedBy,
    this.createdAt,
    required this.items,
  });

  bool get isInternal => workType.toUpperCase() == 'INTERNAL';
  bool get isExternal => workType.toUpperCase() == 'EXTERNAL';
  bool get isPending => status.toUpperCase() == 'PENDING';

  factory PickRecordModel.fromJson(Map<String, dynamic> json) {
    return PickRecordModel(
      id: json['id'] ?? 0,
      refId: json['ref_id'] ?? '',
      workType: json['work_type'] ?? 'INTERNAL',
      company: json['company'] ?? '',
      siteName: json['site_name'] ?? '',
      status: json['status'] ?? 'PENDING',
      notes: json['notes'],
      vehiclePhotoUrl: json['vehicle_photo_url'],
      attachmentUrl: json['attachment_url'],
      dropPhotoUrl: json['drop_photo_url'],
      droppedAt: json['dropped_at'],
      totalAmount: json['total_amount'] != null
          ? (json['total_amount'] as num).toDouble()
          : null,
      submittedBy: json['submitted_by'],
      submittedById: json['submitted_by_id'] ?? 0,
      droppedBy: json['dropped_by'],
      createdAt: json['created_at'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PickMaterialItemModel.fromJson(e))
          .toList(),
    );
  }
}