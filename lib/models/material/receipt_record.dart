class ReceiptRecord {
  final int id;
  final int inventoryId;
  final String? materialName;
  final String? category;
  final String? unit;
  final int quantityReceived;
  final double amountPaid;
  final String? supplierName;
  final String sourceType; 
  final int? fromSiteId;
  final String? fromSiteName;
  final String? notes;
  final String? photoUrl;
  final DateTime? receivedAt;

  const ReceiptRecord({
    required this.id,
    required this.inventoryId,
    this.materialName,
    this.category,
    this.unit,
    required this.quantityReceived,
    required this.amountPaid,
    this.supplierName,
    required this.sourceType,
    this.fromSiteId,
    this.fromSiteName,
    this.notes,
    this.photoUrl,
    this.receivedAt,
  });

  factory ReceiptRecord.fromJson(Map<String, dynamic> json) {
    return ReceiptRecord(
      id:               json['id']                as int,
      inventoryId:      json['inventory_id']      as int,
      materialName:     json['material_name']     as String?,
      category:         json['category']          as String?,
      unit:             json['unit']              as String?,
      quantityReceived: json['quantity_received'] as int,
      amountPaid:       (json['amount_paid']      as num).toDouble(),
      supplierName:     json['supplier_name']     as String?,
      sourceType:       json['source_type']       as String? ?? 'SUPPLIER',
      fromSiteId:       json['from_site_id']      as int?,
      fromSiteName:     json['from_site_name']    as String?,
      notes:            json['notes']             as String?,
      photoUrl:         json['photo_url']         as String?,
      receivedAt:       json['received_at'] != null
          ? DateTime.tryParse(json['received_at'] as String)
          : null,
    );
  }

  bool get isFromSite => sourceType == 'SITE';
}