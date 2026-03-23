class AppMaterial {
  final String id;
  final String name;
  final String unit;
  final String category;
  final String? description;
  const AppMaterial({
    required this.id,
    required this.name,
    required this.unit,
    required this.category,
    this.description,
  });
}
