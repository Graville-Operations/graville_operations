import 'package:flutter/material.dart';
import 'package:graville_operations/widgets/form/form_section.dart';

class MaterialPhotoSection extends StatelessWidget {
  const MaterialPhotoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: "Material Photo",
      icon: Icons.image_outlined,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxHeight = 260.0; // <-- control visual size here

            final calculatedHeight = constraints.maxWidth / (6 / 2);

            final height = calculatedHeight > maxHeight
                ? maxHeight
                : calculatedHeight;

            return SizedBox(
              width: double.infinity,
              height: height,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
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
                      const SizedBox(height: 6),
                      const Text(
                        "or select from gallery",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
