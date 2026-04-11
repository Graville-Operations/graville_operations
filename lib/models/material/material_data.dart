class MaterialData {
  final String name;
  final String quantity;
  final String unitType;

  const MaterialData({
    required this.name,
    required this.quantity,
    required this.unitType,
  });

  MaterialData copy({String? name, String? quantity, String? unitType}) {
    return MaterialData(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitType: unitType ?? this.unitType,
    );
  }
}
