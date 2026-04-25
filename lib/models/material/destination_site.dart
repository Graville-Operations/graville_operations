class DestinationSite {
  final String id;
  final String name;
  final String? description;

  const DestinationSite({
    required this.id,
    required this.name,
    this.description,
  });

  factory DestinationSite.fromJson(Map<String, dynamic> json) {
    return DestinationSite(
      id:          json['id'].toString(),
      name:        json['name']        as String? ?? '',
      description: json['description'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DestinationSite &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}