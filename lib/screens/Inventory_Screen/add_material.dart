import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/inventory_screen/inventory_screen.dart';
import 'package:graville_operations/widgets/custom_button.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddMaterialScreen(),
  ));
}

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => AddMaterialScreenState();
}

class AddMaterialScreenState extends State<AddMaterialScreen> {
  String? selectedMaterial = "Bricks";
  String? selectedCategory = "Structural";
  String? selectedUnit = "Bags";

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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            buildDropdown(
              value: selectedMaterial,
              items: const ["Bricks", "Cement", "Sand"],
              onChanged: (value) {
                setState(() {
                  selectedMaterial = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Category",
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            buildDropdown(
              value: selectedCategory,
              items: const ["Structural", "Finishing", "Electrical"],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Unit",
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            buildDropdown(
              value: selectedUnit,
              items: const ["Bags", "Pieces", "Tonnes"],
              onChanged: (value) {
                setState(() {
                  selectedUnit = value;
                });
              },
            ),

          const SizedBox(height: 40,),

         Row(
          children: [
            Expanded(
            child:CustomButton(label: "cancel",
            backgroundColor: Colors.white10,
              textColor:  Colors.blue,
              onPressed: () {Navigator.pop(context);},
            ),
          ),
        
            const SizedBox(width: 40),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}