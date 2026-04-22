class MaterialData {
  final int id;
  final String name;
  final String quantity;
  final String unitType;

  const MaterialData({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitType,
  });

  factory MaterialData.fromJson(Map<String, dynamic> json) {
    return MaterialData(
      id: json['id'],
      name: json['name'],
      quantity: json['unit'],
      unitType: json['category'],
    );
  }

  MaterialData copy(
      {int? id, String? name, String? quantity, String? unitType}) {
    return MaterialData(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitType: unitType ?? this.unitType,
    );
  }
}
