import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/sections/form_section.dart';
import 'package:image_picker/image_picker.dart';

final _picker = ImagePicker();

class MaterialPhotoSection extends StatefulWidget {
  const MaterialPhotoSection({
    super.key,
    this.title,
    this.onImagePicked,
    this.cameraDevice = CameraDevice.rear,
    });

    final  String? title;
    final  ValueChanged<File>? onImagePicked;
    final  CameraDevice cameraDevice;

  @override
  State<MaterialPhotoSection> createState() => _MaterialPhotoSectionState();
}

class _MaterialPhotoSectionState extends State<MaterialPhotoSection> {
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: widget.cameraDevice,
      );

      if (!mounted) return;
      
      if (picked == null) {
        setState(() => _isLoading = false);
        return;
      }

      final file = File(picked.path);
      setState(() {
        _imageFile = file;
        _isLoading = false;
        
      });

      widget.onImagePicked?.call(file);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    //final screenHeight = MediaQuery.of(context).size.height;

    return FormSection(
      title:  widget.title ?? "Photo",
      icon: Icons.image_outlined,
      child: Align(
        alignment: Alignment.topCenter,
        child: InkWell(
          onTap: _isLoading ? null : _pickImage,
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _buildContent(),
          ),),
        ),
      ),
    );
  }

Widget _buildContent() {
  if (_isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (_imageFile != null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child:  Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 800,
      ),
    );
  }

  return Center(
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
        )
      ],
    ),
  );
}
}