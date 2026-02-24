import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_dropdown.dart';
// ignore: unused_import
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:flutter/services.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';

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

  DateTime? hireDate;
  DateTime? returnDate;

  double totalCost = 0.0;

  String? selectedConstruction;
  String? selectedEquipment;
  String billingType = "Per Day";

  final List<String> ConstructionSite = [
    "Mabatini",
    "Kware",
    "Huruma",
    "Kwa Njenga",
    "Embakasi Girls",
    "Ngei",
    "Mathare North",
  ];
  final List<String> equipmentList = [
    "Air Compressors and Pneumatic Tools",
    "Asphalt Pavers",
    "Backhoe Loaders",
    "Boom Lifts / Aerial Work Platforms",
    "Bulldozers",
    "Cold Planers",
    "Concrete Mixer",
    "Concrete Pumps",
    "Concrete Vibrators",
    "Cranes (Mobile or Tower)",
    "Drill Machine",
    "Dump Trailers",
    "Dump Trucks",
    "Excavator",
    "Forklifts",
    "Generator",
    "Lighting / Floodlights",
    "Motor Graders",
    "Portable Restrooms",
    "Power Trowels",
    "Road Graders",
    "Rollers",
    "Scaffolding",
    "Scissor Lifts",
    "Skid Steer Loaders",
    "Telehandlers",
    "Temporary Fencing / Hoarding",
    "Water Pump",
    "Wheelbarrow",
  ];
  void saveMaterial() {
    if (_formKey.currentState!.validate()) {
      print("Material saved");
    }
  }

  final List<String> billingOptions = ["Per Day", "Per Hour"];

  // 🔢 Calculate total
  void calculateTotal() {
    final double days = double.tryParse(daysController.text) ?? 0;
    final double rate = double.tryParse(rateController.text) ?? 0;

    setState(() {
      totalCost = days * rate;
    });
  }

  // 📅 Pick date
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
        } else {
          returnDate = picked;
        }
      });
    }
  }

  // 📆 Format date without intl
  String formatDate(DateTime? date) {
    if (date == null) return "Select date";
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
        //backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Construction
              const Text(
                "Construction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              CustomDropdown<String>(
                items: ConstructionSite,
                value: selectedConstruction,
                hint: "Select construction site",
                prefixIcon: Icon(Icons.location_city),
                displayMapper: (item) => item,
                onChanged: (value) {
                  setState(() {
                    selectedConstruction = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Tool / Material
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
              TextFormField(
                controller: daysController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (_) => calculateTotal(),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: "Enter duration",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Rate
              const Text("Rate", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextFormField(
                controller: rateController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChanged: (_) => calculateTotal(),
                decoration: const InputDecoration(
                  prefixText: "Ksh",
                  hintText: "Enter cost per unit",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Total Cost Box
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
              TextFormField(
                readOnly: true,
                onTap: () => pickDate(true),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: formatDate(hireDate),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Return Date
              const Text(
                "Return Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                readOnly: true,
                onTap: () => pickDate(false),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: formatDate(returnDate),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Supplier
              const Text(
                "Supplier Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: supplierController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.business),
                  hintText: "e.g. ABC Equipment Rentals",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Notes
              const Text(
                "Notes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Add any special notes or conditions",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),
              CustomButton(
                label: "Save",
                backgroundColor: Colors.green,
                textColor: Colors.black,
                onPressed: saveMaterial,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
