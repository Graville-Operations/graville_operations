class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double quantity;
  final double unitPrice;
  final String? description;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    this.description,
  });

factory InventoryItem.fromJson(Map<String, dynamic> json) {
  return InventoryItem(
    id:          json['id'].toString(),
    name:        json['name']                    as String? ?? '',
    category:    json['category']                as String? ?? '',
    unit:        (json['unit'] ?? json['unit_type']) as String? ?? '',
    quantity:    (json['quantity'] as num?)?.toDouble() ?? 0.0,
    unitPrice:   (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    description: json['description']             as String?,
  );
}

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}