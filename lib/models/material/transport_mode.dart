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
  Map<String, dynamic> toJson() => {
        'id':          id,
        'name':        name,
        if (category   != null) 'category':    category,
        if (noPlate    != null) 'no_plate':    noPlate,
        if (driverName != null) 'driver_name': driverName,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransportMode &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}