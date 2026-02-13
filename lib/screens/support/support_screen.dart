import 'package:flutter/material.dart';
import 'package:graville_operations/navigation/navigation.dart';
import 'package:graville_operations/screens/commons/widgets/support_tile.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      "FAQ",
      "Contact Support",
      "Terms & Conditions",
      "Privacy Policy",
      "Accessibility",
      "Feedback",
      "About Us",
      "Visit Our Website",
      "Follow us on Social Media",
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Support",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SupportTile(
                title: items[index],
                onTap: () {
                  print(items[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
