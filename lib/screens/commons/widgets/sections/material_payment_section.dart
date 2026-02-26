import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';

class MaterialPaymentSection extends StatefulWidget {
  const MaterialPaymentSection({super.key});

  @override
  State<MaterialPaymentSection> createState() => _MaterialPaymentSectionState();
}

class _MaterialPaymentSectionState extends State<MaterialPaymentSection> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormSection(
          title: "Amount Paid(Cash)",
          icon: Icons.attach_money,
          required: true,
          child: CustomTextInput(
            controller: amountController,
            hintText: "0.00",
            prefixIcon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter amount paid";
              }
              return null;
            },
          ),
        ),
        FormSection(
          title: "Supplier Name",
          icon: Icons.person_outline,
          required: true,
          child: CustomTextInput(
            controller: supplierController,
            hintText: "Enter supplier name",
          ),
        ),
        FormSection(
          title: "Notes/Remarks",
          icon: Icons.comment,
          required: false,
          child: CustomTextInput(
            controller: notesController,
            hintText: "Add any additional notes or remarks...",
            //prefixIcon: Icons.notes_outlined,
            maxLines: 5,
          ),
        ),
      ],
    );
  }
}
