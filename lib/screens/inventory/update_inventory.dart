import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/material_data.dart';
//import 'package:graville_operations/screens/Inventory_Screen/inventory_screen.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/models/material/inventory_material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/inventory/inventory_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UpdateInventoryScreen extends StatefulWidget {
  const UpdateInventoryScreen({super.key});

  @override
  UpdateInventoryScreenState createState() =>UpdateInventoryScreenState();

}

class UpdateInventoryScreenState
    extends State<UpdateInventoryScreen> {

InventoryMaterial? selectedMaterial;
final TextEditingController unitController = TextEditingController();
final TextEditingController categoryController = TextEditingController();
final TextEditingController quantityController = TextEditingController();

 File? selectedImage;
  ImagePicker imagePicker = ImagePicker();
  Future<void> pickImage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    selectedImage = File(image.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    selectedImage = File(image.path);
                  });
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

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
onTap: () => pickImage(context), // Open gallery
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 30),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade100,
          ),
          child: selectedImage == null
              ? const Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 28,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    selectedImage!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        const SizedBox(height: 15),
        Text(
          selectedImage == null ? "Tap to capture photo" : "Photo selected",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          selectedImage == null ? "Select from gallery" : "Change photo",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
              "Unit ",
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
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
             TextField(
                controller: categoryController,
                readOnly: true,
                decoration: inputDecoration(),
                  ),

            const SizedBox(height: 20),

            const Text(
              "Quantity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
               TextField(
                     controller: quantityController,
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
        if (selectedMaterial == null ||
           quantityController.text.isEmpty) {
             return;
              }

             final newMaterial = MaterialData(
             name: selectedMaterial!.name,
             quantity: quantityController.text,
             unit: selectedMaterial!.unit,
             );

            debugPrint("Saved: ${newMaterial.name} - ${newMaterial.quantity} ${newMaterial.unit}",
               );
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