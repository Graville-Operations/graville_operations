import 'package:flutter/material.dart';
import 'package:graville_operations/widgets/form/dropdown_feild.dart';
import 'package:graville_operations/widgets/form/form_section.dart';

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
      child: DropdownFeild(
        label: "Select material",
        value: selectedMaterial,
        items: materials
            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedMaterial = value;
          });
        },
      ),
    );
  }
}
