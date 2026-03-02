import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
//import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';

// 🔹 Updated CustomTextInput
class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onSuffixIconPressed;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final int? maxLines;
  final void Function(String)? onChanged;

  const CustomTextInput({
    Key? key,
    required this.controller,
    this.hintText,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onTap,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixIconPressed)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class HiredMaterialScreen extends StatefulWidget {
  const HiredMaterialScreen({super.key});

  @override
  State<HiredMaterialScreen> createState() => _HiredMaterialScreenState();
}

class _HiredMaterialScreenState extends State<HiredMaterialScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController siteController = TextEditingController();
  final TextEditingController toolController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController hireDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();

  DateTime? hireDate;
  DateTime? returnDate;
  double totalCost = 0.0;

  String? selectedConstruction;
  String? selectedEquipment;
  String billingType = "Per Day";

  final List<String> constructionSites = ["Mabatini", "Kware", "Huruma"];
  final List<String> equipmentList = [
    "Bulldozers",
    "Concrete Mixer",
    "Concrete Vibrators",
    "Drill Machine",
    "Excavator",
  ];

  final List<String> billingOptions = ["Per Day", "Per Hour"];

  void saveMaterial() {
    if (_formKey.currentState!.validate()) {
      print("Material saved successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Material saved successfully!")),
      );
    }
  }

  void calculateTotal() {
    final double days = double.tryParse(daysController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;
    setState(() {
      totalCost = days * rate;
    });
  }

  Future<void> pickDate(bool isHireDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isHireDate) {
          hireDate = picked;
          hireDateController.text = formatDate(picked);
        } else {
          returnDate = picked;
          returnDateController.text = formatDate(picked);
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void dispose() {
    siteController.dispose();
    toolController.dispose();
    daysController.dispose();
    rateController.dispose();
    supplierController.dispose();
    notesController.dispose();
    hireDateController.dispose();
    returnDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hired Material",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Construction Site
              const Text(
                "Construction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomDropdown<String>(
                items: constructionSites,
                value: selectedConstruction,
                hint: "Select construction site",
                prefixIcon: const Icon(Icons.location_city),
                displayMapper: (item) => item,
                onChanged: (value) {
                  setState(() {
                    selectedConstruction = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Equipment / Material
              const Text(
                "Equipment/ Material",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomDropdown<String>(
                items: equipmentList,
                value: selectedEquipment,
                hint: "Select Equipment",
                prefixIcon: const Icon(Icons.build),
                displayMapper: (item) => item,
                onChanged: (value) {
                  setState(() {
                    selectedEquipment = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Billing Type
              const Text(
                "Billing Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomDropdown<String>(
                items: billingOptions,
                value: billingType,
                hint: "Select Billing Type",
                prefixIcon: const Icon(Icons.receipt_long_outlined),
                displayMapper: (item) => item,
                onChanged: (value) {
                  setState(() {
                    billingType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              /// Number of Days
              const Text(
                "Number of Days",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomTextInput(
                controller: daysController,
                hintText: "Enter duration",
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                onChanged: (_) => calculateTotal(),
              ),
              const SizedBox(height: 20),

              /// Rate
              const Text("Rate", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              CustomTextInput(
                controller: rateController,
                hintText: "Enter cost per unit",
                keyboardType: TextInputType.number,
                onChanged: (_) => calculateTotal(),
              ),
              const SizedBox(height: 20),

              /// Total Cost
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TOTAL COST",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ksh ${totalCost.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Hire Date
              const Text(
                "Hire Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomTextInput(
                controller: hireDateController,
                hintText: "Select date",
                readOnly: true,
                prefixIcon: Icons.calendar_today,
                onTap: () => pickDate(true),
              ),
              const SizedBox(height: 20),

              /// Return Date
              const Text(
                "Return Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomTextInput(
                controller: returnDateController,
                hintText: "Select date",
                readOnly: true,
                prefixIcon: Icons.calendar_today,
                onTap: () => pickDate(false),
              ),
              const SizedBox(height: 20),

              /// Supplier
              const Text(
                "Supplier Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomTextInput(
                controller: supplierController,
                hintText: "e.g. ABC Equipment Rentals",
                prefixIcon: Icons.business,
              ),
              const SizedBox(height: 20),

              /// Notes
              const Text(
                "Notes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomTextInput(
                controller: notesController,
                hintText: "Add any special notes or conditions",
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              /// Save Button
              CustomButton(
                label: "Save",
                backgroundColor: Colors.green,
                textColor: Colors.black,
                onPressed: saveMaterial,
                //text: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
