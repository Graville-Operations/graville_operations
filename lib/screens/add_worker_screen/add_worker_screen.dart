import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MaterialApp(home: AddWorkerScreen()));

/// ✅ Worker model (required for returning data safely)
class Worker {
  final String name;
  final String id;
  final String skillLevel;
  final String phone;
  final String specialty;
  final String rate;

  Worker({
    required this.name,
    required this.id,
    required this.skillLevel,
    required this.phone,
    required this.specialty,
    required this.rate,
  });
}

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  String? workerType;
  String? task;
  String? selectedSite;

  int amount = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _photo = File(image.path));
    }
  }

  void _updateAmount() {
    setState(() {
      if (workerType == "Skilled") {
        amount = task == "Roadworks"
            ? 1500
            : task != null
            ? 1200
            : 0;
      } else if (workerType == "Unskilled") {
        amount = 600;
      } else {
        amount = 0;
      }
    });
  }

  bool get isFormValid =>
      selectedSite != null &&
      nameController.text.isNotEmpty &&
      idController.text.isNotEmpty &&
      phoneController.text.isNotEmpty &&
      workerType != null &&
      task != null &&
      amount > 0;

  void _clearForm() {
    setState(() {
      selectedSite = null;
      workerType = null;
      task = null;
      amount = 0;
      _photo = null;
      nameController.clear();
      idController.clear();
      phoneController.clear();
    });
  }

  Widget _photoCard() {
    return GestureDetector(
      onTap: _openCamera,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _photo == null
              ? Container(
                  color: const Color(0xFFF8F9FA),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Color(0xFFE6F0FF),
                        child: Icon(Icons.camera_alt, color: Colors.blue),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tap to capture photo",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Image.file(_photo!, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add Worker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _photoCard(),
            const SizedBox(height: 20),

            FormLabel(label: "Select Site *"),
            CustomDropdownField(
              hint: "Select a site",
              options: const [
                "Mishi Mboko",
                "Iremele",
                "Mabatini",
                "DCC Kibra",
                "Huruma",
              ],
              value: selectedSite,
              onSelected: (val) => setState(() => selectedSite = val),
            ),

            const SizedBox(height: 24),
            const SectionHeader(title: "Worker Information"),
            const SizedBox(height: 16),

            FormLabel(label: "Worker Name *"),
            CustomTextField(
              hint: "Enter worker name",
              controller: nameController,
              onChanged: (_) => setState(() {}),
            ),

            FormLabel(label: "Worker ID *"),
            CustomTextField(
              hint: "e.g. 40635223",
              controller: idController,
              onChanged: (_) => setState(() {}),
            ),

            FormLabel(label: "Phone Number *"),
            CustomTextField(
              hint: "e.g. +254 769902927",
              controller: phoneController,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),
            const SectionHeader(title: "Task and Payment"),
            const SizedBox(height: 16),

            FormLabel(label: "Worker Type *"),
            CustomDropdownField(
              hint: "Select type",
              options: const ["Skilled", "Unskilled"],
              value: workerType,
              onSelected: (val) {
                setState(() => workerType = val);
                _updateAmount();
              },
            ),

            FormLabel(label: "Task *"),
            CustomDropdownField(
              hint: "Select task",
              options: const [
                "Masonry",
                "Electrical",
                "Carpentry",
                "Plumbing",
                "BrickWork",
                "WoodWork",
                "Roadworks",
              ],
              value: task,
              onSelected: (val) {
                setState(() => task = val);
                _updateAmount();
              },
            ),

            FormLabel(label: "Amount *"),
            Card(
              elevation: 0,
              color: const Color(0xFFF5F6FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Text(
                  amount > 0 ? "KES $amount" : "Amount will be calculated",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: amount > 0 ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            FormActions(
              isEnabled: isFormValid,
              onSubmit: () {
                final worker = Worker(
                  name: nameController.text.trim(),
                  id: idController.text.trim(),
                  skillLevel: workerType!,
                  phone: phoneController.text.trim(),
                  specialty: task!,
                  rate: "KES $amount",
                );
                Navigator.pop(context, worker);
              },
              onCancel: _clearForm,
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Red asterisk implementation (clean & reusable)
class FormLabel extends StatelessWidget {
  final String label;
  const FormLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final hasAsterisk = label.contains('*');
    final text = label.replaceAll('*', '');

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: text),
            if (hasAsterisk)
              const TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String hint;
  final List<String> options;
  final String? value;
  final ValueChanged<String> onSelected;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.options,
    required this.onSelected,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => v != null ? onSelected(v) : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class FormActions extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const FormActions({
    super.key,
    required this.isEnabled,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: onCancel,
              child: const Text("Cancel"),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isEnabled ? onSubmit : null,
              child: const Text("Add Worker"),
            ),
          ),
        ),
      ],
    );
  }
}
