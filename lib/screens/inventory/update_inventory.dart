import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/material_data.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/models/material/inventory_material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';

class UpdateInventoryScreen extends StatefulWidget {
  const UpdateInventoryScreen({super.key});

  @override
  UpdateInventoryScreenState createState() => UpdateInventoryScreenState();
}

List<String> allSites = ["PLAZA 2000", "Kimnojun", "Dcc Kibra", "Huruma"];

String? selectedSite;

class UpdateInventoryScreenState extends State<UpdateInventoryScreen> {
  InventoryMaterial? selectedMaterial;
  final TextEditingController unitController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Update Inventory",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Construction Site*",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            CustomDropdown<String>(
              value: selectedSite,
              items: allSites,
              displayMapper: (site) => site,
              onChanged: (String? site) {
                setState(() {
                  selectedSite = site;
                });
              },
              hint: "Select site",
              isExpanded: true,
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),

            const SizedBox(height: 30),

            const Text(
              "Material Name*",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            CustomDropdown<InventoryMaterial>(
              value: selectedMaterial,
              items: allMaterials,
              displayMapper: (material) => material.name,
              onChanged: (InventoryMaterial? material) {
                setState(() {
                  selectedMaterial = material;
                  unitController.text = material?.unit ?? "";
                  categoryController.text = material?.category ?? "";
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
              "Unit type*",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: unitController,
              readOnly: true,
              decoration: inputDecoration(),
            ),

            const SizedBox(height: 20),

            const Text(
              "Category",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: categoryController,
              readOnly: true,
              decoration: inputDecoration(),
            ),

            const SizedBox(height: 20),

            const Text(
              "Quantity*",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration(hintText: "Enter quantity"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Unit price (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              keyboardType: TextInputType.number,
              decoration: inputDecoration(hintText: "Enter price"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              maxLines: 2,
              decoration: inputDecoration(
                hintText: "e.g., Delivered by XYZ supplier",
              ),
            ),

            const SizedBox(height: 30),
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
                              quantityController.text.isEmpty) {
                            return;
                          }

                          final newMaterial = MaterialData(
                            name: selectedMaterial!.name,
                            quantity: quantityController.text,
                            unit: selectedMaterial!.unit,
                          );

                          debugPrint(
                            "Saved: ${newMaterial.name} - ${newMaterial.quantity} ${newMaterial.unit}",
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
