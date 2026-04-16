import 'package:flutter/material.dart';
import 'dart:io';

import 'package:graville_operations/core/commons/utils/camera.dart';
import 'package:graville_operations/core/commons/widgets/custom_button.dart';
import 'package:graville_operations/core/commons/widgets/custom_dropdown.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';

class AddTransportScreen extends StatefulWidget {
  const AddTransportScreen({super.key});

  @override
  State<AddTransportScreen> createState() => _AddTransportScreenState();
}

class _AddTransportScreenState extends State<AddTransportScreen> {
  final _plateNumberController = TextEditingController();
  final _transporterNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? selectedCategory;
  File? vehicleImage;

  final List<String> vehicleCategories = ['Truck', 'Pickup', 'Van', 'Trailer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Means of Transport',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PHOTO UPLOAD
            // Container(
            // height: 140,
            // width: double.infinity,
            //decoration: BoxDecoration(
            // color: Colors.white,
            //borderRadius: BorderRadius.circular(14),
            // ),
            //child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //children: [
            //CircleAvatar(
            //radius: 22,
            //backgroundColor: Colors.blue.withOpacity(0.1),
            //child: const Icon(Icons.camera_alt, color: Colors.blue),
            //),
            //const SizedBox(height: 8),
            //const Text(
            //'Tap to add photo',
            //style: TextStyle(color: Colors.grey),
            //),
            //],
            ///),
            // ),
            ImagePickerField(
              onImageSelected: (image) {
                setState(() => vehicleImage = image);
              },
            ),

            const SizedBox(height: 24),

            /// VEHICLE INFO
            const Text(
              'VEHICLE INFO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            CustomDropdown<String>(
              label: 'Category',
              hint: 'Select category',
              items: vehicleCategories,
              value: selectedCategory,
              displayMapper: (item) => item,
              onChanged: (value) {
                setState(() => selectedCategory = value);
              },
            ),

            CustomTextInput(
              controller: _plateNumberController,
              labelText: 'Number Plate',
              hintText: 'ABC-1234',
              prefixIcon: Icons.confirmation_number,
            ),

            const SizedBox(height: 24),

            /// TRANSPORTER
            const Text(
              'TRANSPORTER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            CustomTextInput(
              controller: _transporterNameController,
              labelText: 'Name',
              hintText: 'Company or Driver',
              prefixIcon: Icons.person,
            ),

            CustomTextInput(
              controller: _phoneController,
              labelText: 'Phone',
              hintText: '+254 700 000 000',
              prefixIcon: Icons.phone,
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: 'Save',
                    onPressed: () {
                      // Handle save action
                    },
                  ),
                ),
              ],
            ),

            /// SAVE BUTTON
          ],
        ),
      ),
    );
  }
}
