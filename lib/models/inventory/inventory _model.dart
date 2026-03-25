
class MaterialModel {
  final int? id;
  final String name;
  final String category;
  final String unit;
  final DateTime? createdAt;

  MaterialModel({
    this.id,
    required this.name,
    required this.category,
    required this.unit,
    this.createdAt,
  });



  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'category': category,
      'unit': unit,
    };
  }


  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      unit: json['unit'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}

class InventoryModel {
  final int? id;
  final String name;
  final int quantity;
  final String category;
  final String unitType;
  final double unitPrice;
  final String description;

  InventoryModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.unitType,
    required this.unitPrice,
    required this.description,
  });


  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'unit_type': unitType,
      'unit_price': unitPrice,
      'description': description,
    };
  }


  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      unitType: json['unit_type'] ?? '',
      unitPrice: (json['unit_price'] != null)
          ? (json['unit_price'] as num).toDouble()
          : 0.0,
      description: json['description'] ?? '',
    );
  }
}