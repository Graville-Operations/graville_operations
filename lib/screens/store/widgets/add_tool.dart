import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';

class AddToolScreen extends StatefulWidget {
  const AddToolScreen({super.key});

  @override
  State<AddToolScreen> createState() => _AddToolScreenState();
}

class _AddToolScreenState extends State<AddToolScreen> {
  final _nameController        = TextEditingController();
  final _symbolController      = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _symbolController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isFormValid) return;
    setState(() => _isLoading = true);

    final payload = {
      'name':        _nameController.text.trim(),
      'symbol':      _symbolController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    };

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tool "${payload['name']}" added successfully!'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context, payload);
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
          'Add Tool',
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
              title: 'Tool Name',
              icon: Icons.build_outlined,
              required: true,
              child: CustomTextInput(
                controller: _nameController,
                hintText: 'e.g. Welding Machine',
                onChanged: (_) => setState(() {}),
              ),
            ),

            FormSection(
              title: 'Symbol',
              icon: Icons.tag_outlined,
              required: true,
              child: CustomTextInput(
                controller: _symbolController,
                hintText: 'e.g. GMAW',
                onChanged: (_) => setState(() {}),
              ),
            ),

            FormSection(
              title: 'Description (Optional)',
              icon: Icons.description_outlined,
              required: false,
              child: CustomTextInput(
                controller: _descriptionController,
                hintText: 'Add details about this tool',
                maxLines: 4,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Save Tool',
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    height: 55,
                    borderRadius: 14,
                    isLoading: _isLoading,
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 20),
                    onPressed:
                        _isFormValid && !_isLoading ? _submit : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : () => Navigator.pop(context),
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