import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/models/material/app_material.dart';

class MaterialInfoSection extends StatefulWidget {
  const MaterialInfoSection({super.key});

  @override
  State<MaterialInfoSection> createState() => _MaterialInfoSectionState();
}

class _MaterialInfoSectionState extends State<MaterialInfoSection> {
  AppMaterial? selectedMaterial;
  final List<AppMaterial> materials = const [
    AppMaterial(id: "1", name: "Cement"),
    AppMaterial(id: "2", name: "Sand"),
    AppMaterial(id: "3", name: "Balast"),
    AppMaterial(id: "4", name: "Steel"),
    AppMaterial(id: "5", name: "Paint"),
  ];
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: "Material Name",
      icon: Icons.inventory,
      required: true,
      child: CustomDropdown<AppMaterial>(
        hint: "Select material",
        value: selectedMaterial,
        items: materials,
        displayMapper: (item) => item.name,
        onChanged: (value) {
          setState(() {
            selectedMaterial = value;
          });
        },
      ),
    );
  }
}
