import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graville_operations/screens/commons/widgets/sections/form_section.dart';

class MaterialPhotoSection extends StatefulWidget {
  const MaterialPhotoSection({
    super.key,
    this.title,
    this.onImagePicked,       
    this.cameraDevice = CameraDevice.rear,
  });

  final String? title;
  final ValueChanged<File>? onImagePicked;
  final CameraDevice cameraDevice;

  @override
  State<MaterialPhotoSection> createState() => _MaterialPhotoSectionState();
}

class _MaterialPhotoSectionState extends State<MaterialPhotoSection> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: widget.cameraDevice,
    );
    if (picked == null) return;
    final file = File(picked.path);
    setState(() => _imageFile = file);
    widget.onImagePicked?.call(file); 
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