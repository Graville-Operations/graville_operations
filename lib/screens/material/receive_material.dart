import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/screens/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/screens/commons/widgets/sections/material_info_section.dart';
import 'package:graville_operations/screens/commons/widgets/sections/material_quantity_section.dart';
import 'package:graville_operations/screens/commons/widgets/sections/material_payment_section.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';

class ReceiveMaterialScreen extends StatefulWidget {
  const ReceiveMaterialScreen({super.key});

  @override
  State<ReceiveMaterialScreen> createState() => _ReceiveMaterialScreenState();
}

class _ReceiveMaterialScreenState extends State<ReceiveMaterialScreen> {
  AppMaterial? selectedMaterial;

  bool hasPhoto = false;
  bool hasQuantity = false;
  bool hasPaymentInfo = false;

  bool get isFormValid {
    return selectedMaterial != null &&
        hasPhoto &&
        hasQuantity &&
        hasPaymentInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                Icon(Icons.inventory, color: Colors.blue, size: 22),
                SizedBox(width: 8),
                Text(
                  "Receive Material",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                MaterialPhotoSection(title: "Material Photo"),
                MaterialInfoSection(
                  selectedMaterial: selectedMaterial,
                  onChanged: (material) {
                    setState(() {
                      selectedMaterial = material;
                    });
                  },
                ),
                MaterialQuantitySection(
                  selectedMaterial: selectedMaterial,
                  onQuantityChanged: (value) {
                    setState(() {
                      hasQuantity = value;
                    });
                  },
                ),
                MaterialPaymentSection(
                  onPaymentChanged: (value) {
                    setState(() {
                      hasPaymentInfo = value;
                    });
                  },
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    label: "Confirm Receipt",
                    icon: const Icon(Icons.check_circle_outline),
                    backgroundColor: isFormValid
                        ? Colors.blue
                        : Colors.grey.shade400,
                    textColor: Colors.white,
                    borderRadius: 16,
                    height: 55,
                    onPressed: isFormValid
                        ? () {
                            print("Receipt Confirmed");
                          }
                        : null,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
