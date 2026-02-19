import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/widgets/form/form_section.dart';

class MaterialQuantitySection extends StatefulWidget {
  const MaterialQuantitySection({super.key});

  @override
  State<MaterialQuantitySection> createState() =>
      _MaterialQuantitySectionState();
}

class _MaterialQuantitySectionState extends State<MaterialQuantitySection> {
  final TextEditingController quantityController = TextEditingController();

  String? selectedUnit;

  final units = ["Bags", "Tonnes", "Pieces", "Litres", "Kg"];
  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: "Material Quantity",
      icon: Icons.scale,
      required: true,
      child: Row(
        children: [
          Expanded(
            child: CustomTextInput(
              controller: quantityController,
              labelText: "Quantity *",
              hintText: "0",
              prefixIcon: Icons.numbers,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter quantity";
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: CustomDropdown<String>(
              label: "Unit *",
              value: selectedUnit,
              items: units,
              displayMapper: (item) => item,
              prefixIcon: Icon(Icons.balance),
              onChanged: (value) {
                setState(() {
                  selectedUnit = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
