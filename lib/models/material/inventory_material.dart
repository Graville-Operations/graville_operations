class InventoryMaterial {
  final String name;
  final String category;
  final String unit;

  const InventoryMaterial({
    required this.name,
    required this.category,
    required this.unit,
  });
}
const List<InventoryMaterial> allMaterials = [
  InventoryMaterial(
    name: "Cement",
    category: "Building Material",
    unit: "Bags",
  ),
  InventoryMaterial(
    name: "Bricks",
    category: "Building Material",
    unit: "Pieces",
  ),
  InventoryMaterial(
    name: "Sand",
    category: "Building Material",
    unit: "Tons",
  ),
  InventoryMaterial(
    name: "Steel",
    category: "Metal",
    unit: "Meters",
  ),
];