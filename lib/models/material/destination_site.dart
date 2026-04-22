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
}