import 'dart:io';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch(1).dart';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:image_picker/image_picker.dart';
class MaterialPhotoSection extends StatefulWidget {
  const MaterialPhotoSection({super.key, this.title});

  final String? title;

  @override
  State<MaterialPhotoSection> createState() => _MaterialPhotoSectionState();
}

class _MaterialPhotoSectionState extends State<MaterialPhotoSection> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return FormSection(
      title: widget.title ?? "Photo",
      icon: Icons.image_outlined,
      child: Align(
        alignment: Alignment.topCenter,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: screenHeight * 0.5,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _imageFile == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.camera_alt_outlined),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Tap to capture photo",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
