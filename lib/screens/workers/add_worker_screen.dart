import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/models/worker_model.dart';
import 'package:graville_operations/services/worker_service.dart';

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
  bool _isLoading = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
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
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
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
      firstNameController.clear();
      lastNameController.clear();
      idController.clear();
      phoneController.clear();
    });
  }

  Future<void> _submit() async {
    if (!isFormValid) return;

    final nationalId = int.tryParse(idController.text.trim());
    if (nationalId == null) {
      _showError('National ID must be a valid number.');
      return;
    }

    setState(() => _isLoading = true);

    final worker = Worker(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      nationalId: nationalId,
      skillType: workerType!,
      phoneNumber: phoneController.text.trim(),
      amount: amount.toDouble(),
      site: selectedSite,
      taskId: null,
    );

    try {
      final created = await WorkerService.createWorker(worker);
      if (!mounted) return;
      _showSuccess('Worker "${created.fullName}" added successfully!');
      clearForm();
      Navigator.pop(context, created);
    } on WorkerServiceException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
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

            FormLabel(label: "First Name *"),
            CustomTextInput(
              controller: firstNameController,
              onChanged: (_) => setState(() {}),
              hintText: "Enter first name",
            ),

            FormLabel(label: "Last Name *"),
            CustomTextInput(
              controller: lastNameController,
              onChanged: (_) => setState(() {}),
              hintText: "Enter last name",
            ),

            FormLabel(label: "National ID *"),
            CustomTextInput(
              keyboardType: TextInputType.number,
              controller: idController,
              onChanged: (_) => setState(() {}),
              hintText: "e.g. 12345678",
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
              isEnabled: isFormValid && !_isLoading,
              isLoading: _isLoading,
              onSubmit: _submit,
              onCancel: clearForm,
            ),

            const SizedBox(height: 40),
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
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const FormActions({
    super.key,
    required this.isEnabled,
    required this.onSubmit,
    required this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: isLoading ? null : onCancel,
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
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Add Worker"),
            ),
          ),
        ),
      ],
    );
  }
}
