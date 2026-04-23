import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graville_operations/core/style/color.dart';

class InvoicePhotoPicker extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const InvoicePhotoPicker({
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // color: image == null
            //     ? AppColor.borderColor
            //     : AppColor.primaryBackground,
            width: image == null ? 1.5 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: image == null ? _buildEmptyState() : _buildPreview(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // color: AppColor.primaryBackground.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.camera_alt,
            size: 30,
            // color: AppColor.primaryBackground,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tap to take a photo',
          style: TextStyle(
            // color: AppColor.primaryBackground,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Delivery note, receipt or supporting document',
          // style: TextStyle(color: AppColor.secondaryText, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            image!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                // color: AppColor.primaryBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              // color: AppColor.primaryBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.check, color: Colors.white, size: 12),
                SizedBox(width: 4),
                Text(
                  'Attached',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
