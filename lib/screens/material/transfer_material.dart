import 'package:flutter/material.dart';
import 'package:graville_operations/models/material/app_material.dart';
import 'package:graville_operations/models/material/destination_site.dart';
import 'package:graville_operations/models/material/transport_mode.dart';
import 'package:graville_operations/screens/commons/widgets/custom_image_picker.dart';
import 'package:graville_operations/screens/commons/widgets/sections/destination_info.dart';
import 'package:graville_operations/screens/commons/widgets/sections/material_info_section.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
import 'package:graville_operations/screens/commons/widgets/custom_text_input.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';
import 'package:graville_operations/screens/commons/widgets/sections/transport_info.dart';

class TransferMaterialScreen extends StatefulWidget {
  const TransferMaterialScreen({super.key});

  @override
  State<TransferMaterialScreen> createState() => _TransferMaterialScreenState();
}

class _TransferMaterialScreenState extends State<TransferMaterialScreen> {
  TextEditingController destinationController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  DestinationSite? selectedDestination;
  TransportMode? selectedMode;
  AppMaterial? selectedMaterial;

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
                Icon(Icons.local_shipping, color: Colors.blue, size: 22),
                SizedBox(width: 8),
                Text(
                  "Transfer Material",
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
                // Material Photo Section
                MaterialPhotoSection(),
                //SizedBox(height: 16),

                // Material Info Section
                MaterialInfoSection(
                  selectedMaterial: selectedMaterial,
                  onChanged: (material) {
                    setState(() {
                      selectedMaterial = material;
                    });
                  },
                ),
                FormSection(
                  title: "Quantity",
                  icon: Icons.numbers,
                  required: true,
                  child: CustomTextInput(
                    controller: quantityController,
                    hintText: "Enter Quantity",
                    keyboardType: TextInputType.number,
                  ),
                ),
                FormSection(
                  title: "Price per unit",
                  icon: Icons.numbers,
                  required: true,
                  child: CustomTextInput(
                    controller: unitController,
                    hintText: "0",
                    keyboardType: TextInputType.number,
                  ),
                ),
                //SizedBox(height: 16),

                // Quantity Section
                //MaterialQuantitySection(selectedMaterial: selectedMaterial),
                //SizedBox(height: 16),

                // Price per Unit and Destination
                DestinationInfo(
                  selectedDestination: selectedDestination,
                  onChanged: (destination) {
                    setState(() {
                      selectedDestination = destination;
                    });
                  },
                ),
                //SizedBox(height: 16),

                // Mode of Transport
                TransportInfo(
                  selectedMode: selectedMode,
                  onChanged: (mode) {
                    setState(() {
                      selectedMode = mode;
                    });
                  },
                ),
                //SizedBox(height: 16),

                // Driver Name / Transport Details
                FormSection(
                  title: "Driver's Name/Transport Details",
                  required: false,
                  child: CustomTextInput(
                    controller: TextEditingController(),
                    hintText: "Enter Driver's name or transport details",
                  ),
                ),
                //SizedBox(height: 16),

                // Notes Section
                FormSection(
                  title: "Notes",
                  icon: Icons.comment,
                  required: false,
                  child: CustomTextInput(
                    controller: notesController,
                    hintText: "Add any additional notes or remarks...",
                    //prefixIcon: Icons.notes_outlined,
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 15),

                // Confirm Transfer Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    label: "Confirm Transfer",
                    //icon: const Icon(Icons.check_circle_outline),
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    borderRadius: 16,
                    height: 55,
                    onPressed: () {
                      print("Transfer Confirmed");
                    },
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
