//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch(1).dart';/
import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';

class MaterialPaymentSection extends StatefulWidget {
  final ValueChanged<bool>? onPaymentChanged;
  const MaterialPaymentSection({super.key, this.onPaymentChanged});

  @override
  State<MaterialPaymentSection> createState() => _MaterialPaymentSectionState();
}

class _MaterialPaymentSectionState extends State<MaterialPaymentSection> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void validatepayment() {
    final isValid =
        amountController.text.trim().isNotEmpty &&
        supplierController.text.trim().isNotEmpty;
    widget.onPaymentChanged?.call(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormSection(
          title: "Amount Paid(Cash)",
          icon: Icons.account_balance,
          required: true,
          child: CustomTextInput(
            controller: amountController,
            hintText: "0.00",
            prefixIcon: Icons.account_balance,
            keyboardType: TextInputType.number,
            onChanged: (_) => validatepayment(),
          ),
        ),
        FormSection(
          title: "Supplier Name",
          icon: Icons.person_outline,
          required: true,
          child: CustomTextInput(
            controller: supplierController,
            hintText: "Enter supplier name",
            onChanged: (_) => validatepayment(),
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
