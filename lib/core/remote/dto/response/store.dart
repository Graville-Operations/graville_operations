class StoreMaterial {
  final int id;
  final int quantity;
  final double unitPrice;
  final String materialName;
  final String categoryName;
  final String unitName;
  final String unitSymbol;
  final String description;

  StoreMaterial({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.description,
    required this.materialName,
    required this.categoryName,
    required this.unitName,
    required this.unitSymbol,
  });

  factory StoreMaterial.fromJson(Map<String, dynamic> json) {
    return StoreMaterial(
      id: json['id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      materialName: json['material_name'],
      categoryName: json['category_name'],
      unitName: json['unit_name'],
      unitSymbol: json['unit_symbol'],
      description: json['description'],
    );
  }
}

class StoreTool {
  final int id;
  final int quantity;
  final double rate;
  final double totalAmount;
  final String billingType;
  final String tool;
  final String supplier;
  final String notes;

  StoreTool({
    required this.id,
    required this.quantity,
    required this.rate,
    required this.totalAmount,
    required this.billingType,
    required this.tool,
    required this.supplier,
    required this.notes,
  });

  factory StoreTool.fromJson(Map<String, dynamic> json) {
    return StoreTool(
      id: json['id'],
      quantity: json['quantity'],
      rate: (json['rate'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      billingType: json['billing_type'],
      tool: json['tool_name'],
      supplier: json['supplier'],
      notes: json['notes'],
    );
  }
}
