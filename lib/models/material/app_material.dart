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

  factory AppMaterial.fromJson(Map<String, dynamic> json) {
    return AppMaterial(
      id:          json['id'].toString(),
      name:        json['name']        as String? ?? '',
      unit:        json['unit']        as String? ?? '',
      category:    json['category']    as String? ?? '',
      description: json['description'] as String?,
    );
  }
}