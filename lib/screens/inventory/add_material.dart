import 'package:flutter/material.dart';
//import 'package:graville_operations/models/material/material_model.dart';
import 'package:graville_operations/lib/models/inventory/inventory_model.dart';
import 'package:graville_operations/models/inventory/inventory%20_model.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/lib/models/inventory/inventory_model.dart';
import 'package:graville_operations/services/inventory_service.dart';
//import 'package:graville_operations/services/material_service.dart';

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => AddMaterialScreenState();
}

class AddMaterialScreenState extends State<AddMaterialScreen> {
 
  final List<String> allCategories = [
    'Structure and Foundation', 'Wall Assembly and Openings', 'Roof Finish and Support Layers', 'Interior Build-Out and Finishes', 'Service Rough-In Materials(e.g pipe,wiring,vents)', 'Exterior Works and Drainage(e.g. gutters, downspouts)', 'Tools and Equipment', 'Safety and Protective Gear', 'Other'
  ];

  final List<String> allUnits = ['pieces', 'meters', 'Bags', 'Tons' ,'m²', 'm³', 'ft²', 'unit count', 'rolls', 'sheets', 'yd³', 'gallons', 'pounds', 'kilograms', 'liters', 'meters', 'feet', 'inches', 'boxes', 'bundles', 'pallets'];

  String? selectedCategory;
  String? selectedUnit;

  
  final TextEditingController nameController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      nameController.text.isNotEmpty &&
      selectedCategory != null &&
      selectedUnit != null;

  Future<void> _submit() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    final material = InventoryModel(
      name: nameController.text.trim(),
      category: selectedCategory!,
      unitType: selectedUnit!,
      quantity: 0,
      unitPrice: 0.0,
      description: '',
    );

    try {
      final created = await MaterialService.createMaterial(material);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Material "${created.name}" added successfully!'),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, created);
    } on MaterialServiceException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred. Please try again.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Material',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Material name — free text input
            const Text(
              'Material Name *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration(hintText: 'e.g. Cement, Steel Rods'),
            ),

            const SizedBox(height: 20),

            // Category dropdown
            const Text(
              'Category *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomDropdown<String>(
              value: selectedCategory,
              items: allCategories,
              displayMapper: (cat) => cat,
              onChanged: (val) => setState(() => selectedCategory = val),
              hint: 'Select category',
              isExpanded: true,
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),

            const SizedBox(height: 20),

            // Unit dropdown
            const Text(
              'Unit *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomDropdown<String>(
              value: selectedUnit,
              items: allUnits,
              displayMapper: (unit) => unit,
              onChanged: (val) => setState(() => selectedUnit = val),
              hint: 'Select unit',
              isExpanded: true,
              isDense: true,
              border: InputBorder.none,
              fillColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),

            const SizedBox(height: 40),

            // Actions
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Save Material',
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    height: 55,
                    borderRadius: 14,
                    isLoading: _isLoading,
                    onPressed: _isFormValid && !_isLoading ? _submit : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}