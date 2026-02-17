class MaterialData {
  final String name;
  final String quantity;
  final String unit;

  const MaterialData({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  MaterialData copy({String? name, String? quantity, String? unit}) {
    return MaterialData(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
