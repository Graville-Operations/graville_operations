import 'package:graville_operations/models/inventory/material_data.dart';

class Inventory {
  final String site;
  final List<MaterialData> materials;
  final List<MaterialData> hiredTools;
  final DateTime createdAt;

  const Inventory({
    required this.site,
    required this.materials,
    required this.createdAt,
    this.hiredTools = const [],
  });

  Inventory copy({
    String? site,
    List<MaterialData>? materials,
    List<MaterialData>? hiredTools,

  }) {
    return Inventory(
      site: site ?? this.site,
      materials: materials ?? this.materials,
      hiredTools: hiredTools ?? this.hiredTools,
      createdAt: createdAt
    );
  }
}
