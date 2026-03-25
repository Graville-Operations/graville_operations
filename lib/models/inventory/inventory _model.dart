class InventoryModel {
  final int? id;
  final String name;
  final int quantity;
  final String category;
  final String unitType;
  final double unitPrice;
  final String description;
  
  final String operation;

  InventoryModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.unitType,
    required this.unitPrice,
    required this.description,
    
    this.operation = 'subtract',
  });

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'unit_type': unitType,
      'unit_price': unitPrice,
      'description': description,
      
      'operation': operation,
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
     
      operation: 'subtract',
    );
  }

  String? get unit => null;
}