import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/inventory_material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
//import 'package:graville_operations/screens/inventory_screen/inventory_screen.dart';
//import 'package:graville_operations/widgets/custom_button.dart';

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
  
 InventoryMaterial? selectedMaterial;
final TextEditingController unitController = TextEditingController();
final TextEditingController categoryController = TextEditingController();
final TextEditingController quantityController = TextEditingController();

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
              "Category",
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
           TextField(
                controller: categoryController,
                readOnly: true,
                decoration: inputDecoration(),
                  ),
            const SizedBox(height: 20),

            const Text(
              "Unit",
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
                          TextField(
                controller: unitController,
                readOnly: true,
                decoration: inputDecoration(),
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