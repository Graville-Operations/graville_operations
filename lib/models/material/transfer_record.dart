class TransferRecord {
  final int id;
  final String? material;
  final String? materialUnit;
  final String? category;
  final String? fromSite;
  final String? toSite;
  final double quantity;
  final double pricePerUnit;
  final double totalValue;
  final String? transportMode;
  final String? driverDetails;
  final String? notes;
  final String? image;
  final DateTime? transferDate;

  const TransferRecord({
    required this.id,
    this.material,
    this.materialUnit,
    this.category,
    this.fromSite,
    this.toSite,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalValue,
    this.transportMode,
    this.driverDetails,
    this.notes,
    this.image,
    this.transferDate,
  });

  factory TransferRecord.fromJson(Map<String, dynamic> json) {
    return TransferRecord(
      id:            json['id'] as int,
      material:      json['material']      as String?,
      materialUnit:  json['material_unit'] as String?,
      category:      json['category']      as String?,
      fromSite:      json['from_site']     as String?,
      toSite:        json['to_site']       as String?,
      quantity:      (json['quantity']     as num).toDouble(),
      pricePerUnit:  (json['price_per_unit'] as num).toDouble(),
      totalValue:    (json['total_value']  as num).toDouble(),
      transportMode: json['transport_mode'] as String?,
      driverDetails: json['driver_details'] as String?,
      notes:         json['notes']         as String?,
      image:         json['image']         as String?,
      transferDate:  json['transfer_date'] != null
          ? DateTime.tryParse(json['transfer_date'] as String)
          : null,
    );
  }
}