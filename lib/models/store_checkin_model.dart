enum StoreItemType { material, tool }

class StoreItem {
  final int id;
  final int quantity;
  final StoreItemType type;

  // Material-specific fields
  final double? unitPrice;
  final String? materialName;
  final String? categoryName;
  final String? unitName;
  final String? unitSymbol;
  final String? description;

  // Tool-specific fields
  final double? rate;
  final double? totalAmount;
  final String? billingType;
  final String? toolName;
  final String? supplier;
  final String? notes;

  StoreItem({
    required this.id,
    required this.quantity,
    required this.type,
    // material
    this.unitPrice,
    this.materialName,
    this.categoryName,
    this.unitName,
    this.unitSymbol,
    this.description,
    // tool
    this.rate,
    this.totalAmount,
    this.billingType,
    this.toolName,
    this.supplier,
    this.notes,
  });

  factory StoreItem.fromMaterialJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      quantity: json['quantity'],
      type: StoreItemType.material,
      unitPrice: (json['unit_price'] as num).toDouble(),
      materialName: json['material_name'],
      categoryName: json['category_name'],
      unitName: json['unit_name'],
      unitSymbol: json['unit_symbol'],
      description: json['description'],
    );
  }

  factory StoreItem.fromToolJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      quantity: json['quantity'],
      type: StoreItemType.tool,
      rate: (json['rate'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      billingType: json['billing_type'],
      toolName: json['tool_name'],
      supplier: json['supplier'],
      notes: json['notes'],
    );
  }

  String get displayName => type == StoreItemType.material
      ? (materialName ?? 'Unnamed Material')
      : (toolName ?? 'Unnamed Tool');

  String get displaySubtitle => type == StoreItemType.material
      ? '$quantity ${unitSymbol ?? ''}  ·  ${categoryName ?? ''}'
      : 'Qty: $quantity  ·  ${supplier ?? ''}';

  String get displayBadge =>
      type == StoreItemType.material ? (unitName ?? '') : (billingType ?? '');

  Map<String, dynamic> toCheckInJson({
    required bool isCheckedIn,
    String? issueComment,
  }) {
    return {
      'id': id,
      'type': type.name, // 'material' or 'tool'
      'checked_in': isCheckedIn,
      'issue_comment': issueComment,
    };
  }
}
