import 'package:flutter/material.dart';
//import 'package:graville_operations/screens/Inventory_Screen/inventory_screen.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';


class UpdateInventoryScreen extends StatefulWidget {
  const UpdateInventoryScreen({super.key});

  @override

  UpdateInventoryScreenState createState() =>UpdateInventoryScreenState();

}

class UpdateInventoryScreenState
    extends State<UpdateInventoryScreen> {

  String? selectedMaterial = "Cement";
  String? selectedUnit = "Bags";
  int quantity = 0;

  final List<String> materials = [
    "Bricks",
    "Cement",
    "Sand",
    "Steel"
  ];

  final List<String> units = [
    "Bags",
    "Liters",
    "Kg",
    "Meters"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>InventoryScreen())),
        ),
        title: const Text(
          "Update Inventory",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade100,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Tap to capture photo",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Select from gallery",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Material Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedMaterial,
              items: materials
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedMaterial = val;
                });
              },
              decoration: inputDecoration(),
            ),

            const SizedBox(height: 20),

            const Text(
              "Unit Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedUnit,
              items: units
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedUnit = val;
                });
              },
              decoration: inputDecoration(),
            ),

            const SizedBox(height: 20),

            const Text(
              "Quantity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
               TextField(
                keyboardType: TextInputType.number,
                decoration: inputDecoration(
                  hintText: "Enter quantity",
                ),
               ),

            const SizedBox(height: 20),

            const Text(
              "Unit price (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              keyboardType: TextInputType.number,
              decoration:inputDecoration(
                hintText: "Enter price",
              ),
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
                hintText:"e.g., Delivered by XYZ supplier",
              ),
            ),

            const SizedBox(height: 30),

         Row(
          children: [
            Expanded(
            child:CustomButton(label: "cancel",
            backgroundColor: Colors.white10,
              textColor:  Colors.blue,
              onPressed: () {Navigator.pop(context);},
            ),
          ),
        
            const SizedBox(width: 15),
            Expanded(
            child:CustomButton(label: "Save Material",
              backgroundColor: Colors.blue,
              onPressed: () {
                debugPrint("saved");
              },
            ),
          ),
             ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration({
    String? hintText,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}