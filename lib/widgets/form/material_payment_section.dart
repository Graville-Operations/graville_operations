import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/widgets/form/form_section.dart';

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
    return FormSection(
      title: "Payment Details",
      icon: Icons.payment_outlined,
      required: true,
      child: Column(
        children: [
          CustomTextInput(
            controller: amountController,
            labelText: "Amount Paid(Cash) *",
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
          CustomTextInput(
            controller: supplierController,
            labelText: "Supplier Name",
            hintText: "Enter supplier name",
            prefixIcon: Icons.person_outline,
          ),
          CustomTextInput(
            controller: notesController,
            labelText: "Notes/Remarks",
            hintText: "Add any additional notes or remarks...",
            prefixIcon: Icons.notes_outlined,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
