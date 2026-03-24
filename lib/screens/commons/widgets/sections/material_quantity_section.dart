import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';

class MaterialQuantitySection extends StatefulWidget {
  final ValueChanged<bool>? onQuantityChanged;
  final AppMaterial? selectedMaterial;
  const MaterialQuantitySection({
    super.key,
    required this.selectedMaterial,
    this.onQuantityChanged,
  });

  @override
  State<MaterialQuantitySection> createState() =>
      _MaterialQuantitySectionState();
}

class _MaterialQuantitySectionState extends State<MaterialQuantitySection> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unitController.text = widget.selectedMaterial?.unit ?? "";
  }

  @override
  void didUpdateWidget(covariant MaterialQuantitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMaterial != widget.selectedMaterial) {
      unitController.text = widget.selectedMaterial?.unit ?? "";
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    super.dispose();
  }

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
              onChanged: (value) {
                final isValid = value.trim().isNotEmpty;
                widget.onQuantityChanged?.call(isValid);
              },
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: FormSection(
            title: "Unit",
            icon: Icons.balance,
            required: false,
            child: CustomTextInput(
              controller: unitController,
              hintText: "",
              readOnly: true,
              
            ),
          ),
        ),
      ],
    );
  }
}
