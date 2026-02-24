import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FormSection(
            title: "Quantity",
            icon: Icons.numbers,
            required: true,
            child: CustomTextInput(
              controller: quantityController,
              hintText: "0",
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: FormSection(
            title: "Unit",
            icon: Icons.balance,
            required: true,
            child: CustomDropdown<String>(
              value: selectedUnit,
              items: units,
              displayMapper: (item) => item,
              //hint: "Select unit",
              onChanged: (value) {
                setState(() {
                  selectedUnit = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
