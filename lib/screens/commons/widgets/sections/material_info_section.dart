import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';

class MaterialInfoSection extends StatefulWidget {
  const MaterialInfoSection({super.key});

  @override
  State<MaterialInfoSection> createState() => _MaterialInfoSectionState();
}

class _MaterialInfoSectionState extends State<MaterialInfoSection> {
  String? selectedMaterial;
  final materials = const ["Cement", "Sand", "Ballast", "Steel", "Paint"];
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: "Material Name",
      icon: Icons.inventory,
      required: true,
      child: CustomDropdown<String>(
        hint: "Select material",
        value: selectedMaterial,
        items: materials,
        displayMapper: (item) => item,
        onChanged: (value) {
          setState(() {
            selectedMaterial = value;
          });
        },
      ),
    );
  }
}
