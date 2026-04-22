class TransportMode {
  final String id;
  final String name;
  final String? description;
  final String? category;
  final String? noPlate;
  final String? driverName;

  const TransportMode({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.noPlate,
    this.driverName,
  });

  factory TransportMode.fromJson(Map<String, dynamic> json) {
    return TransportMode(
      id:         json['id'].toString(),
      name:       json['name']        as String? ?? '',
      category:   json['category']    as String?,
      noPlate:    json['no_plate']    as String?,
      driverName: json['driver_name'] as String?,
    );
  }
}