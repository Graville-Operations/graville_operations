import 'package:flutter/material.dart';
import 'package:graville_operations/models/addworker.dart';
import 'package:graville_operations/screens/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/workers/workers_screen.dart';

void main() => runApp(const MaterialApp(home: AddWorkerScreen()));

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
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

  void updateAmount() {
    setState(() {
      if (workerType == "Skilled") {
        if (task == "Roadworks") {
          amount = 1500;
        } else if (task != null) {
          amount = 1200;
        } else {
          amount = 0;
        }
      } else if (workerType == "Unskilled") {
        amount = 600;
      } else {
        amount = 0;
      }
    });
  }

  bool get isFormValid {
    return selectedSite != null &&
        nameController.text.isNotEmpty &&
        idController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        workerType != null &&
        task != null &&
        amount > 0;
  }

  void clearForm() {
    setState(() {
      selectedSite = null;
      workerType = null;
      task = null;
      amount = 0;
      nameController.clear();
      idController.clear();
      phoneController.clear();
    });
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialPhotoSection(title: "Worker Photo"),
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
            CustomTextInput(
              controller: nameController,
              onChanged: (_) => setState(() {}),
              hintText: "Enter worker name",
            ),

            FormLabel(label: "Worker ID *"),
            CustomTextInput(
              keyboardType: TextInputType.number,
              controller: idController,
              onChanged: (value) => setState(() {}),
              hintText: "e.g. 11111111",
            ),

            FormLabel(label: "Phone Number *"),
            CustomTextInput(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              onChanged: (_) => setState(() {}),
              hintText: "e.g. +254 712345678",
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
                updateAmount();
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
                updateAmount();
              },
            ),

            FormLabel(label: "Amount *"),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                amount > 0 ? "KES $amount" : "Amount will be calculated",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: amount > 0 ? Colors.black : Colors.grey,
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
              onCancel: clearForm,
            ),
          ],
        ),
      ),
    );
  }
}

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
            fontWeight: FontWeight.normal,
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
      onChanged: (v) {
        if (v != null) onSelected(v);
      },
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
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? Colors.blue : Colors.grey.shade300,
                foregroundColor: isEnabled ? Colors.white : Colors.grey,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text("Add Worker"),
            ),
          ),
        ),
      ],
    );
  }
}
