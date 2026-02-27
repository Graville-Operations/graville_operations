import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/models/material/app_material.dart';

class MaterialInfoSection extends StatelessWidget {
  final AppMaterial? selectedMaterial;
  final ValueChanged<AppMaterial?> onChanged;
  const MaterialInfoSection({
    super.key,
    required this.selectedMaterial,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<AppMaterial> materials = const [
      AppMaterial(
        id: "1",
        name: "Cement",
        unit: "Bags",
        category: "Structural",
      ),
      AppMaterial(
        id: "2",
        name: "Sand",
        unit: "Tonnes",
        category: "Structural",
      ),
      AppMaterial(
        id: "3",
        name: "Balast",
        unit: "Tonnes",
        category: "Structural",
      ),
      AppMaterial(
        id: "4",
        name: "Steel",
        unit: "Pieces",
        category: "Structural",
      ),
      AppMaterial(
        id: "5",
        name: "Paint",
        unit: "Litres",
        category: "Finishing",
      ),
    ];

    return Column(
      children: [
        FormSection(
          title: "Material Name",
          icon: Icons.inventory,
          required: true,
          child: CustomDropdown<AppMaterial>(
            hint: "Select material",
            value: selectedMaterial,
            items: materials,
            displayMapper: (item) => item.name,
            onChanged: onChanged,
          ),
        ),

        //const SizedBox(height: 16),
        FormSection(
          title: "Material Category",
          icon: Icons.category,
          required: false,
          child: CustomTextInput(
            controller: TextEditingController(
              text: selectedMaterial?.category ?? "",
            ),
            hintText: "",
            readOnly: true,
          ),
        ),
      ],
    );
  }
}
