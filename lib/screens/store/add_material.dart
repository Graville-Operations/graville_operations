import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';

class AddMaterialScreen extends StatefulWidget {
  const AddMaterialScreen({super.key});

  @override
  State<AddMaterialScreen> createState() => _AddMaterialScreenState();
}

class _AddMaterialScreenState extends State<AddMaterialScreen> {
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _unitController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f5f7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Material',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSection(
              title: 'Material Name',
              icon: Icons.construction_sharp,
              required: true,
              child: CustomTextInput(
                controller: _nameController,
                hintText: 'e.g. Portland Cement',
                onChanged: (_) => setState(() {}),
              ),
            ),

            FormSection(
              title: 'Unit',
              icon: Icons.straighten_outlined,
              required: true,
              child: CustomTextInput(
                controller: _unitController,
                hintText: 'e.g. Bags',
                onChanged: (_) => setState(() {}),
              ),
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Save Material',
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    height: 55,
                    borderRadius: 14,
                    onPressed: _isFormValid
                        ? () => Navigator.pop(context, {
                              'name': _nameController.text.trim(),
                              'unit': _unitController.text.trim(),
                            })
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}