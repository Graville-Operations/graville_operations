import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/inventory_material.dart';
import 'package:graville_operations/models/material/material_data.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
//import 'package:graville_operations/screens/inventory_screen/inventory_screen.dart';
//import 'package:graville_operations/widgets/custom_button.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddMaterialScreen(),
    ),
  );
}

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => AddMaterialScreenState();
}

class AddMaterialScreenState extends State<AddMaterialScreen> {
  List<String> allCategories = [
    "Electrical",
    "Plumbing",
    "Masonry",
    "Carpentry",
  ];

  List<String> allUnits = ["kg", "pcs", "liters", "meters"];

  String? selectedCategory;
  String? selectedUnit;

  InventoryMaterial? selectedMaterial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Add Material",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Material Name",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomDropdown<InventoryMaterial>(
              value: selectedMaterial,
              items: allMaterials,
              displayMapper: (material) => material.name,
              onChanged: (InventoryMaterial? material) {
                setState(() {
                  selectedMaterial = material;
                });
              },
              hint: "Select Material",
              isExpanded: true,
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),

            const SizedBox(height: 20),

            const Text(
              "Category",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            CustomDropdown<String>(
              value: selectedCategory,
              items: allCategories,
              displayMapper: (cat) => cat,
              onChanged: (String? cat) {
                setState(() {
                  selectedCategory = cat;
                });
              },
              isExpanded: true,
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            const SizedBox(height: 20),

            const Text(
              "Unit",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            CustomDropdown<String>(
              value: selectedUnit,
              items: allUnits,
              displayMapper: (unit) => unit,
              onChanged: (String? unit) {
                setState(() {
                  selectedUnit = unit;
                });
              },
              isExpanded: true,
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),

            const SizedBox(height: 40),

            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: "Save Material",
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                        height: 55,
                        borderRadius: 14,
                        onPressed: () {
                          if (selectedMaterial == null ||
                              selectedCategory == null ||
                              selectedUnit == null) {
                            return;
                          }

                          final newMaterial = MaterialData(
                            name: selectedMaterial!.name,
                            unit: selectedUnit!,
                            quantity: '',
                          );

                          debugPrint(
                            "Saved: ${newMaterial.name} -${newMaterial.unit}",
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration({String? hintText, String? prefixText}) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
